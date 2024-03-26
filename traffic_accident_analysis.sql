/* 
    Toronto KSI
    An SQL analysis about each collisions where a a person was Killed or Seriously Injured (KSI) within the city of Toronto,
    this dataset is under the Toronto Police Service Public Safety Data Portal.
    Data has been modified and cleaned and some unnecessary columns were removed.

    Author: Arsalan Moaddeli
    Email: Arsalanmod2003@gmail.com


    column_name
    ---------------------------|
    accident_id              
    accident_year              
    accident_date              
    accident_time 
    street1
    street2
    road_class
    district
    latitude
    longitude
    loccoord
    accloc
    traffctl
    visibility
    light
    rdsfcond
    acclass
    impactype
    invtype
    invage
    injury
    initdir
    vehtype
    manoeuver
    drivact
    drivcond
    pedtype 
    pedact
    pedcond 
    cyclistype
    cycact 
    cyccond
    pedestrian 
    cyclist
    automobile
    motorcycle 
    truck
    passenger
    speeding
    ag_driv
    redlight
    alcohol
    disability
    neighbourhood_158
    neighbourhood_140

*/

-- What is the total count of recorded crashes in the dataset?

SELECT count(*) AS total_accidents FROM accident;


-- Results:

total_accidents |
----------------+
18194           |

-- What is the earliest and latest date of hte recorded accident?

SELECT 
	min(accident_date) AS earliest_accident_date,
	max(accident_date) AS latest_accident_date
FROM 
    accident;*/

--Results:

earliest_accident_date    | latest_accident_date    |
--------------------------+-------------------------+
 2006/01/01 05:00:00+00	  |  2022/12/30 05:00:00+00 |

-- What is the number of reported accident per year?

SELECT 
    accident_year,
    count(*) AS reported_accidents
FROM 
    accident
GROUP BY 
    accident_year
ORDER BY 
    accident_year;
	
--Results:

accident_year |  accident_year|
--------------+---------------+
	2006  |		1483  |
	2007  |		1474  |
	2008  |		1239  |
	2009  |		1242  |
	2010  |		1190  |
	2011  |		1179  |
	2012  |		1348  |
	2013  |		1232  |
	2014  |		916   |
	2015  |		929   |
	2016  |		1006  |
	2017  |		980   |
	2018  |		1074  |
	2019  |		940   |
	2020  |		640   |
	2021  |		621   |
	2022  |		701   |

-- Compare the year 2009 to the year 2013 to see the differences.

WITH getYear_2010 AS (
	SELECT 
		accident_year,
		MONTH(accident_date) AS accident_month,
		count(*) AS accident_count
	FROM
		accident
	WHERE
		accident_year = '2010'
	GROUP BY
		accident_year,
		MONTH(accident_date)
	),
	getYear_2020 AS (
		SELECT 
			accident_year,
			MONTH(accident_date) AS accident_month,
			count(*) AS accident_count
		FROM
			accident
		WHERE
			accident_year = '2020'
		GROUP BY
			accident_year,
			MONTH(accident_date)
	),
	getYear_difference AS (
		SELECT 
			/*DateName(month, DateADD(month, get2009.accident_month, 0)-1) AS */
			get2010.accident_month,
			get2010.accident_count AS count_2010,
			get2020.accident_count AS count_2020,
			get2020.accident_count - get2010.accident_count AS count_difference
		FROM
			getYear_2010 AS get2010
		JOIN
			getYear_2020 AS get2020
		ON get2010.accident_month = get2020.accident_month
		
			
	)
	SELECT 
		DateName( month , DateAdd( month , accident_month , 0 ) - 1 ) as accident_month,
		count_2010,
		count_2020,
		count_difference,
		CASE	
			WHEN count_difference >= (count_2020 * 0.5) THEN 'Over 50% Difference'
			WHEN count_difference >= (count_2020 * 0.4) THEN 'Over 50% Difference'
			WHEN count_difference >= (count_2020 * 0.3) THEN 'Over 50% Difference'
			WHEN count_difference >= (count_2020 * 0.2) THEN 'Over 50% Difference'
			ELSE 'No Significant Difference'
		END AS difference_percentage_range
	FROM
		getYear_difference
	ORDER BY
			month(accident_month);

