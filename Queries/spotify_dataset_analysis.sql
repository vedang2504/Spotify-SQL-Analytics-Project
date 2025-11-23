DROP TABLE IF EXISTS spotify_tracks;
CREATE TABLE spotify_tracks (
    track_id VARCHAR(50),
    artists TEXT,
    album_name TEXT,
    track_name TEXT,
    popularity INT,
    duration_ms INT,
    explicit VARCHAR(10),
    danceability NUMERIC(4,3),
    energy NUMERIC(4,3),
    key INT,
    loudness NUMERIC(6,3),
    mode INT,
    speechiness NUMERIC(4,3),
    acousticness NUMERIC(4,3),
    instrumentalness NUMERIC(4,3),
    liveness NUMERIC(4,3),
    valence NUMERIC(4,3),
    tempo NUMERIC(6,3),
    time_signature INT,
    track_genre VARCHAR(150)
);

COPY spotify_tracks
FROM 'D:\Project\SQL project\spotify.csv.csv'
DELIMITER ','
CSV HEADER;
SELECT * FROM spotify_tracks;

-- 1)Popularity & Streaming Insights
--a)Top 10 most popular tracks globally
SELECT 
    track_name, 
    artists,
    popularity,
   DENSE_RANK() OVER (ORDER BY popularity DESC) AS rank
FROM spotify_tracks
WHERE popularity IS NOT NULL
GROUP BY track_name,artists,popularity
ORDER BY popularity DESC 
LIMIT 10;

--b)Songs with popularity > 90 — how many exist
SELECT 
track_name,
artists,
popularity
FROM spotify_tracks
WHERE popularity>90;

--c)distribution of popularity (how many unpopular vs viral tracks)
SELECT 
CASE 
WHEN popularity>=80  THEN 'Viral Hits(80,100)'
WHEN popularity>=60  THEN 'Popular(60,79)'
WHEN popularity>=40  THEN 'Moderate(40,59)'
WHEN popularity>=20  THEN 'Less Poupular(20,39)'
ELSE 'Unpopular(0,19)'
END AS popularity_category,ROUND((100.0*COUNT(*))/(SELECT COUNT(*) FROM spotify_tracks))
AS percentage
FROM spotify_tracks
GROUP BY popularity_category
ORDER BY percentage DESC;

 -- d)Most popular albums overall
SELECT 
    artists,
    album_name,
    ROUND(AVG(popularity), 2) AS avg_popularity,
    COUNT(*) AS total_tracks,
    DENSE_RANK() OVER (ORDER BY AVG(popularity) DESC) AS album_rank
FROM spotify_tracks
GROUP BY artists, album_name
HAVING COUNT(*) >= 4
ORDER BY avg_popularity DESC
LIMIT 10;

-- 2)Genre Analysis
-- a)Top performing genres by popularity
SELECT track_genre,COUNT(*) AS total_tracks ,ROUND(AVG(popularity),2) AS avg_popularity,
DENSE_RANK()OVER(ORDER BY AVG(popularity) DESC) AS genre_rank
FROM spotify_tracks
GROUP BY track_genre 
HAVING COUNT(*)>=50
ORDER BY avg_popularity DESC LIMIT 10;

-- b)Which genres have the highest energy?
SELECT track_genre,COUNT(*) AS total_tracks,ROUND(AVG(energy),2) AS average_energy,
DENSE_RANK()OVER(ORDER BY AVG(energy) DESC) AS energy_rank
FROM spotify_tracks
GROUP BY track_genre
HAVING COUNT(*)>=50
ORDER BY average_energy DESC LIMIT 10;

--c)which genres have the calmest (low energy + high acousticness)?
SELECT ROUND(AVG(energy),3)AS avg_energy,ROUND(AVG(acousticness),3) AS avg_acousticness FROM spotify_tracks;
-- 0.641 energy 0.314 acousticness
SELECT track_genre,ROUND(AVG(energy),3) AS avg_energy,ROUND(AVG(acousticness),3) AS avg_acousticness,COUNT(*) AS total_tracks,DENSE_RANK()OVER(ORDER BY AVG(acousticness) DESC) AS calmness_rank
FROM spotify_tracks
WHERE energy< 0.641 AND acousticness>0.314
GROUP BY track_genre
HAVING COUNT(*)>=50
ORDER BY calmness_rank;

-- d)Genre with highest valence (happiest songs)0.474
SELECT AVG(valence) FROM spotify_tracks;
SELECT track_genre,ROUND(AVG(valence),3) AS avg_valence,COUNT(*) AS total_tracks ,DENSE_RANK()OVER(ORDER BY AVG(valence) DESC)AS valence_rank
FROM spotify_tracks
GROUP BY track_genre
HAVING COUNT(*)>=50
ORDER BY valence_rank LIMIT 10;

-- 3) Artist Performance Insights

-- a)Top artists by number of tracks
SELECT artists,COUNT(*) AS tracks_count
FROM spotify_tracks
GROUP BY artists
ORDER BY tracks_count DESC LIMIT 10;
-- b)Artists with most high-popularity song
SELECT artists,COUNT(*)AS total_tracks,DENSE_RANK()OVER(ORDER BY COUNT(*) DESC)AS song_rank
FROM spotify_tracks
WHERE popularity>=80
GROUP BY artists
HAVING COUNT(*)>=5
ORDER BY song_rank LIMIT 10;

-- Artist comparison: danceability, loudness, valence…
SELECT artists,ROUND(AVG(danceability),2) AS avg_danceability,
COUNT(*)AS total_tracks
FROM spotify_tracks
GROUP BY artists
HAVING COUNT(*)>=20
ORDER BY avg_danceability DESC LIMIT 10;

