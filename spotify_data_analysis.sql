#1. What is the most popular song in this dataset?

SELECT
    track_name,
    artist_name,
    popularity
FROM
    BIT_DB.Spotifydata
WHERE    
    popularity IN (SELECT MAX(popularity) FROM BIT_DB.Spotifydata);

/* Three songs are tied for the most popularity with a score of 95 */

#2. For the most popular songs, what is the average danceability, energy, loudness, speechiness, instrumentalness, and duration?

SELECT
    AVG(danceability),
    AVG(energy),
    AVG(loudness), 
    AVG(speechiness),
    AVG(instrumentalness),
    AVG(duration_ms)
FROM
    BIT_DB.Spotifydata
WHERE
    popularity >= 95;

#3. What is the longest track, shortest track, and the average track duration in this dataset?

SELECT
    (SELECT track_name FROM BIT_DB.Spotifydata WHERE duration_ms IN (SELECT MAX(duration_ms) FROM BIT_DB.Spotifydata)) AS longest_track,
    (SELECT track_name FROM BIT_DB.Spotifydata WHERE duration_ms IN (SELECT MIN(duration_ms) FROM BIT_DB.Spotifydata)) AS shortest_track,
    (SELECT AVG(duration_ms) FROM BIT_DB.Spotifydata) AS avg_duration
FROM
    BIT_DB.Spotifydata
LIMIT 1;

#4. Who are the artists that the longest and shortest tracks belong to?

SELECT
    (SELECT artist_name FROM BIT_DB.Spotifydata WHERE duration_ms IN (SELECT MAX(duration_ms) FROM BIT_DB.Spotifydata)) AS longest_track_artist,
    (SELECT artist_name FROM BIT_DB.Spotifydata WHERE duration_ms IN (SELECT MIN(duration_ms) FROM BIT_DB.Spotifydata)) AS shortest_track_artist
FROM
    BIT_DB.Spotifydata
LIMIT 1;

#5. How many tracks are above and below the average track duration?

SELECT
    COUNT(*) AS num_tracks,
    CASE
        WHEN duration_ms > 197488.4 THEN 'above_avg'
        WHEN duration_ms = 197488.4 THEN 'exactly_avg'
        WHEN duration_ms < 197488.4 THEN 'below_avg'   
    END AS duration_info
FROM
    BIT_DB.Spotifydata
GROUP BY
    duration_info;

#6. Do longer tracks (those above the avg duration) have more speechiness or acousticness on average?

SELECT
    ROUND(AVG(speechiness),4) AS avg_speech,
    ROUND(AVG(acousticness),4) AS avg_acoustic
FROM
    BIT_DB.Spotifydata
WHERE 
    duration_ms > 197488.4;

#7. Do shorter tracks (those below the avg duration) have more speechiness or acousticness on average?

SELECT
    ROUND(AVG(speechiness),4) AS avg_speech,
    ROUND(AVG(acousticness),4) AS avg_acoustic
FROM
    BIT_DB.Spotifydata
WHERE 
    duration_ms < 197488.4;

#8. Which tracks have a higher average danceability, longer or shorter tracks?

SELECT 
    (SELECT ROUND(AVG(danceability),4) FROM BIT_DB.Spotifydata WHERE duration_ms > 197488.4) AS danceability_long,
    (SELECT ROUND(AVG(danceability),4) FROM BIT_DB.Spotifydata WHERE duration_ms < 197488.4) AS danceability_short
FROM
    BIT_DB.Spotifydata
LIMIT 1;

#9. Which artists have more than 1 track in Spotify's 2021 Top 50 Most Listed to Songs?

SELECT
    artist_name,
    COUNT(artist_name) AS num_songs
FROM
    BIT_DB.Spotifydata
GROUP BY
    artist_name
HAVING
    num_songs > 1
ORDER BY
    num_songs DESC;

#10. What is the average danceability, energy, loudness, and tempo for each artist with more than 1 track?

SELECT
    artist_name,        
    AVG(danceability),
    AVG(energy),
    AVG(loudness),
    AVG(tempo),
    COUNT(artist_name) AS num_songs
FROM
    BIT_DB.Spotifydata
GROUP BY
    artist_name
HAVING
    num_songs > 1;

#11. Which track has the most danceability and who does this track belong to? 

SELECT
    track_name,    
    artist_name,        
    danceability
FROM
    BIT_DB.Spotifydata
WHERE
    danceability IN (SELECT MAX(danceability) FROM BIT_DB.Spotifydata);
