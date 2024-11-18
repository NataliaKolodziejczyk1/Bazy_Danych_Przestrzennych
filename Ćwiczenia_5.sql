CREATE EXTENSION postgis;

-- 1
CREATE TABLE obiekty (
	id INT PRIMARY KEY,
	name VARCHAR(50),
	geometry GEOMETRY
);


-- a
INSERT INTO obiekty(id, name, geometry)
VALUES
(1, 'obiekt1', (ST_Collect(ARRAY [ST_GeomFromText('LINESTRING(0 1, 1 1)'),
	ST_GeomFromText('CIRCULARSTRING(1 1, 2 0, 3 1)'),
	ST_GeomFromText('CIRCULARSTRING(3 1, 4 2, 5 1)'),
	ST_GeomFromText('LINESTRING(5 1, 6 1)')])));

-- b
INSERT INTO obiekty(id, name, geometry)
VALUES
(2, 'obiekt2', ST_Collect(ARRAY [ST_GeomFromText('LINESTRING(10 6, 10 2)'),
	ST_GeomFromText('CIRCULARSTRING(10 2, 12 0, 14 2)'),
	ST_GeomFromText('CIRCULARSTRING(14 2, 16 4, 14 6)'),
	ST_GeomFromText('LINESTRING(14 6, 10 6)'),
	ST_GeomFromText('CIRCULARSTRING(11 2, 13 2, 11 2)')]));

-- c
INSERT INTO obiekty(id, name, geometry)
VALUES
(3, 'obiekt3', ST_GeomFromText('POLYGON((7 15, 10 17, 12 13, 7 15))'));

-- d
INSERT INTO obiekty(id, name, geometry)
VALUES
(4, 'obiekt4', ST_GeomFromText('LINESTRING(20 20, 25 25, 27 24, 25 22, 26 21,22 19, 20.5 19.5)'));

-- e
INSERT INTO obiekty(id, name, geometry)
VALUES
(5, 'obiekt5', ST_Collect('POINT(30 30 59)','POINT(38 32 234)'));

-- f
INSERT INTO obiekty(id, name, geometry)
VALUES
(6, 'obiekt6', ST_Collect(ST_GeomFromText('LINESTRING(1 1, 3 2)'),ST_GeomFromText('POINT(4 2)')));

SELECT * FROM obiekty;

-- 2
SELECT ST_Area(ST_Buffer(ST_ShortestLine(o1.geometry,o2.geometry),5)) AS pole_powierzchni FROM obiekty o1
CROSS JOIN obiekty o2
WHERE o1.name = 'obiekt3' AND o2.name = 'obiekt4';

-- 3
-- obiekt 4 to nie jest poligon dlatego, że z definicji poligona wynika, że jest to dowolna zamknięta linia łamana.
-- ten obiekt nie jest zamknięty, a więc jest linią łamaną ale nie poligonem. 
-- aby zamienić obiekt4 na poligon należałoby zamknąć krzywą łamaną. Wtedy pierwszy i ostatni punkt muszą się pokrywać
UPDATE obiekty
SET geometry = ST_AddPoint(geometry, ST_StartPoint(geometry))
WHERE name = 'obiekt4';

-- teraz mozemy zamienic obiekt na poligon
UPDATE obiekty
SET geometry = ST_MakePolygon(geometry)
WHERE name = 'obiekt4';

-- 4

WITH obiekt3 AS (
SELECT * 
FROM obiekty
WHERE name = 'obiekt3'
),
obiekt4 AS (
SELECT * 
FROM obiekty
WHERE name = 'obiekt4'
)
INSERT INTO obiekty (id, name, geometry)
SELECT 7, 'obiekt7', ST_Collect(obiekt3.geometry, obiekt4.geometry)
FROM obiekt3
CROSS JOIN obiekt4;

SELECT * FROM obiekty;

-- 5
-- nie jestem pewna czy chodziło o sumę pól wszystkich tych buforów, czy pole dla każdego obiektu, ale tu wersja 1

SELECT SUM(ST_Area(ST_Buffer(geometry, 5))) AS pole_powierzchni
FROM obiekty
WHERE NOT ST_HasArc(geometry);

-- wersja 2
SELECT name AS nazwa_obiektu,ST_Area(ST_Buffer(geometry, 5)) AS pole_powierzchni
FROM obiekty
WHERE NOT ST_HasArc(geometry);