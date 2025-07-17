drop table if exists Netflix_Data;

create table Netflix_Data(
show_id varchar(50),
type varchar(100),
title varchar(150),
director char(250),
casts varchar(1000),
country char(200),
date_added varchar(50),
release_year int,
rating varchar(20),
duration varchar(20),
listed_in varchar(100),
description varchar(280)
);

select * from Netflix_Data;

select count(*) from Netflix_Data;

select distinct(type) from Netflix_Data;
select distinct(listed_in)from  Netflix_Data;

--1. count the number of movies and tv shows--

select * from Netflix_Data;

select type,
count(*)as No_of_types
from Netflix_Data
group by type;


--2. find the most common rating of tv shows and movies--

select type,rating
from (

select type,rating,
count(*) as common_rating,
rank() over(partition by type order by count(*)desc)as ranking
from Netflix_Data
group by type,rating
--this is optional--
order by common_rating desc


) as t1

where ranking=1;

--3. list all movies that was release in a specific year(eg 2000)--

select * from Netflix_Data;

select type,release_year
from Netflix_Data
where type='Movie' and (release_year=2020)
group by type,title,release_year;

select count(type)
from Netflix_Data
where type='Movie'and (release_year=2020);

--4. Find the top 5 countries with most content on netflix--

select * from Netflix_Data;

select count(show_id)as No_of_content,unnest(string_to_array(country,','))as new_country
from Netflix_Data
group by new_country
order by No_of_content desc
limit 5;

select 
unnest(string_to_array(country,',')) as New_Country
from Netflix_Data;

--5. identify the longest movie or television on the basis of duration--

select *
from Netflix_Data
where type='Movie' and duration=(select max(duration) from Netflix_Data)
;

--6. Find content added in last five year--

select * from Netflix_Data
where To_date(date_added,'Month DD,YYYY')>= current_date-interval '5 years';

select * from Netflix_Data;

--update Netflix_Data
--set date_added= To_char(to_date(date_added,'Month DD, YYYY'), 'DD-MM-YYYY');

--7. find all movies and tv show by the director Rajiv Chilaka

select * from Netflix_Dataselect
where director ilike'%Rajiv Chilaka%';

--8. list all tv shows more than five seasons--
select * from Netflix_Data;

select * 
from 
Netflix_Data
where type='TV Show' and split_part(duration,' ' ,1)::numeric > 5;

--9.count the number of content items in each genere
select * from Netflix_Data;

select unnest(string_to_array(listed_in,','))as Genre, count(show_id) as Total_content
from Netflix_Data
group by Genre;

10. Find each year and the average numbers of content release by Indian on netflix,
return top 5 year with the highest avg content release.

select * from Netflix_Data;

--Truncate table Netflix_Data;--
SELECT 
  extract(year from to_date(date_added, 'Month DD, YYYY')) as year_added,
  count(*),
  Round(count(*)::numeric/(select count(*) from Netflix_Data where country='India')::numeric * 100,2) as avg_count_peryear
FROM Netflix_Data
WHERE Country = 'India'
group by year_added;

11. List all the movies that are documentaries.


select * from Netflix_Data;
select type,title, listed_in from Netflix_Data
where type='Movie'
and
listed_in ilike'%Documentaries%';

12.Find all the content without a director
select * from Netflix_Data;

select show_id, director from Netflix_Data
where director is null;

13. Find in how many movies actor salman khan appear in  last 10 years
select * from Netflix_Data;

select *
from Netflix_Data 
where casts ilike '%Salman Khan%'
and
release_year >= extract(year from current_date)-10;

select * from Netflix_Data
where casts ilike '%Salman Khan%'

14. Find the top 10 actors who have appeared in the highest number of movies produced in India

select * from Netflix_Data;

select type,unnest(string_to_array(country,',')) as Country_Produced, 
unnest(string_to_array(casts,','))as casts_Movie,
count(*) as total_content
from Netflix_Data
where type='Movie' and country ilike '%India%'
group by  type,Country_Produced, casts_Movie
order by total_content desc
limit 10;
--15. find the content having Kill or Violence in their description name them as Bad Content and else as good content
with new_table as
(
select *,
case
when description ilike '%kill%'
or description ilike'%violence%' then 'Bad Content'
Else 'Good Content'
END category
from Netflix_Data
) select category,count(*) total_number
from new_table
group by category;


where description ilike '%kill%'
or description ilike'%violence%';





 