SELECT artists,ROUND(AVG(loudness),2) AS avg_loudness,
COUNT(*)AS total_tracks
FROM spotify_tracks
GROUP BY artists
HAVING COUNT(*)>=20
ORDER BY avg_loudness DESC LIMIT 10;

SELECT artists,ROUND(AVG(valence),2) AS avg_valence,
COUNT(*)AS total_tracks
FROM spotify_tracks
GROUP BY artists
HAVING COUNT(*)>=20
ORDER BY avg_valence DESC LIMIT 10;

SELECT artists,
COUNT(*) AS total_tracks,
ROUND(AVG(danceability),2) AS avg_danceability,
ROUND(AVG(loudness),2) AS avg_loudness,
ROUND(AVG(valence),2) AS avg_valence,
ROUND(AVG(popularity),2) AS avg_popularity
FROM spotify_tracks
GROUP BY artists
HAVING COUNT(*)>20
ORDER BY avg_popularity DESC LIMIT 10;

-- 4)Audio Feature Insights

-- Correlation insights:
 -- a)Popularity vs Danceability
 SELECT AVG(danceability) FROM spotify_tracks
 SELECT
 CASE WHEN danceability>=0.70 THEN 'HIGH'
 	  WHEN danceability>=0.50 THEN 'MEDIUM'
	  ELSE 'LOW'
	  END AS danceability_level,COUNT(*) AS total_tracks,
	  ROUND(AVG(popularity),2) AS avg_popularity,
	  DENSE_RANK() OVER(ORDER BY AVG(popularity) DESC)AS rankby_popularity
	  FROM spotify_tracks 
	  GROUP BY danceability_level
	  ORDER BY avg_popularity ;
 -- b)Popularity vs Loudness
SELECT 
CASE
WHEN loudness>=-6 THEN 'HIGH'
WHEN loudness>=-14 THEN 'MEDIUM'
ELSE 'LOW' 
END AS loudness_level,
COUNT(*) AS tracks_count,
ROUND(AVG(popularity)) AS avg_popularity,
DENSE_RANK()OVER(ORDER BY AVG(popularity) DESC) AS  popularity_rank
FROM spotify_tracks
GROUP BY loudness_level
ORDER BY popularity_rank;


 
 SELECT valence FROM spotify_tracks;
 -- c)Popularity vs Valence (happiness)
SELECT 
CASE
WHEN valence>=0.70 THEN 'HIGH'
WHEN valence>=0.50 THEN 'MEDIUM'
ELSE 'LOW' 
END AS valence_level,
COUNT(*) AS tracks_count,
ROUND(AVG(popularity)) AS avg_popularity,
DENSE_RANK()OVER(ORDER BY AVG(popularity) DESC) AS  popularity_rank
FROM spotify_tracks
GROUP BY valence_level
ORDER BY popularity_rank;

-- 5)Explicit Content Insight
-- a)% of songs marked Explicit
SELECT COUNT(*) AS total_tracks,COUNT(CASE WHEN explicit = 'TRUE' THEN 1 END)AS explicit_tracks,ROUND(COUNT(CASE WHEN explicit = 'TRUE' THEN 1 END)::NUMERIC*100
/COUNT(*),2) AS explicit_percentage FROM spotify_tracks;

--b)Do explicit songs have higher popularity on average
SELECT explicit,ROUND(AVG(popularity),2)AS avg_popularity,COUNT(*) AS total_tracks
FROM spotify_tracks
GROUP BY explicit
ORDER BY avg_popularity DESC;
-- 6)Duration / Tempo Insights
-- a)Which songs are too long vs radio-friendly
SELECT 
CASE
WHEN duration_ms<120000 THEN 'short(<2.5 min)'
WHEN duration_ms BETWEEN 120000 AND 240000 THEN 'Radio-friendly(2.5-4) min'
ELSE 'TOO long' END AS duration_group,
COUNT(*) AS total_tracks,
ROUND(AVG(popularity)) AS avg_popularity
FROM spotify_tracks
GROUP BY duration_group
ORDER BY avg_popularity DESC;

-- 7)Mode & Musical Theory Insights
-- a)major mode vs Minor mode → popularity comparison
SELECT 
CASE 
WHEN mode=1 THEN 'major'
WHEN mode=0 THEN 'minor' 
END AS mode_type,
ROUND(AVG(popularity),2)AS avg_popularity,
COUNT(*)AS total_tracks
FROM spotify_tracks
GROUP BY mode_type
ORDER BY avg_popularity DESC;

 --b)Genre → tempo distribution
 SELECT CASE WHEN tempo<90 THEN 'slow'
 WHEN tempo BETWEEN 90 AND 120 THEN 'medium'
 WHEN tempo>120 THEN 'fast' END AS tempo_group,
 AVG(popularity) AS avg_popularity,
 DENSE_RANK() OVER (ORDER BY AVG(popularity) DESC) AS popularity_ranK,
 COUNT(*) AS total_tracks
 FROM spotify_tracks
 GROUP BY tempo_group
 ORDER BY avg_popularity DESC;
 -- c)Which genre has fastest tempo?
  SELECT track_genre,AVG(tempo) AS avg_tempo,DENSE_RANK()OVER(ORDER BY AVG(tempo) DESC) AS genre_rank
 FROM spotify_tracks
 GROUP BY track_genre
 ORDER BY avg_tempo DESC limit 1;
 -- d)Which genre is slowest?
 SELECT track_genre,AVG(tempo) AS avg_tempo,DENSE_RANK()OVER(ORDER BY AVG(tempo) ) AS genre_rank
 FROM spotify_tracks
 GROUP BY track_genre
 ORDER BY avg_tempo limit 1;
 









