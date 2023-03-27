# In this SQL, I'm querying a dataset of the first 6 generations of pokemon to discover interesting information.



# DATA CLEANING BEGINS

#1. Let's check how many nulls in each column.

SELECT
    (SELECT COUNT(*) FROM sql_projects.pokemon WHERE Number IS NULL) AS Number_nulls,
    (SELECT COUNT(*) FROM sql_projects.pokemon WHERE Name IS NULL) AS Name_nulls,
    (SELECT COUNT(*) FROM sql_projects.pokemon WHERE Type_1 IS NULL) AS Type1_nulls,
    (SELECT COUNT(*) FROM sql_projects.pokemon WHERE Type_2 IS NULL) AS Type2_nulls,
    (SELECT COUNT(*) FROM sql_projects.pokemon WHERE Total IS NULL) AS Total_nulls,
    (SELECT COUNT(*) FROM sql_projects.pokemon WHERE HP IS NULL) AS HP_nulls,
    (SELECT COUNT(*) FROM sql_projects.pokemon WHERE Attack IS NULL) AS Attack_nulls,
    (SELECT COUNT(*) FROM sql_projects.pokemon WHERE Defense IS NULL) AS Def_nulls,
    (SELECT COUNT(*) FROM sql_projects.pokemon WHERE Sp_Atk IS NULL) AS SpAtk_nulls,
    (SELECT COUNT(*) FROM sql_projects.pokemon WHERE Sp_Def IS NULL) AS SpDef_nulls,
    (SELECT COUNT(*) FROM sql_projects.pokemon WHERE Speed IS NULL) AS Speed_nulls,
    (SELECT COUNT(*) FROM sql_projects.pokemon WHERE Generation IS NULL) AS Gen_nulls,
    (SELECT COUNT(*) FROM sql_projects.pokemon WHERE Legendary IS NULL) AS Legendary_nulls
FROM
    sql_projects.pokemon
LIMIT 1;

/* Only Type_2 has nulls, which is fine because this means 386 pokemon have only one type. */

#2. Let's check how many pokemon there are in this dataset.

SELECT
    MAX(Number) AS last_pokemon_num
FROM
    sql_projects.pokemon;

#3. Let's check how many rows there are in this dataset.

SELECT 
    COUNT(*) AS num_rows
FROM
    sql_projects.pokemon;

/* There are 800 rows, which means this data includes pokemon with multiple forms. WE WANT TO FOCUS ON THE BASE FORMS ONLY. */

#4. Let's determine which pokemon have multiple forms.

SELECT
    *
FROM
    (SELECT
	Number,
	COUNT(Number) AS num_forms
    FROM
	sql_projects.pokemon
    GROUP BY
	Number
    ORDER BY
	num_forms DESC) AS a
WHERE
    num_forms > 1;

#5. Using the query output above, let's filter out the other forms and create a new table.

SELECT 
    ID,
    Number,
    Name
FROM 
    sql_projects.pokemon
WHERE
    Number IN 
	(720, 719, 711, 710, 681, 678, 648, 647, 646, 645, 642, 641, 555, 531, 492, 487, 479, 475, 460, 448, 445, 428, 413, 386, 384,	
        383, 382, 381, 380, 376, 373, 362, 359, 354, 334, 323, 319, 310, 308, 306, 303, 302, 282, 260, 257, 254, 248, 229, 214, 212,	
        208, 181, 150, 142, 130, 127, 115, 94, 80, 65, 18, 15, 9, 6, 3);

/* After scanning through the above output, we find several key words in the Name column that can be used to eliminate special forms */
        