--Results:

accident_month | count_2010 | count_2020 | count_difference | Difference_percentage_range |
------------------------------------------------------------------------------------------+
January	       | 131        | 68         | -63              | No Significant Difference   |
February       | 63         | 53         | -10              | No Significant Difference   |
March          | 82         | 51         | -31              | No Significant Difference   |
April	       | 92	    | 17         | -75              | No Significant Difference   |
May	       | 92	    | 49         | -43              | No Significant Difference   |
June	       | 127        | 54         | -73              | No Significant Difference   |
July	       | 145        | 62         | -83              | No Significant Difference   |
August	       | 69	    | 66         | -3               | No Significant Difference   |
September      | 109        | 73         | -36              | No Significant Difference   |
October	       | 114        | 54         | -60              | No Significant Difference   |
November       | 95         | 48         | -47              | No Significant Difference   |
December       | 71         | 45         | -26              | No Significant Difference   |


-- Create a new temp table that is called accident_temp which contains the record of datas from 2019 to 2022

DROP TABLE IF EXISTS #accident_temp; 
SELECT * INTO #accident_temp FROM accident; 

insert into #accident_temp 
SELECT * FROM accident 
		WHERE accident_year BETWEEN '2019' AND '2022'

SELECT 
	min(accident_date) AS min_date,
	max(accident_date) AS max_date
FROM 
	#accident_temp;
	
-- Results:

min_date   |  max_date  |
------------------------+
2006-01-01 |  2022-12-30|

-- What is the total count of #accident_temp table?

SELECT count(*) AS total_record FROM #accident_temp

-- Results:

total_record   |
---------------+
21096          |


-- What are the different type of lighting conditions and their counts?

SELECT 
	DISTINCT light,
	count(*) AS accident_count
FROM
	accident
GROUP BY 
	light
ORDER BY 
	light
	
-- Results:

	light        | accident_count  |
---------------------+-----------------+
Dark	             | 3687            |
Dark, artificial     | 3302            |
Dawn	             | 110             |
Dawn, artificial     | 101             |
Daylight	     | 10388           |
Daylight, artificial | 141             |
Dusk	             | 240             |
Dusk, artificial     | 219             |
Other	             | 6               |



-- What is the hourly % change in crash frequency and how often do crashes occur in relation to the time of day?

