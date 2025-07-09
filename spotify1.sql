--Advanced SQL Project -- Spotify Datasets

-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

--EDA
SELECT COUNT (*) FROM spotify;

SELECT COUNT (DISTINCT album) FROM spotify;

SELECT  DISTINCT album_type FROM spotify;

SELECT MAX(duration_min)FROM spotify;

SELECT MIN(duration_min)FROM spotify;

SELECT * FROM spotify
WHERE duration_min = 0;

DELETE FROM spotify
WHERE duration_min = 0;
SELECT * FROM spotify
WHERE duration_min = 0;

SELECT DISTINCT channel FROM spotify;

SELECT DISTINCT most_played_on FROM spotify;

----------------------------------------
--Data Analysis -Easy Category
----------------------------------------
--Q1 Retrieve the names of all tracks that have more than 1 billion streams.--
SELECT * FROM spotify
WHERE stream > 1000000000

--Q2List all albums along with their respective artists.--
SELECT 
    DISTINCT album,artist
FROM spotify
ORDER BY 1

SELECT 
    DISTINCT album
FROM spotify
ORDER BY 1;

--Q3Get the total number of comments for tracks where licensed = TRUE.--

--SELECT DISTINCT licensed FROM spotify
SELECT 
SUM(comments) as total_comments
FROM spotify
WHERE licensed = 'true';

--Q4Find all tracks that belong to the album type single.--
SELECT * FROM spotify
WHERE album_type = 'single';

--Q5 Count the total number of tracks by each artist.--
SELECT
     artist, ---1
	 COUNT(*) as total_on_songs ---2
FROM spotify
GROUP BY artist
ORDER BY 2

-------------------Medium Level------------------------

--Q6Calculate the average danceability of tracks in each album.
SELECT 
     album,
	 avg(danceability) as avg_danceability
FROM spotify
GROUP BY 1
ORDER BY 2 DESC

--Q7Find the top 5 tracks with the highest energy values.
SELECT 
    track,
	MAX(energy)
FROM spotify
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--Q8List all tracks along with their views and likes where official_video = TRUE.
SELECT 
    track,
	SUM(views) as total_views,
	SUM(likes) as total_likes
FROM spotify
WHERE official_video = 'true'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--Q9For each album, calculate the total views of all associated tracks.
SELECT 
    Album,
	track,
	SUM(views)
FROM spotify
GROUP BY 1,2
ORDER BY 3 DESC

--Q10Retrieve the track names that have been streamed on Spotify more than YouTube.
SELECT * FROM
(SELECT 
    track,
	--most_played_on--
    COALESCE(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END),0) as streamed_on_youtube,
    COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' THEN Stream END),0) as streamed_on_spotify
FROM spotify
GROUP BY 1
) as t1
WHERE
    streamed_on_spotify > streamed_on_youtube
	AND
	streamed_on_youtube <> 0

---Q11Find the top 3 most-viewed tracks for each artist using window functions.--
-- each artists and total view for each track
-- track with highest view for each artist (we need toop)
-- dense rank
-- cte and filder rank <=3
WITH ranking_artist
AS
(SELECT 
   artist,
   track,
   SUM(views) as total_view,
   DENSE_RANK() OVER(PARTITION BY artist ORDER BY SUM(views) DESC) as rank
FROM spotify
GROUP BY 1,2
ORDER BY 1,3 DESC
)
SELECT * FROM ranking_artist
WHERE rank <= 3

--Q12Write a query to find tracks where the liveness score is above the average.--
SELECT 
   track,
   artist,
   liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness)FROM Spotify)

--Q13 Use a WITH clause to calculate the difference between the 
--highest and lowest energy values for tracks in each album.

WITH cte
AS
(SELECT 
    album,
	MAX(energy) as highest_energy,
	MAX(energy) as lowest_energery
FROM spotify
GROUP BY 1
)
SELECT
    album,
	highest_energy - lowest_energery as energy_diff
FROM cte
ORDER BY 2 DESC
	
	 
 