CREATE TABLE pokemon2 AS
SELECT * 
FROM sql_projects.pokemon
WHERE
	Name NOT LIKE '%_Mega_%' AND
	Name NOT LIKE '%Primal%' AND
	Name NOT LIKE '%Attack_%' AND
	Name NOT LIKE '%Defense_%' AND
	Name NOT LIKE '%Speed_%' AND
	Name NOT LIKE '%Speed_%' AND
	Name NOT LIKE '%Sandy_Cloak%' AND
	Name NOT LIKE '%Trash_Cloak%' AND
	Name NOT LIKE '%_Rotom%' AND
	Name NOT LIKE 'GiratinaOrigin_Forme' AND
	Name NOT LIKE '%Sky_%' AND
	Name NOT LIKE '%Zen_Mode%' AND
	Name NOT LIKE '%MeowsticMale%' AND
	Name NOT LIKE '%Blade_Forme%' AND
	Name NOT LIKE '%Therian%' AND
	Name NOT LIKE '%_Kyurem%' AND
	Name NOT LIKE '%_Unbound%' AND
	Name NOT LIKE '%Resolute%' AND
	Name NOT LIKE '%Super_Size%' AND
	Name NOT LIKE '%Small_Size%' AND
	Name NOT LIKE '%Large_Size%' AND
	Name NOT LIKE '%MeloettaPirouette_Forme%';

#6. After scanning the data again, several legendary pokemon are not recorded as legendary. Let's correct this.

UPDATE sql_projects.pokemon2 SET Legendary = "True" WHERE Number = 151;

UPDATE sql_projects.pokemon2 SET Legendary = "True" WHERE Number = 251;

UPDATE sql_projects.pokemon2 SET Legendary = "True" WHERE Number = 488;

UPDATE sql_projects.pokemon2 SET Legendary = "True" WHERE Number = 647;

UPDATE sql_projects.pokemon2 SET Legendary = "True" WHERE Number = 648;

UPDATE sql_projects.pokemon2 SET Legendary = "True" WHERE Number = 649;



# DATA CLEANING ENDS / ANALYSIS BEGINS

#7. Who are the top 5 pokemon with the most HP?

SELECT
    Name,
    Type_1,
    Type_2,
    HP
FROM
    sql_projects.pokemon2
ORDER BY
    HP DESC
LIMIT 5;

#8. Who are the top 5 strongest pokemon in terms of physical attacks?

SELECT 
    Name,
    Type_1,
    Type_2,
    Attack
FROM
    sql_projects.pokemon2
ORDER BY 
    Attack DESC
LIMIT 5;

#9. Who are the top 5 physically defensive pokemon?

SELECT 
    Name,
    Type_1,
    Type_2,
    Defense
FROM
    sql_projects.pokemon2
ORDER BY 
    Defense DESC
LIMIT 5;

#10. Who are the top 5 strongest pokemon in terms of special (projectile) attacks?

SELECT 
    Name,
    Type_1,
    Type_2,
    Sp_Atk
FROM
    sql_projects.pokemon2
ORDER BY 
    Sp_Atk DESC
LIMIT 5;


#11. Who are the top 5 specially defensive pokemon?

SELECT 
    Name,
    Type_1,
    Type_2,
    Sp_Def
FROM
    sql_projects.pokemon2
ORDER BY 
    Sp_Def DESC
LIMIT 5;

#12. Who are the top 5 fastest pokemon?

SELECT 
    Name,
    Type_1,
    Type_2,
    Speed
FROM
    sql_projects.pokemon2
ORDER BY 
    Speed DESC
LIMIT 5;


#13. Who are the top 5 pokemon with the highest stat totals?

SELECT
    Name,
    Type_1,
    Type_2,
    Total
FROM
    sql_projects.pokemon2
ORDER BY 
    Total DESC
LIMIT 5;

#14. Who are the top 5 pokemon with the highest stat totals that are not legendary pokemon?

SELECT
    Name,
    Type_1,
    Type_2,
    Total
FROM
    sql_projects.pokemon2
WHERE
    Legendary = 'False'
ORDER BY 
    Total DESC
LIMIT 5;

#15. Which pokemon types have the  highest average total stats?
/* We want pokemon with two types to be included in the averaging of each individual type. */
    
