-- Data Cleaning and Exploratory data analysis (EDA) --

-- Business objective: Gain insights into travel patterns, preferences, and behaviors

-- Before upload the data here I standardized the columns with made them lower case and added underscore in spaces
-- I found that there was a format issues in accommodation_cost and transportation_cost columns, there were '$' and 'USD' text into the rows.
-- I uploaded them as text formats, I'll correct it here

-- Data Cleaning 
SELECT *
FROM traveler_dataset;

CREATE TABLE trips1
LIKE traveler_dataset;

SELECT *
FROM trips1;

INSERT trips1
SELECT *
FROM traveler_dataset;

SELECT *
FROM trips1;

-- Data Cleaning --
-- 1. Remove Duplicates
-- 2. Standardized the Data
-- 3. Null Values or blank values
-- 4. Remove, Drops Any Columns or Rows

-- 1. Remove Duplicates

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY trip_id, destination, traveler_name, traveler_nationality, accommodation_type) as row_num
FROM trips1 ;

WITH CTE AS (
	SELECT * ,
    ROW_NUMBER() OVER(
PARTITION BY trip_id, destination, traveler_name, traveler_nationality, accommodation_type) as row_num
FROM trips1
)
SELECT *
FROM CTE
WHERE row_num > 1; -- We don't have any duplicate rows

-- 2. Standardized the Data

SELECT *
FROM trips1;

SELECT DISTINCT destination -- we are gonna split the column by city and country
FROM trips1
ORDER BY destination;

ALTER TABLE trips1
ADD COLUMN city VARCHAR(255),
ADD COLUMN country VARCHAR(255);

UPDATE trips1 
SET
    city = SUBSTRING_INDEX(destination, ', ', 1),
    country = CASE
        WHEN SUBSTRING_INDEX(destination, ', ', 1) = 'Paris' THEN 'France'
        WHEN SUBSTRING_INDEX(destination, ', ', 1) = 'Bali' THEN 'Indonesia'
        WHEN SUBSTRING_INDEX(destination, ', ', 1) = 'Tokyo' THEN 'Japan'
        WHEN SUBSTRING_INDEX(destination, ', ', 1) = 'Sydney' THEN 'Australia'
        WHEN SUBSTRING_INDEX(destination, ', ', 1) = 'Rome' THEN 'Italy'
        WHEN SUBSTRING_INDEX(destination, ', ', 1) = 'New York' THEN 'USA'
        WHEN SUBSTRING_INDEX(destination, ', ', 1) = 'New York City' THEN 'USA'
        WHEN SUBSTRING_INDEX(destination, ', ', 1) = 'Rio de Janeiro' THEN 'Brazil'
        WHEN SUBSTRING_INDEX(destination, ', ', 1) = 'Bangkok' THEN 'Thailand'
        WHEN SUBSTRING_INDEX(destination, ', ', 1) = 'Cancun' THEN 'Mexico'
        WHEN SUBSTRING_INDEX(destination, ', ', 1) = 'Barcelona' THEN 'Spain'
        WHEN SUBSTRING_INDEX(destination, ', ', 1) = 'London' THEN 'UK'
        WHEN SUBSTRING_INDEX(destination, ', ', 1) = 'Vancouver' THEN 'Canada'
        WHEN SUBSTRING_INDEX(destination, ', ', 1) = 'Cape Town' THEN 'South Africa'
        WHEN SUBSTRING_INDEX(destination, ', ', 1) = 'Dubai' THEN 'United Arab Emirates'
        WHEN SUBSTRING_INDEX(destination, ', ', 1) = 'Amsterdam' THEN 'Netherlands'
        WHEN SUBSTRING_INDEX(destination, ', ', 1) = 'Seoul' THEN 'South Korea'
        WHEN SUBSTRING_INDEX(destination, ', ', 1) = 'Los Angeles' THEN 'USA'
        WHEN SUBSTRING_INDEX(destination, ', ', 1) = 'Phuket' THEN 'Thailand'
        WHEN SUBSTRING_INDEX(destination, ', ', 1) = 'Auckland' THEN 'New Zealand'
        WHEN SUBSTRING_INDEX(destination, ', ', 1) = 'Santorini' THEN 'Greece'
        WHEN SUBSTRING_INDEX(destination, ', ', 1) = 'Athens' THEN 'Greece'
        WHEN SUBSTRING_INDEX(destination, ', ', 1) = 'Phnom Penh' THEN 'Cambodia'
        WHEN SUBSTRING_INDEX(destination, ', ', 1) = 'Honolulu' THEN 'Hawaii'
        WHEN SUBSTRING_INDEX(destination, ', ', 1) = 'Berlin' THEN 'Germany'
        WHEN SUBSTRING_INDEX(destination, ', ', 1) = 'Marrakech' THEN 'Morocco'
        WHEN SUBSTRING_INDEX(destination, ', ', 1) = 'Edinburgh' THEN 'Scotland'
        ELSE SUBSTRING_INDEX(destination, ', ', 1)
        END;
  
