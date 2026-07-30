/*=========================================================
Spotify SQL Analysis Project

Author   : Soham Chandwadkar
Database : spotify_analysis
Tool     : MySQL Workbench

Description:
This project analyzes over 586,000 Spotify tracks using SQL
to uncover trends in popularity, artist performance,
audio features, and release history.

=========================================================*/

/*=========================================================
DATABASE SETUP
=========================================================*/

USE spotify_analysis;

CREATE TABLE tracks (
    id VARCHAR(50) PRIMARY KEY,
    name TEXT,
    popularity INT,
    duration_ms INT,
    explicit BOOLEAN,
    artists TEXT,
    id_artists TEXT,
    release_date VARCHAR(20),
    danceability FLOAT,
    energy FLOAT,
    `key` INT,
    loudness FLOAT,
    mode INT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    time_signature INT
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/tracks.csv'
INTO TABLE tracks
CHARACTER SET utf8mb4
FIELDS
    TERMINATED BY ','
    ENCLOSED BY '"'
    ESCAPED BY ''
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id,name,popularity,duration_ms,explicit,artists,id_artists,release_date,
danceability,energy,`key`,loudness,mode,speechiness,acousticness,
instrumentalness,liveness,valence,tempo,time_signature);

/*=========================================================
SECTION 1 : DATASET EXPLORATION
=========================================================*/

-- Total Tracks
SELECT COUNT(*) AS total_tracks
FROM tracks;

--Total Unique Artists
SELECT COUNT(DISTINCT artists) AS unique_artists
FROM tracks;

--Top 10 Most Popular Songs
SELECT name, artists, popularity
FROM tracks
ORDER BY popularity DESC
LIMIT 10;

--Least Popular Songs
SELECT name, artists, popularity
FROM tracks
ORDER BY popularity ASC
LIMIT 10;

--Average Popularity
SELECT ROUND(AVG(popularity),2) AS avg_popularity
FROM tracks;

--Explicit vs Non-Explicit Songs
SELECT explicit, COUNT(*) AS total
FROM tracks
GROUP BY explicit;

--Longest Songs
SELECT
name,
artists,
ROUND(duration_ms/60000,2) AS duration_minutes
FROM tracks
ORDER BY duration_ms DESC
LIMIT 10;

--Shortest Songs
SELECT
name,
artists,
ROUND(duration_ms/60000,2) AS duration_minutes
FROM tracks
ORDER BY duration_ms asc
LIMIT 10;

--Top 10 Artists With Most Songs
SELECT
artists,
COUNT(*) AS total_songs
FROM tracks
GROUP BY artists
ORDER BY total_songs DESC
LIMIT 10;

--Songs Released Each Year
SELECT
LEFT(release_date,4) AS release_year,
COUNT(*) AS total_songs
FROM tracks
GROUP BY release_year
ORDER BY release_year;

--Average Danceability
SELECT ROUND(AVG(danceability),3) AS avg_danceability
FROM tracks;


--Top 10 Most Danceable Songs
SELECT
name,
artists,
danceability
FROM tracks
ORDER BY danceability DESC
LIMIT 10;

--Most Energetic Songs
SELECT
name,
artists,
energy
FROM tracks
ORDER BY energy DESC
LIMIT 10;

--Average Tempo
SELECT ROUND(AVG(tempo),2) AS avg_tempo
FROM tracks;

--Songs Longer Than 5 Minutes
SELECT COUNT(*) AS songs_over_5_min
FROM tracks
WHERE duration_ms > 300000;

--Top Acoustic Songs
SELECT
name,
artists,
acousticness
FROM tracks
ORDER BY acousticness DESC
LIMIT 10;

--Top Instrumental Songs
SELECT
name,
artists,
instrumentalness
FROM tracks
ORDER BY instrumentalness DESC
LIMIT 10;

--Happiest Songs (Highest Valence)
SELECT
name,
artists,
valence
FROM tracks
ORDER BY valence DESC
LIMIT 10;

--Loudest Songs
SELECT
name,
artists,
loudness
FROM tracks
ORDER BY loudness DESC
LIMIT 10;

--Popular Songs Above Average Popularity
SELECT
name,
artists,
popularity
FROM tracks
WHERE popularity >
(
SELECT AVG(popularity)
FROM tracks
)
ORDER BY popularity DESC;

--Top 3 Songs Per Release Year
WITH ranked_songs AS (
    SELECT
        LEFT(release_date,4) AS release_year,
        name,
        artists,
        popularity,
        ROW_NUMBER() OVER (
            PARTITION BY LEFT(release_date,4)
            ORDER BY popularity DESC
        ) AS rn
    FROM tracks
)
SELECT *
FROM ranked_songs
WHERE rn <= 3;

#Popularity Categories
SELECT
    name,
    artists,
    popularity,
    CASE
        WHEN popularity >= 80 THEN 'Hit'
        WHEN popularity >= 60 THEN 'Popular'
        WHEN popularity >= 40 THEN 'Average'
        ELSE 'Low'
    END AS popularity_category
FROM tracks;

--Average Danceability & Energy Per Year
SELECT
    LEFT(release_date,4) AS release_year,
    ROUND(AVG(danceability),3) AS avg_danceability,
    ROUND(AVG(energy),3) AS avg_energy
FROM tracks
GROUP BY release_year
ORDER BY release_year;

--Dataset Summary
SELECT
    COUNT(*) AS total_tracks,
    COUNT(DISTINCT artists) AS total_artists,
    ROUND(AVG(popularity),2) AS avg_popularity,
    ROUND(AVG(duration_ms)/60000,2) AS avg_duration_minutes,
    ROUND(AVG(danceability),3) AS avg_danceability,
    ROUND(AVG(energy),3) AS avg_energy
FROM tracks;