SELECT 
    (SELECT ROUND(AVG(Total)) FROM sql_projects.pokemon2 WHERE Type_1 = "Water" OR Type_2 = "Water" LIMIT 1) AS avg_Water_total,
    (SELECT ROUND(AVG(Total)) FROM sql_projects.pokemon2 WHERE Type_1 = "Normal" OR Type_2 = "Normal" LIMIT 1) AS avg_Normal_total,
    (SELECT ROUND(AVG(Total)) FROM sql_projects.pokemon2 WHERE Type_1 = "Flying" OR Type_2 = "Flying" LIMIT 1) AS avg_Flying_total,
    (SELECT ROUND(AVG(Total)) FROM sql_projects.pokemon2 WHERE Type_1 = "Grass" OR Type_2 = "Grass" LIMIT 1) AS avg_Grass_total,
    (SELECT ROUND(AVG(Total)) FROM sql_projects.pokemon2 WHERE Type_1 = "Psychic" OR Type_2 = "Psychic" LIMIT 1) AS avg_Psychic_total,
    (SELECT ROUND(AVG(Total)) FROM sql_projects.pokemon2 WHERE Type_1 = "Bug" OR Type_2 = "Bug" LIMIT 1) AS avg_Bug_total,
    (SELECT ROUND(AVG(Total)) FROM sql_projects.pokemon2 WHERE Type_1 = "Ground" OR Type_2 = "Ground" LIMIT 1) AS avg_Ground_total,
    (SELECT ROUND(AVG(Total)) FROM sql_projects.pokemon2 WHERE Type_1 = "Fire" OR Type_2 = "Fire" LIMIT 1) AS avg_Fire_total,
    (SELECT ROUND(AVG(Total)) FROM sql_projects.pokemon2 WHERE Type_1 = "Poison" OR Type_2 = "Poison" LIMIT 1) AS avg_Poison_total,
    (SELECT ROUND(AVG(Total)) FROM sql_projects.pokemon2 WHERE Type_1 = "Rock" OR Type_2 = "Rock" LIMIT 1) AS avg_Rock_total,
    (SELECT ROUND(AVG(Total)) FROM sql_projects.pokemon2 WHERE Type_1 = "Fighting" OR Type_2 = "Fighting" LIMIT 1) AS avg_Fighting_total,
    (SELECT ROUND(AVG(Total)) FROM sql_projects.pokemon2 WHERE Type_1 = "Dark" OR Type_2 = "Dark" LIMIT 1) AS avg_Dark_total,
    (SELECT ROUND(AVG(Total)) FROM sql_projects.pokemon2 WHERE Type_1 = "Dragon" OR Type_2 = "Dragon" LIMIT 1) AS avg_Dragon_total,
    (SELECT ROUND(AVG(Total)) FROM sql_projects.pokemon2 WHERE Type_1 = "Electric" OR Type_2 = "Electric" LIMIT 1) AS avg_Electric_total,
    (SELECT ROUND(AVG(Total)) FROM sql_projects.pokemon2 WHERE Type_1 = "Steel" OR Type_2 = "Steel" LIMIT 1) AS avg_Steel_total,
    (SELECT ROUND(AVG(Total)) FROM sql_projects.pokemon2 WHERE Type_1 = "Ghost" OR Type_2 = "Ghost" LIMIT 1) AS avg_Ghost_total,
    (SELECT ROUND(AVG(Total)) FROM sql_projects.pokemon2 WHERE Type_1 = "Fairy" OR Type_2 = "Fairy" LIMIT 1) AS avg_Fairy_total,
    (SELECT ROUND(AVG(Total)) FROM sql_projects.pokemon2 WHERE Type_1 = "Ice" OR Type_2 = "Ice" LIMIT 1) AS avg_Ice_total
FROM
    sql_projects.pokemon2
LIMIT 1;

#16. What is the average stat total in this dataset?

SELECT
    ROUND(AVG(Total)) AS avg_total_stats
