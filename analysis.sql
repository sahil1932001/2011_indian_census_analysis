
-- creating database
create database analysis;
use analysis;

-- displaying datasets

select * from Dataset1;
select * from Dataset2;

-- number of rows in our dataset

select count(*) from Dataset1;
select count(*) from Dataset2;

-- datasets for jharkhand and bihar

select * from Dataset1
where State in ('Jharkhand','Bihar')


-- population of india

select * from Dataset2;
select sum(Population) as total_population from Dataset2;

 -- average growth in percentage for india

 select * from Dataset1;
 select avg(Growth)*100 as avg_growth from Dataset1;


 -- average growth in percentage by states

 select State,avg(Growth)*100 as average_growth from Dataset1
 group by State;


-- average sex ratio by states

 select * from Dataset1;

 select State,avg(Sex_Ratio) as avg_sex_ratio from Dataset1
 group by State 
 order by avg_sex_ratio desc;


 -- average literacy rate by state

 select State,round(avg(Literacy),0) as avg_Literacy from Dataset1
 group by State 
 order by avg_Literacy desc;


-- average literacy rate by state where literacy rate > 90

select State,round(avg(Literacy),0) as avg_Literacy from Dataset1
group by State 
having round(avg(Literacy),0) > 90
order by avg_Literacy desc;


-- top 3 states having highest growth

 select * from Dataset1;

 select top 3 State,round(sum(Growth),2) as growth from Dataset1
 group by State
 order by growth desc;

 -- or

 select top 3 State,round(avg(Growth),3)*100 as growth from Dataset1
 group by State
 order by growth desc;


-- bottom 3 states having lowest sex ratio

 select top 3 State,round(avg(Sex_Ratio),3) as avg_sex_ratio from Dataset1
 group by State
 order by avg_sex_ratio asc;


-- show top 3 and bottom 3 states in Literacy in single table

drop table if exists #topstates

---------------------------------------------------------------------------
---------  we are going to solve this quethion by making temperary table

create table #topstates
( State nvarchar(255),
  top_state float
  )


insert into #topstates

select State,round(avg(Literacy),0) as avg_literacy from Dataset1
group by State 
order by avg_literacy desc;


select top 3 * from #topstates
order by top_state desc;

-------------------------------------------------------

create table #bottomstates
( State nvarchar(255),
  bottom_state float
  )


insert into #bottomstates

select State,round(avg(Literacy),0) as avg_literacy from Dataset1
group by State 
order by avg_literacy desc;


select top 3 * from #bottomstates
order by bottom_state asc;

-------------------------------------
------- lets combined both top and bottom table using union operator

select * from(
select top 3 * from #topstates
order by top_state desc) a

union

select * from(
select top 3 * from #bottomstates
order by bottom_state asc) b;



-- states starting with letter a

select distinct(State) from Dataset1
where State like 'a%';

-- states starting with letter a or b

select distinct(State) from Dataset1
where State like 'a%' or State like 'b%';


-- states starting with letter a and ending with letter m

select distinct(State) from Dataset1
where State like 'a%' and State like '%m';




-- joining both Dataset1 and Dataset2

select * from Dataset1
select * from Dataset2

select a.District,a.State,a.Growth,a.Sex_Ratio,a.Literacy,b.Area_km2,b.Population from Dataset1 as a
inner join
Dataset2 as b
on a.District = b.District;

-- so we have to extract count of male and female 

-------------for that lets see sex_ratio formula

----------------sex_ratio = female/male .......1
---------------population = male+female........2
---------------female = population - male......3
---------------put 3 in 1
----------------sex_ratio*male = population - male
---------------sex_ratio*male + male = population

---------------male(sex_ratio+1) = population

---------------male = population/(sex_ratio+1)    ............male count..........4

----------------put 4 in 2

----------------female = population - population/(sex_ratio+1)...........female count



