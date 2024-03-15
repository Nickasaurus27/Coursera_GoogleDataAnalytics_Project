/* All 2021 ride tables have been uploaded to PostgreSQL
-- Going to combine all of the monthly rides tables into a single (massive) table */
CREATE TABLE IF NOT EXISTS all_2021_rides AS 
SELECT *
FROM jan_2021_rides
UNION ALL
SELECT *
FROM feb_2021_rides
UNION ALL
SELECT *
FROM march_2021_rides
UNION ALL
SELECT *
FROM april_2021_rides
UNION ALL
SELECT *
FROM may_2021_rides
UNION ALL
SELECT *
FROM june_2021_rides
UNION ALL
SELECT *
FROM july_2021_rides
UNION ALL
SELECT *
FROM aug_2021_rides
UNION ALL
SELECT *
FROM sept_2021_rides
UNION ALL
SELECT *
FROM oct_2021_rides
UNION ALL
SELECT *
FROM nov_2021_rides
UNION ALL
SELECT *
FROM dec_2021_rides;

--Quick look at the data
SELECT *
FROM all_2021_rides 
LIMIT 10;

--------------------ADDITIONAL COLUMNS TO TABLE

--adding 'ride_length' and 'month_number' columns to table
ALTER TABLE all_2021_rides
ADD COLUMN ride_length INTERVAL,
ADD COLUMN month_number NUMERIC;

/*'ride_length' column will equal 'ended_at' - 'started_at' 
'month_number' is extracted from the 'started_at' column */
UPDATE all_2021_rides
SET ride_length = DATE_TRUNC('minute', ended_at - started_at), 
month_number = EXTRACT(MONTH FROM started_at)
RETURNING ride_length, month_number;

--------------------DATA EXPLORATION

--Quick reference of the data
SELECT *
FROM all_2021_rides 
LIMIT 10;

-------------HIGH-LEVEL OVERVIEW TABLES

--Number of casual vs. annual members
SELECT member_casual, COUNT(*) num_of_members
FROM all_2021_rides
GROUP BY 1;

--Number of ride types in the data
SELECT rideable_type, COUNT(*) ride_type_count
FROM all_2021_rides
GROUP BY 1
ORDER BY 2 DESC;

--Avg. ride length by month
SELECT month_number, 
DATE_TRUNC('minute',AVG(ride_length)) avg_ride_length
FROM all_2021_rides
GROUP BY 1;

--Avg. ride length by weekday
SELECT day_of_week, 
DATE_TRUNC('minute',AVG(ride_length)) avg_ride_length
FROM all_2021_rides
GROUP BY 1;

--Avg. ride length by member type 
	/* Interesting that the avg. ride length for casual riders is more than double that of the 
	annual members */
SELECT member_casual, AVG(ride_length) avg_ride_length
FROM all_2021_rides
GROUP BY 1;

--Getting a glance at the number of bike types each member type uses  
SELECT member_casual, rideable_type, COUNT(*) num_of_members
FROM all_2021_rides
GROUP BY 1,2;

--Count of all members and bike types used by month 
	--This would make for an interesting visualization
SELECT month_number, member_casual, rideable_type, COUNT(*) num_of_members
FROM all_2021_rides
GROUP BY 1,2,3
ORDER BY month_number ASC;

--Number of rides by day of week
	--NOTE: Days of week -> starting from Sunday */
	/*Just want to gauge what this number is
	--Not terribly shocking - the majority of bike rides take place on weekend days
		--Good question to ask: how many of each member type are riding for every day of the week? */ 
SELECT day_of_week, COUNT(*)
FROM all_2021_rides
GROUP BY 1
ORDER BY 1;

--Number of rides by weekday and member type
	--As noted above - casual riders typically have a longer avg. ride length compared to annual riders
	--The avg. length for annual riders stays pretty constant (between 12-15mins) while casual riders have a bit more variation by weekday
SELECT day_of_week, member_casual, COUNT(*) num_of_rides,
DATE_TRUNC('minute',AVG(ride_length)) avg_ride_length
FROM all_2021_rides
GROUP BY 1,2
ORDER BY 1;


--Creating a View with only the necessary columns
	--Eliminating columns like lat and long, etc.
CREATE VIEW IF NOT EXISTS v_bike_rides AS 
SELECT rideable_type, member_casual, month_number,
day_of_week, started_at, ended_at, ride_length
FROM all_2021_rides;

SELECT *
FROM v_bike_rides
LIMIT 10;


--------------------QUERIES FOR DATA VISUALIZATION

--#1 





--#2






--#3




--------------------APPENDIX: ADDITIONAL QUERIES

SELECT 
CASE 
	WHEN month_number = 1 THEN 'January'
	WHEN month_number = 2 THEN 'February' 
	WHEN month_number = 3 THEN 'March' 
	WHEN month_number = 4 THEN 'April'
	WHEN month_number = 5 THEN 'May'
	WHEN month_number = 6 THEN 'June'
	WHEN month_number = 7 THEN 'July'
	WHEN month_number = 8 THEN 'August'
	WHEN month_number = 9 THEN 'September'
	WHEN month_number = 10 THEN 'October'
	WHEN month_number = 11 THEN 'November'
	WHEN month_number = 12 THEN 'December'
	ELSE '-' 
	END as month_name
FROM all_2021_rides
ORDER BY month_number;