FROM
    sql_projects.pokemon2;
    
#17. How many pokemon are above, exactly, and below average?

SELECT
    CASE
        WHEN Total > 418 THEN 'above_avg'
        WHEN Total = 418 THEN 'exactly_avg'
        WHEN Total < 418 THEN 'below_avg'
	END AS total_stats_category,
    COUNT(*) AS num_pokemon2
FROM
    sql_projects.pokemon2
GROUP BY
    total_stats_category;
    
#18. Which pokemon have the highest stat total in their generation?

SELECT
    (SELECT Name FROM sql_projects.pokemon2 WHERE Generation = 1 ORDER BY Total DESC LIMIT 1) AS gen1_pokemon2,
    (SELECT Name FROM sql_projects.pokemon2 WHERE Generation = 2 ORDER BY Total DESC LIMIT 1) AS gen2_pokemon2,
    (SELECT Name FROM sql_projects.pokemon2 WHERE Generation = 3 ORDER BY Total DESC LIMIT 1) AS gen3_pokemon2,
    (SELECT Name FROM sql_projects.pokemon2 WHERE Generation = 4 ORDER BY Total DESC LIMIT 1) AS gen4_pokemon2,
    (SELECT Name FROM sql_projects.pokemon2 WHERE Generation = 5 ORDER BY Total DESC LIMIT 1) AS gen5_pokemon2,
    (SELECT Name FROM sql_projects.pokemon2 WHERE Generation = 6 ORDER BY Total DESC LIMIT 1) AS gen6_pokemon2
FROM
    sql_projects.pokemon2
LIMIT 1;

#19. How many generations? How many pokemon are in each generation? What percent of all pokemon fall in each generation?

SELECT
    Generation,
    num_pokemon,
    ROUND((num_pokemon/721)*100) AS percent_of_whole
FROM
    (SELECT
        Generation,
	COUNT(DISTINCT Number) AS num_pokemon
    FROM 
	sql_projects.pokemon2
    GROUP BY 
	Generation) AS num_in_each_gen
ORDER BY
    Generation; 

#20. How does the average stat total change for each generation?

SELECT
    (SELECT ROUND(AVG(Total)) AS avg_total FROM sql_projects.pokemon2 WHERE Generation = 1 ) AS gen1_avg_total,
    (SELECT ROUND(AVG(Total)) AS avg_total FROM sql_projects.pokemon2 WHERE Generation = 2 ) AS gen2_avg_total,
    (SELECT ROUND(AVG(Total)) AS avg_total FROM sql_projects.pokemon2 WHERE Generation = 3 ) AS gen3_avg_total,
    (SELECT ROUND(AVG(Total)) AS avg_total FROM sql_projects.pokemon2 WHERE Generation = 4 ) AS gen4_avg_total,
    (SELECT ROUND(AVG(Total)) AS avg_total FROM sql_projects.pokemon2 WHERE Generation = 5 ) AS gen5_avg_total,
    (SELECT ROUND(AVG(Total)) AS avg_total FROM sql_projects.pokemon2 WHERE Generation = 6 ) AS gen6_avg_total
FROM
	sql_projects.pokemon2
LIMIT 1;

#21.A Let's determine how many pokemon in each type. We need to count pokemon with two types as part of both types.

SELECT 
    type,
    SUM(num_pokemon) AS num_pokemon
FROM
    ((SELECT
	 Type_1 AS type,
	 COUNT(Type_1) AS num_pokemon
      FROM
	 sql_projects.pokemon2
      GROUP BY
	 Type_1)
      UNION    
     (SELECT
	 Type_2 AS type,
	 COUNT(Type_2) AS num_pokemon
      FROM
	 sql_projects.pokemon2
      GROUP BY
	 Type_2)) AS cbind_type1_type2
GROUP BY
    type
ORDER BY 
    num_pokemon DESC;
    
#21.B Find the new total number of pokemon (since we are counting pokemon with two types as part of each type).