select a.District,a.State,b.population,floor((b.population/(a.Sex_Ratio*0.001+1))) as male,floor((b.population*(a.Sex_Ratio*0.001))/(a.Sex_Ratio*0.001+1)) as female from Dataset1 as a
inner join
Dataset2 as b
on a.District = b.District

--or


select c.District,c.State,c.population,floor((c.population/(c.Sex_Ratio+1))) as male,floor((c.population*c.Sex_Ratio)/(c.Sex_Ratio+1)) as female from
(select a.District,a.State,a.Growth,a.Sex_Ratio*0.001 as Sex_Ratio,a.Literacy,b.Area_km2,b.Population from Dataset1 as a
inner join
Dataset2 as b
on a.District = b.District
)
c;
 

-- calculating count of male and female state wise

select a.State,sum(floor((b.population/(a.Sex_Ratio*0.001+1)))) as male_count,sum(floor((b.population*(a.Sex_Ratio*0.001))/(a.Sex_Ratio*0.001+1))) as female_count from Dataset1 as a
inner join
Dataset2 as b
on a.District = b.District
group by a.State
order by male_count desc;


--calculate total literacy rate(percentage of student who is educated) by states

select * from Dataset1
select * from Dataset2

------------avg literacy by state
select state, avg(Literacy) as avg_literacy from Dataset1
group by state
order by avg_literacy desc


-- total literate and illeterate count

--------total literate people/population = literacy_ratio

---------total literate people = literacy_ratio*population

--------total illiterate people = (1- literacy_ratio)*population


--total literate and illiterate peoble count by state


select a.State, sum(round((a.literacy/100 *b.population),0)) as literacy_count,sum(round((1-literacy/100)*b.population,0)) as illiteracy_count from Dataset1 as a
inner join
Dataset2 as b
on a.District = b.District
group by a.state 


-- population in previous census

--- previous_pop + growth * previous_pop = new_pop
----- previous_pop = new_pop/(1+growth)


select c.state,round(sum((c.population/(1+Growth))),0) as previous_population,sum(c.population) as current_population from
(select a.district, a.state, a.Growth, b.population from Dataset1 as a
inner join
Dataset2 as b 
on a.District=b.District
) c
group by c.state


-- total population of previous_population and current_population 

select sum(e.previous_population) as total_previous_pop,sum(e.current_population) as total_current_pop from 
(select c.state,round(sum((c.population/(1+Growth))),0) as previous_population,sum(c.population) as current_population from
(select a.district, a.state, a.Growth, b.population from Dataset1 as a
inner join
Dataset2 as b 
on a.District=b.District
) c
group by c.state
) e



-- population vs area

select * from Dataset1
select * from Dataset2


---- we are using this keyy technique to join both (total population,total previous population) and (total area) subquery


select (g.total_area/g.total_previous_pop) as previous_pop_vs_area,(g.total_area/g.total_current_pop) as current_pop_vs_area from
(select q.*,r.total_area from 

(select '1' as keyy,n.* from
(select sum(e.previous_population) as total_previous_pop,sum(e.current_population) as total_current_pop from 
(select c.state,round(sum((c.population/(1+Growth))),0) as previous_population, sum(c.population) as current_population from
(select a.district, a.state, a.Growth, b.population from Dataset1 as a
inner join
Dataset2 as b 
on a.District=b.District
) c
group by c.state
) e
) n
) q

inner join 

(select '1' as keyy,z.* from
(select sum(area_km2) as total_area  from Dataset2) z) r
on q.keyy = r.keyy
)g;

-- getting current_pop_vs_area 0 because of some datatype issue


-- using window function

-- calculate top 3 district from each states which have the highest literacy ratio

select * from Dataset1
select * from Dataset2

select a.state,a.District,a.Literacy from
(select state,district,literacy,rank() over(partition by state order by literacy desc) rnk from Dataset1) a
where a.rnk in (1,2,3) 