WITH most_accident_hours AS (
    SELECT 
        DATEPART(HOUR, accident_time) AS accident_hour,
        COUNT(*) AS hour_count
    FROM
        #accident_temp
    GROUP BY
        DATEPART(HOUR, accident_time)
)
SELECT 
    CASE 
        WHEN accident_hour = 0 THEN '12 AM'
        WHEN accident_hour < 12 THEN CONVERT(VARCHAR(2), accident_hour) + ' AM'
        ELSE CONVERT(VARCHAR(2), accident_hour - 12) + ' PM'
    END AS hour_of_day,
    hour_count,
    ROUND(100 * (hour_count * 1.0 / (SELECT COUNT(*) FROM #accident_temp)), 2) AS avg_of_total,
    ROUND(100 * (hour_count - LAG(hour_count) OVER (ORDER BY accident_hour)) / NULLIF(LAG(hour_count) OVER (ORDER BY accident_hour), 0), 2) AS hour_to_hour
FROM
    most_accident_hours
ORDER BY
    accident_hour ASC;


-- Results:

hour_of_day|  hour_count  | avg_of_total  | hour_to_hour|
-----------+--------------+---------------+-------------+
12 AM	   |	601	  | 3.300000000000|	        |
1 AM	   |	429	  | 2.360000000000|	-28     |
2 AM	   |	490	  | 2.690000000000|	14      |
3 AM	   |	446	  | 2.450000000000|	-8      |
4 AM	   |	181	  | 0.990000000000|	-59     |
5 AM	   |	304	  | 1.670000000000|	67      |
6 AM	   |	547	  | 3.010000000000|	79      |
7 AM	   |	569	  | 3.130000000000|	4       |
8 AM	   |	693	  | 3.810000000000|	21      |
9 AM	   |	732	  | 4.020000000000|	5       |
10 AM	   |	753	  | 4.140000000000|	2       |
11 AM	   |	789	  | 4.340000000000|	4       |
12 PM	   |	797	  | 4.380000000000|	1       |
1 PM	   |	893	  | 4.910000000000|	12      |
2 PM	   |	1016	  | 5.580000000000|	13      |
3 PM	   |	1077	  | 5.920000000000|	6       |
4 PM	   |	1075	  | 5.910000000000|	0       |
5 PM	   |	1177	  | 6.470000000000|	9       |
6 PM	   |	1220	  | 6.710000000000|	3       |
7 PM	   |	1051	  | 5.780000000000|	-13     |
8 PM	   |	994	  | 5.460000000000|	-5      |
9 PM	   |	911	  | 5.010000000000|	-8      |
10 PM	   |	797	  | 4.380000000000|	-12     |
11 PM	   |	652	  | 3.580000000000|	-18     |
  

-- What are the top 5 impact type?

WITH get_impact_type AS (
	SELECT
		impactype,
		count(*) AS accident_count,
		RANK() OVER (ORDER BY count(*) desc) AS accident_rank
	FROM 
		#accident_temp
	GROUP BY
		impactype
)
SELECT
	impactype AS accident_type,
	accident_count
FROM
	get_impact_type
WHERE
	accident_rank <= 5;

-- Results:

get_impact_type      | accident_count |
---------------------+----------------+
Pedestrian Collisions| 7295           |
Turning Movement     | 2792	      |
Cyclist Collisions   | 1795	      |
Rear End	     | 1746   	      |
SMV Other	     | 1460	      |


-- What types of road conditions exist, and how many crashes occur?

SELECT
	DISTINCT rdsfcond,
	count(*) AS accident_count
FROM 
	#accident_temp
GROUP BY
	rdsfcond
ORDER BY 
	accident_count DESC;

-- Results:

rdsfcond             | accident_count |
---------------------+----------------+
Dry		     | 14599	      |
Wet		     | 3021	      |
Loose Snow	     | 169	      |
Other		     | 145            |
Slush		     | 102	      | 
Ice		     | 77	      |
Packed Snow	     | 44	      |
NULL	             | 25	      |
Loose Sand or Gravel | 11	      |
Spilled liquid	     | 1	      |



-- What types of manoeuver exists, and how many are they?

SELECT 
	manoeuver, 
	count(*) AS accident_count
FROM
	#accident_temp
GROUP BY
	manoeuver
ORDER BY 
	accident_count

-- Results:


manoeuver			    | accident_count |
------------------------------------+----------------+
Disabled	   		    | 4              |
Pulling Onto Shoulder or towardCurb | 18             |
Merging				    | 18             |
Pulling Away from Shoulder or Curb  | 40             |
Overtaking			    | 91             |
Making U Turn			    | 106            |
Reversing			    | 122            |
Unknown				    | 122            |
Other				    | 181            |
Parked				    | 183            |
Changing Lanes			    | 216            |
Slowing or Stopping		    | 282            |
Turning Right			    | 476            |
Stopped				    | 620            |
Turning Left			    | 1786           |
Going Ahead			    | 6269           |
NULL				    | 7660           |


-- What single day has the most amount of fatal accidents?

SELECT TOP 10
	accident_date,
	visibility,
	count(*) AS fatality_counts,
	dense_RANK() OVER (ORDER BY count(*) desc) AS date_rank
FROM 
	#accident_temp
GROUP BY
	accident_date,
	visibility
ORDER BY
	fatality_counts DESC

-- Results:


accident_date | visibility | fatality_counts | date_rank |
--------------+------------+-----------------+-----------+
2014-08-17    | Clear	   |    35           |  1	 |
2007-09-01    | Clear	   |	24	     |	2	 |
2012-07-20    | Clear	   |	23	     |	3	 |
2016-03-20    | Clear	   |	22	     |	4	 |
2007-04-17    | Clear	   |	22	     |	4	 |
2011-08-30    | Clear	   |	21	     |	5	 |
2007-07-18    | Clear	   |	21	     |	5	 |
2007-07-22    | Clear	   |	20	     |	6	 |
2006-08-18    | Clear	   |	20	     |  6	 |
2006-08-22    | Clear	   |	19	     |  7	 |





