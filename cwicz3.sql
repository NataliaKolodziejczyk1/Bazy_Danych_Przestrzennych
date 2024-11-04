CREATE EXTENSION postgis;

SELECT * FROM buildings2018
ORDER BY polygon_id DESC;

SELECT * FROM buildings2019
ORDER BY polygon_id DESC;

-- zadanie 1

-- za wybudowane budynki uznajemy te, które występują w buildings2019 a nie występują w buildings2018,
-- wyremontowane to te, dla których zmieniła się geometria lub wysokość
SELECT 
    b2019.gid, 
    b2019.polygon_id, 
    b2019.name, 
    b2019.type, 
    b2018.height AS height_2018, 
    b2018.geom AS geom_2018,
	b2019.height AS height_2019, 
    b2019.geom AS geom_2019
FROM buildings2019 b2019
LEFT JOIN buildings2018 b2018 
ON b2019.polygon_id = b2018.polygon_id
WHERE (b2018.gid IS NULL OR NOT ST_Equals(b2019.geom, b2018.geom) OR b2019.height <> b2018.height);

-- zadanie 2
-- w epsg 4326 jednostką jest stopień, żeby przejść na metry musimy podzielić przez około 111120
-- czyli 500 m to około 0.0045

WITH temp AS(
SELECT 
    b2019.geom
FROM buildings2019 b2019
LEFT JOIN buildings2018 b2018 
ON b2019.polygon_id = b2018.polygon_id
WHERE (b2018.gid IS NULL OR NOT ST_Equals(b2019.geom, b2018.geom) OR b2019.height <> b2018.height)
),
buffer AS (
SELECT ST_Union(ST_Buffer(geom, 0.0045)) AS buffer_geom
FROM temp 
)
SELECT poi2019.type, COUNT(*) 
FROM poi2019
LEFT JOIN poi2018 
ON poi2019.poi_id = poi2018.poi_id
CROSS JOIN buffer
WHERE poi2018.poi_id IS NULL AND ST_Intersects(poi2019.geom, buffer_geom)
GROUP BY poi2019.type;


-- zadanie 3

-- układ współrzędnych DHDN.Berlin/Cassini to EPSG 3068
CREATE TABLE streets_reprojected AS
SELECT 
    gid,             
    link_id,
	st_name,
	ref_in_id,
	nref_in_id,
	func_class,
	speed_cat,
	fr_speed_l,
	to_speed_l,
	dir_travel,
    ST_Transform(geom, 3068) AS geom -- Przekształcenie geometrii do EPSG:3068 (DHDN.Berlin/Cassini)
FROM streets2019;

SELECT * FROM streets_reprojected;

-- zadanie 4

CREATE TABLE input_points (
    id SERIAL PRIMARY KEY,
    geom GEOMETRY(Point,4326)
);

INSERT INTO input_points(geom) VALUES
('Point( 8.36093 49.03174)'),
('Point( 8.39876 49.00644)');

SELECT * FROM input_points;

-- zadanie 5

ALTER TABLE input_points
ALTER COLUMN geom TYPE Geometry(Point, 3068)
USING ST_Transform(geom, 3068);

SELECT ST_AsText(geom) FROM input_points;

-- zadanie 6

WITH line_buffer AS (
	SELECT ST_Buffer(ST_MakeLine(geom), 0.0018) AS buffer_geom
	FROM input_points
)
SELECT DISTINCT (sn.node_id)
FROM street_node2019 sn
CROSS JOIN line_buffer lb 
WHERE ST_Contains(lb.buffer_geom, ST_Transform(sn.geom, 3068)) AND sn.intersect = 'Y';

-- zadanie 7

WITH park_buffer AS (
SELECT ST_Union(ST_Buffer(geom, 0.0027)) AS buffer_geom
FROM land_use_a2019
WHERE type = 'Park (City/County)'
)
SELECT COUNT(*) AS sports_store_count
FROM poi2019 AS poi
CROSS JOIN park_buffer AS pb
WHERE poi.type = 'Sporting Goods Store' AND ST_Contains(pb.buffer_geom,poi.geom);

-- zadanie 8

CREATE TABLE T2019_KAR_BRIDGES AS
SELECT ST_Intersection(r.geom, wl.geom) AS geom
FROM railways2019 AS r
CROSS JOIN water_lines2019 AS wl
WHERE ST_Intersects(r.geom, wl.geom)

SELECT * FROM T2019_KAR_BRIDGES;