--How many movie titles are there in the database? 
--(movies only, not tv shows)

SELECT
    COUNT(*)
FROM
    "CharlotteChaze/BreakIntoTech"."netflix_titles_info" AS titles
WHERE
   "titles"."type" = 'Movie';

--When was the most recent batch of tv shows and/or movies 
--added to the database?

SELECT
    MAX("titles"."date_added") AS most_recent_movie
FROM
    "CharlotteChaze/BreakIntoTech"."netflix_titles_info" AS titles
WHERE
    "titles"."type" = 'Movie';

SELECT
    MAX("titles"."date_added") AS most_recent_show
FROM
    "CharlotteChaze/BreakIntoTech"."netflix_titles_info" AS titles
WHERE
    "titles"."type" = 'TV Show';

SELECT
    "titles"."type",
     "titles"."date_added"
FROM
    "CharlotteChaze/BreakIntoTech"."netflix_titles_info" AS titles
WHERE 
   "titles"."date_added" IS NOT NULL
ORDER BY
     "titles"."date_added" DESC
LIMIT 10;

--List all the movies and tv shows in alphabetical order.

SELECT
    "titles"."title"
FROM
    "CharlotteChaze/BreakIntoTech"."netflix_titles_info" AS titles
ORDER BY
     "titles"."title" ASC;

--Who was the Director for the movie Bright Star?

SELECT
    "people"."director"
FROM
    "CharlotteChaze/BreakIntoTech"."netflix_titles_info" AS titles
JOIN
    "CharlotteChaze/BreakIntoTech"."netflix_people" AS people
ON
    "titles"."show_id" = "people"."show_id"
WHERE 
    "titles"."title" LIKE '%Bright Star%';

--What is the oldest movie in the database and what year was it made?

SELECT
    "titles"."title",
    "titles"."release_year"
FROM
    "CharlotteChaze/BreakIntoTech"."netflix_titles_info" AS titles
ORDER BY
    "titles"."release_year" ASC
LIMIT 1;