SELECT *
FROM trips1;

-- changing formats from text to date for start_date, end_date columns

ALTER TABLE trips1
ADD COLUMN new_start_date DATE,
ADD COLUMN new_end_date DATE;

UPDATE trips1
SET 
    new_start_date = STR_TO_DATE(start_date, '%m/%d/%Y'), 
    new_end_date = STR_TO_DATE(end_date, '%m/%d/%Y');     

ALTER TABLE trips1
CHANGE COLUMN new_start_date start_date DATE,
CHANGE COLUMN new_end_date end_date DATE;

SELECT *
FROM trips1;

-- 
SELECT DISTINCT traveler_gender -- looks clean
FROM trips1;

SELECT DISTINCT traveler_nationality
FROM trips1;

SELECT DISTINCT traveler_nationality -- checking with an example
FROM trips1
WHERE traveler_nationality= 'American' OR traveler_nationality= 'USA';

UPDATE trips1
SET 
	traveler_nationality = CASE
		WHEN traveler_nationality = 'UK' THEN 'British'
        WHEN traveler_nationality = 'China' THEN 'Chinese'
        WHEN traveler_nationality = 'Taiwan' THEN 'Taiwanese'
		WHEN traveler_nationality = 'Japan' THEN  'Japanese'
		WHEN traveler_nationality = 'Spain' THEN  'Spanish'
        WHEN traveler_nationality = 'Japan' THEN  'Japanese'
        WHEN traveler_nationality = 'Brazil' THEN  'Brazilian'
        WHEN traveler_nationality = 'Germany' THEN  'German'
        WHEN traveler_nationality = 'South Korea' THEN  'South Korean'
        WHEN traveler_nationality = 'United Kingdom' THEN  'British'
        WHEN traveler_nationality = 'Canada' THEN  'Canadian'
        WHEN traveler_nationality = 'Singapore' THEN  'Singaporean'
        WHEN traveler_nationality = 'Italy' THEN  'Italian'
		WHEN traveler_nationality = 'Greece' THEN  'Greek'
        WHEN traveler_nationality = 'United Arab Emirates' THEN  'Emirati'
        WHEN traveler_nationality = 'Cambodia' THEN  'Cambodian'
        ELSE traveler_nationality
	END;
        
SELECT DISTINCT traveler_nationality
FROM trips1;

-- 
SELECT *
FROM trips1;

SELECT DISTINCT accommodation_type -- looks good
FROM trips1;

SELECT DISTINCT transportation_type
FROM trips1;

UPDATE trips1
SET transportation_type = REPLACE(REPLACE(REPLACE(transportation_type, 'Flight', 'Plane'), 'Airplane', 'Plane'), 'Car rental', 'Car')
WHERE transportation_type IN ('Flight', 'Airplane', 'Car rental');

SELECT DISTINCT transportation_type -- verified
FROM trips1;

SELECT *
FROM trips1
WHERE transportation_type = ''; -- we are not gonna calculate this row

-- changing format from text to int for accomodation_cost and transportation_cost columns and removing '$' and 'USD' texts
SELECT *
FROM trips1;

ALTER TABLE trips1
ADD COLUMN new_accommodation_cost INT,
ADD COLUMN new_transportation_cost INT;

UPDATE trips1
SET 
    new_accommodation_cost = NULLIF(REPLACE(REPLACE(REPLACE(accommodation_cost, '$', ''), ' USD', ''), ',',''), ''),
    new_transportation_cost = NULLIF(REPLACE(REPLACE(REPLACE(transportation_cost, '$', ''), ' USD', ''), ',',''), '');

SELECT *
FROM trips1;

SELECT *
FROM trips1
WHERE TRIM(accommodation_cost) = '' OR TRIM(transportation_cost) = '';

-- 3. Null Values or blank values

SELECT *
FROM trips1
WHERE traveler_name IS NULL;

-- 4. Remove, Drops Any Columns or Rows

SELECT *
FROM trips1
WHERE new_transportation_cost IS NULL;

DELETE
FROM trips1
WHERE new_transportation_cost IS NULL;


