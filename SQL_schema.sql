
DROP TABLE IF EXISTS accident;

CREATE TABLE accident(
    accident_id int PRIMARY key,
    accident_year varchar(4),
    accident_date date,
    accident_time time(0),
    street1 varchar(50),
    street2 varchar(50),
    road_class varchar(30),
    district varchar(30),
    latitude varchar(25),
    longitude varchar(25),
    loccoord varchar(40),
    accloc varchar(40),
    traffctl varchar(20),
    visibility varchar(40),
    light varchar(20),
    rdsfcond varchar(30),
    acclass varchar(30),
    impactype varchar(30),
    invtype varchar(20),
    invage varchar(10),
    injury varchar(10),
    initdir varchar(10),
    vehtype varchar(40),
    manoeuver varchar(40),
    drivact varchar(40),
    drivcond varchar(50),
    pedtype varchar(100),
    pedact varchar(50),
    pedcond varchar(40),
    cyclistype varchar(100),
    cycact varchar(40),
    cyccond varchar(40),
    pedestrian varchar(5),
    cyclist varchar(5),
    automobile varchar(5),
    motorcycle varchar(5),
    truck varchar(5),
    passenger varchar(5),
    speeding varchar(5),
    ag_driv varchar(5),
    redlight varchar(5),
    alcohol varchar(5),
    disability varchar(5),
    neighbourhood_158 varchar(50),
    neighbourhood_140 varchar(50)
);

BULK INSERT accident
FROM 'C:\Users\Tarahan\Downloads\SQL traffic crash\KSI-1.csv'
WITH (
    FIELDTERMINATOR = ',', 
	ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    FORMAT = 'CSV'
);

-- Test the record count
SELECT * FROM accident



