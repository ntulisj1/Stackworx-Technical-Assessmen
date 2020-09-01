-- Requirement 1
SELECT personnel_id, count(place_id) visitedPlaces FROM personnel_whereabouts 
group by personnel_id
order by count(place_id) desc limit 1

-- Requirement 2
SELECT place_id, personnel_id, count(personnel_id) personVisited FROM personnel_whereabouts 
group by place_id, personnel_id
order by count(personnel_id) desc

-- Requirement 3
select  p.id, pw.personnel_id,
case when pw.personnel_id is null then 'False' else 'True' 
end 
from place p 
left OUTER JOIN personnel_whereabouts pw 
on p.id = pw.place_id  
group by p.id, pw.personnel_id
order by pw.personnel_id 


-- Requirement 3b
-- select  p.id, p2.id, 
-- case when p.id is null then 'False' else 'True' 
-- end 
-- from place p 
-- left OUTER JOIN personnel_whereabouts pw 
-- on p.id = pw.place_id
-- right join personnel p2 
-- on pw.personnel_id = p2.id 
-- group by p.id, p2.id, pw.personnel_id
-- order by p.id 

-- Requirement 4
-- This was is not running I failed to config Postgres postgis so that I can be able to use GEOGRAPHY
DECLARE
@GEO1 GEOGRAPHY,
@LAT VARCHAR(10),
@LONG VARCHAR(10)

SET @LAT='23.012034'
SET @LONG='72.510754'

SET @geo1= geography::Point(@LAT, @LONG, 4326)

SELECT LOC_ID,LOC_NAME,(@geo1.STDistance(geography::Point(ISNULL(LAT,0), _
ISNULL(LONG,0), 4326))) as DISTANCE  FROM PLACE

-- Requirement 5
-- Make ID's primary key
ALTER TABLE place 
ADD PRIMARY KEY (ID)

ALTER TABLE personnel 
ADD PRIMARY KEY (ID)

ALTER TABLE personnel_whereabouts 
ADD PRIMARY KEY (ID)

-- Change column double to int
ALTER TABLE personnel_whereabouts ALTER COLUMN place_id TYPE int USING place_id::int;
ALTER TABLE personnel_whereabouts ALTER COLUMN personnel_id TYPE int USING personnel_id::int;

-- Add Foreign key in a relationship table
ALTER TABLE personnel_whereabouts 
ADD FOREIGN KEY (personnel_id) REFERENCES personnel(id);

ALTER TABLE personnel_whereabouts 
ADD FOREIGN KEY (place_id) REFERENCES place(id);

-- Due to time I could not be able to finish the rest location questions postgis configs