SELECT 
    SUM(num_pokemon)
FROM
    ((SELECT
	 Type_1 AS type,
	 COUNT(Type_1) AS num_pokemon
      FROM
	 sql_projects.pokemon2
      GROUP BY
	 Type_1)
      UNION    
     (SELECT
	 Type_2 AS type,
	 COUNT(Type_2) AS num_pokemon
      FROM
	 sql_projects.pokemon2
      GROUP BY
	 Type_2)) AS cbind_type1_type2;

##21.C Find what percent of the total population each type makes up.

SELECT
    type,
    num_pokemon,
    ROUND((num_pokemon/1041)*100) AS percentage
FROM
    (SELECT 
	type,
	SUM(num_pokemon) AS num_pokemon
    FROM
	((SELECT
	    Type_1 AS type,
	    COUNT(Type_1) AS num_pokemon
	FROM
	    sql_projects.pokemon2
	GROUP BY
	    Type_1)
	UNION    
	(SELECT
	    Type_2 AS type,
	    COUNT(Type_2) AS num_pokemon
	FROM
	    sql_projects.pokemon2
	GROUP BY
	    Type_2)) AS cbind_type1_type2
    GROUP BY
	type) AS num_types
ORDER BY
    percentage DESC;

#22. What percent of all pokemon2 are legendary?

SELECT
    num_legendary,
    (721-num_legendary) AS num_not_legendary,
    ROUND((num_legendary/721)*100) AS legendary_percent
FROM 
    (SELECT
	COUNT(DISTINCT Number) AS num_legendary
    FROM
	sql_projects.pokemon2
    WHERE
	Legendary = "True") AS legendary_count;

#23.A How many legendary pokemon in each type? We need to count pokemon with two types as part of both types.

SELECT
    type,
    SUM(num_pokemon) AS num_pokemon
FROM
    ((SELECT
	 Type_1 AS type,
	 COUNT(Type_1) AS num_pokemon
    FROM 
	 sql_projects.pokemon2
    WHERE
	 Legendary = "True"
    GROUP BY
	 type)
    UNION
    (SELECT
	 Type_2 AS type,
	 COUNT(Type_2) AS num_pokemon
    FROM 
	 sql_projects.pokemon2
    WHERE
	 Legendary = "True"
    GROUP BY
	 type)) AS cbind_type1_type2_legendaries
GROUP BY
	type
ORDER BY
	num_pokemon DESC;
    
#23.B Find the new total number of legendary pokemon (since we are counting pokemon with two types as part of each type).

SELECT
    SUM(num_pokemon) AS total_legendary
FROM
    ((SELECT
	 Type_1 AS type,
	 COUNT(Type_1) AS num_pokemon
    FROM 
	 sql_projects.pokemon2
    WHERE
	 Legendary = "True"
    GROUP BY
	 type)
    UNION
    (SELECT
	 Type_2 AS type,
	 COUNT(Type_2) AS num_pokemon
    FROM 
	 sql_projects.pokemon2
    WHERE
	 Legendary = "True"
    GROUP BY
	 type)) AS cbind_type1_type2_legendaries;

#23.C Find what percent of the total legendary population each type makes up.

SELECT 
    type,
    num_pokemon,
    ROUND((num_pokemon/81)*100) AS percentage
FROM 
    (SELECT
	type,
	SUM(num_pokemon) AS num_pokemon
    FROM
	((SELECT
	    Type_1 AS type,
	    COUNT(Type_1) AS num_pokemon
	FROM 
	    sql_projects.pokemon2
	WHERE
	    Legendary = "True"
	GROUP BY
	    type)
	UNION
	(SELECT
	    Type_2 AS type,
	    COUNT(Type_2) AS num_pokemon
	FROM 
	    sql_projects.pokemon2
	WHERE
	    Legendary = "True"
	GROUP BY
	    type)) AS a
    GROUP BY
	type
    ORDER BY
	num_pokemon DESC) AS b;

