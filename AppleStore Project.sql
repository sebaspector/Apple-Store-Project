--Dividí el archivo original en 4 por tamaño, creo tabla combinada de los 4.
CREATE TABLE Apple_Store_combined as

SELECT * FROM appleStore_description1

UNION ALL

SELECT * FROM appleStore_description2

UNION ALL

SELECT * FROM appleStore_description3

UNION ALL

SELECT * FROM appleStore_description4

--Checkeo que ambas tengan las mismas filas (AppleStore tenía dos filas con missing values que eliminé)
SELECT COUNT(*) FROM Apple_Store_combined
SELECT COUNT(*) FROM AppleStore

--Qué tipo de aplicación crear?
--EDA (Exploratory Data Analysis)
select
	prime_genre,
	avg(price)
from AppleStore
group by prime_genre

--Checkeo el numero de aplicaciones únicas

SELECT COUNT(DISTINCT id) as UniqueApp_ID
from AppleStore

--Checkeo missing values

SELECT COUNT(*) as Missing_values
from AppleStore
where track_name is null or user_rating is null or prime_genre is null

--Número de apps por género

select 
	prime_genre,
    count(*) as num_apps
from AppleStore
group by prime_genre
order by num_apps desc

--Overview de ratings

select 
	min(user_rating),
    max(user_rating),
    avg(user_rating)
from AppleStore

--Data Analysis
--Aplicaciones pagas tienen mas ranking que aplicaciones no pagas (en promedio, las aplicaciones pagas tienen rating
--de 0.35 más alto que las no pagas)
SELECT
	CASE WHEN PRICE>0 THEN 'Aplicación_paga'
    else 'Aplicacion_no_paga'
    end as Tipo_aplicación,
    avg(user_rating)
from AppleStore
group by Tipo_aplicación

--Checkeo si aplicaciones con mas lenguajes tienen más rating (en promedio, entre 10 y 30 lenguajes tiene el rating más alto)

SELECT
	CASE WHEN lang_num < 10 THEN '<10 languages'
    when lang_num between 10 and 30 then '10-30 languages'
    else '>30 languages'
    end as languages_bucket,
    avg(user_rating)
from AppleStore
group by languages_bucket
order by avg(user_rating) desc

--Checkeo géneros con bajo rating

SELECT
	prime_genre,
    avg(user_rating)
from AppleStore
group by prime_genre
ORDER BY avg(user_rating)
LIMIT 10

--Correlation App description length y user_rating (más larga descripción, mayor rating en promedio)
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

--Checkeo apps mejor rankeadas por género

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

--Recomendaciones
--1) Aplicacion paga tiene mas rating que la gratuita en promedio, usuarios que pagan apps tienen mayor 
--engagement y encuentran más valor, llevando a mayor rating
--2) Aplicaciones que tienen entre 10 y 30 lenguajes tienen el mayor rating, es mejor enfocarse en algunos lenguajes
--que tener mas de 30.
--3) Categorias como Catalogue, Finance y Book tienen menores ratings, crear aplicaciones de calidad en estas
-- categorías hay potencial para mejores ratings y penetración.
--4) La longitud de la descripción de la aplicación correlaciona positivamente con mayor rating
--5) Nuevas aplicaciones deberían apuntar a tener rating > 3.5, que es el promedio actual del mercado
--6) Games y Enternainment tienen alto número de aplicaciones, lo cual indica saturación de esos mercados
      
      
