-- 2
CREATE DATABASE bdp_cw2;

-- 3
CREATE EXTENSION postgis;

-- 4
CREATE TABLE buildings (
	id INT PRIMARY KEY,
	geometry GEOMETRY,
	name VARCHAR(50)
);

CREATE TABLE roads (
	id INT PRIMARY KEY,
	geometry GEOMETRY,
	name VARCHAR(50)
);

CREATE TABLE poi (
	id INT PRIMARY KEY,
	geometry GEOMETRY,
	name VARCHAR(50)
);

-- 5
INSERT INTO buildings(id,geometry,name) VALUES
(1,'POLYGON((8 4, 10.5 4, 10.5 1.5, 8 1.5, 8 4))','BuildingA');

INSERT INTO buildings(id,geometry,name) VALUES
(2,'POLYGON((4 5, 4 7, 6 7, 6 5, 4 5))','BuildingB');

INSERT INTO buildings(id,geometry,name) VALUES
(3,'POLYGON((3 8, 5 8, 5 6, 3 6, 3 8))','BuildingC');

INSERT INTO buildings(id,geometry,name) VALUES
(4,'POLYGON((9 9, 10 9, 10 8, 9 8, 9 9))','BuildingD');

INSERT INTO buildings(id,geometry,name) VALUES
(5,'POLYGON((1 2, 2 2, 2 1, 1 1, 1 2))','BuildingF');

INSERT INTO roads(id, geometry, name) VALUES
(1, 'LINESTRING(0 4.5, 12 4.5)', 'RoadX');

INSERT INTO roads(id, geometry, name) VALUES
(2, 'LINESTRING(7.5 10.5, 7.5 0)', 'RoadY');

INSERT INTO poi(id, geometry, name) VALUES
(1, 'POINT(1 3.5)', 'G');

INSERT INTO poi(id, geometry, name) VALUES
(2, 'POINT(5.5 1.5)', 'H');

INSERT INTO poi(id, geometry, name) VALUES
(3, 'POINT(9.5 6)', 'I');

INSERT INTO poi(id, geometry, name) VALUES
(4, 'POINT(6.5 6)', 'J');

INSERT INTO poi(id, geometry, name) VALUES
(5, 'POINT(6 9.5)', 'K');

-- 6
-- a)
SELECT SUM(ST_LENGTH(geometry)) AS roads_len FROM roads;

-- b)
SELECT ST_AsText(geometry), ST_AREA(geometry) AS area, ST_PERIMETER(geometry) AS perimeter
FROM buildings
WHERE name = 'BuildingA';

-- c)
SELECT name, ST_AREA(geometry) AS area
FROM buildings
Order BY name;

-- d)
SELECT name, ST_AREA(geometry) AS area, ST_PERIMETER(geometry) AS perimeter
FROM buildings
ORDER BY ST_AREA(geometry) DESC
LIMIT 2;

-- e)
SELECT p.name AS point_name, b.name AS building_name, ST_Distance(b.geometry, p.geometry) AS distance
FROM buildings b
CROSS JOIN poi p
WHERE p.name = 'K' AND b.name = 'BuildingC';

-- f)
SELECT ST_Area(ST_Difference(b1.geometry, ST_Buffer(b2.geometry, 0.5))) AS area
FROM buildings b1
CROSS JOIN buildings b2
WHERE b1.name = 'BuildingC' AND b2.name = 'BuildingB';

-- g)
SELECT b.name
FROM buildings b
CROSS JOIN roads r
WHERE r.name = 'RoadX' AND ST_Y(ST_Centroid(b.geometry)) > ST_Y(ST_Centroid(r.geometry));

-- h)
SELECT ST_Area(geometry) + ST_Area('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))') - ST_Area(ST_Intersection(geometry,'POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))'))
FROM buildings
WHERE name = 'BuildingC';