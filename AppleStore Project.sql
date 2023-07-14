CREATE TABLE Apple_Store_combined as

SELECT * FROM appleStore_description1

UNION ALL

SELECT * FROM appleStore_description2

UNION ALL

SELECT * FROM appleStore_description3

UNION ALL

SELECT * FROM appleStore_description4

--Check that both files contain same amount of rows (AppleStore had 2 rows with missing values that I deleted)
SELECT COUNT(*) FROM Apple_Store_combined
SELECT COUNT(*) FROM AppleStore

--What type of app to create?
--EDA (Exploratory Data Analysis)
select
	prime_genre,
	avg(price)
from AppleStore
group by prime_genre

--Check nª of unique apps

SELECT COUNT(DISTINCT id) as UniqueApp_ID
from AppleStore

--Missing values

SELECT COUNT(*) as Missing_values
from AppleStore
where track_name is null or user_rating is null or prime_genre is null

--Nª of apps by genre

select 
	prime_genre,
    count(*) as num_apps
from AppleStore
group by prime_genre
order by num_apps desc

--Ratings overview

select 
	min(user_rating),
    max(user_rating),
    avg(user_rating)
from AppleStore

--Data Analysis
--Paid applications have higher rankings than free applications (on average, paid applications have a rating that is 0.35 higher than free applications).
SELECT
	CASE WHEN PRICE>0 THEN 'Aplicación_paga'
    else 'Aplicacion_no_paga'
    end as Tipo_aplicación,
    avg(user_rating)
from AppleStore
group by Tipo_aplicación

--Apps with more languages have higher ratings?. On average, applications that support between 10 and 30 languages have the highest rating.

SELECT
	CASE WHEN lang_num < 10 THEN '<10 languages'
    when lang_num between 10 and 30 then '10-30 languages'
    else '>30 languages'
    end as languages_bucket,
    avg(user_rating)
from AppleStore
group by languages_bucket
order by avg(user_rating) desc

--Genres with low rating

SELECT
	prime_genre,
    avg(user_rating)
from AppleStore
group by prime_genre
ORDER BY avg(user_rating)
LIMIT 10

--Correlation between App description length y user_rating (the longer the description, the higher its rating, in average)
select
	case when length(app_desc) < 500 then 'Short'
    when length(app_desc) between 500 and 1000 then 'Medium'
    else 'Long'
    end as description_length_bucket,
    avg(user_rating)
from AppleStore a
join Apple_Store_combined b on a.id = b.id
group by description_length_bucket
order by avg(user_rating) desc

--Apps best ranked by genre

select
	prime_genre,
    track_name,
    user_rating
from (SELECT
      	prime_genre,
      	track_name,
      	user_rating,
      	rank() over(partition by prime_genre order by user_rating desc, rating_count_tot desc) as ranking
      from AppleStore) a
where ranking = 1 

--Recommendations--

--1) Paid applications have higher ratings on average compared to free applications. Users who pay for apps tend to have higher engagement and find more value, leading to higher ratings.
--2) Applications that support between 10 and 30 languages have the highest ratings. It is better to focus on a select few languages rather than supporting more than 30.
--3) Categories such as Catalogue, Finance, and Book have lower ratings. Creating high-quality applications in these categories presents an opportunity for better ratings and market penetration.
--4) The length of the application description positively correlates with higher ratings.
--5) New applications should aim for a rating higher than 3.5, which is the current market average.
--6) The Games and Entertainment categories have a high number of applications, indicating market saturation in those areas.
      
      