CREATE TABLE `trips2` (
  `trip_id` int DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `new_start_date` date DEFAULT NULL,
  `new_end_date` date DEFAULT NULL,
  `duration_days` int DEFAULT NULL,
  `traveler_name` text,
  `traveler_age` int DEFAULT NULL,
  `traveler_gender` text,
  `traveler_nationality` text,
  `accommodation_type` text,
  `new_accommodation_cost` int DEFAULT NULL,
  `transportation_type` text,
  `new_transportation_cost` int DEFAULT NULL
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM trips2;

INSERT trips2
SELECT trip_id, city, country, new_start_date, new_end_date, duration_days, traveler_name, traveler_age, traveler_gender, traveler_nationality,
accommodation_type, new_accommodation_cost, transportation_type, new_transportation_cost
FROM trips1;

SELECT *
FROM trips2;

SELECT COUNT(trip_id) -- Verified
FROM trips2;

-- Exploratory data analysis (EDA) --

--  which years this data covers?
SELECT 
    MIN(new_start_date) AS min_start_date,
    MAX(new_end_date) AS max_end_date
FROM trips2;

-- What is the age distribution of travelers?
SELECT traveler_age, COUNT(*) AS num_trips
FROM trips2
GROUP BY traveler_age
ORDER BY traveler_age;

-- How does the average trip duration vary by age group? Is there a correlation between traveler age and trip duration?
SELECT 
	CASE
		WHEN traveler_age < 30 THEN '<30'
        WHEN traveler_age BETWEEN 30 AND 39 THEN '30-39'
		WHEN traveler_age BETWEEN 40 AND 49 THEN '40-49'
        WHEN traveler_age BETWEEN 50 AND 59 THEN '50-59'
        ELSE '60+'
	END AS age_group,
    AVG(duration_days) AS avg_duration_days
    FROM trips2
    GROUP BY age_group
    ORDER BY age_group;

-- Are there significant differences in travel preferences (destinations, accommodation, transportation) 
-- between male and female travelers?
-- 1-accommodation preference by gender
SELECT accommodation_type,
COUNT(CASE WHEN traveler_gender = 'Male' THEN 1 END) as male_count,
COUNT(CASE WHEN traveler_gender = 'Female' THEN 1 END) as female_count
FROM trips2
GROUP BY accommodation_type
ORDER BY accommodation_type;

-- 2-country preference by gender
SELECT country,
COUNT(CASE WHEN traveler_gender = 'Male' THEN 1 END) as male_count,
COUNT(CASE WHEN traveler_gender = 'Female' THEN 1 END) as female_count
FROM trips2
GROUP BY country
ORDER BY country;

-- 3-transportation preference by gender
SELECT transportation_type,
COUNT(CASE WHEN traveler_gender = 'Male' THEN 1 END) as male_count,
COUNT(CASE WHEN traveler_gender = 'Female' THEN 1 END) as female_count
FROM trips2
GROUP BY transportation_type
ORDER BY transportation_type;

-- Do travelers from certain countries prefer specific destinations?
SELECT 
	traveler_nationality, 
    city,
	COUNT(*) AS trip_count
FROM trips2
GROUP BY traveler_nationality, city
ORDER BY Traveler_nationality, trip_count DESC;

-- What are the top 10 most visited destinations?
SELECT 
	city, 
    COUNT(*) as num_trips
FROM trips2
GROUP BY city
ORDER BY num_trips DESC
LIMIT 10;

-- Are there seasonal trends in the popularity of certain destinations? 
WITH travel_data_with_month AS (
    SELECT 
        *,
        MONTH(new_start_date) AS start_month
    FROM trips2
)
SELECT
	start_month,
    country,
    COUNT(*) AS num_trip
FROM travel_data_with_month
GROUP BY start_month, country
ORDER BY start_month, num_trip DESC;

-- Avg accommodation cost by accommodation type
SELECT 
	accommodation_type,
    AVG(new_accommodation_cost) AS avg_accommodation_cost
FROM trips2
GROUP BY accommodation_type
ORDER BY avg_accommodation_cost DESC;

-- Avg transportation cost by transportation type
SELECT 
	transportation_type,
    AVG(new_transportation_cost) AS avg_transportation_cost
FROM trips2
GROUP BY transportation_type
ORDER BY avg_transportation_cost DESC;


-- How do travel costs vary by gender?
SELECT 
	    traveler_gender,
    AVG(new_accommodation_cost + new_transportation_cost) as avg_total_cost
FROM trips2
GROUP BY traveler_gender
ORDER BY traveler_gender;




