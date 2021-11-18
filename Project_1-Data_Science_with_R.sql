-- Question Set #1

-- Question #1

-- We want to understand more about the movies that families are watching. The following categories are considered family movies: Animation, Children, Classics, Comedy, Family and Music.
--Create a query that lists each movie, the film category it is classified in, and the number of times it has been rented out.

WITH family_films AS (
    SELECT
        f.film_id AS film_id,
        f.title AS film_title,
        c.name AS category_name
    FROM film AS f
    JOIN film_category AS fc
    ON f.film_id = fc.film_id
    JOIN category AS c
    ON c.category_id = fc.category_id
    WHERE c.name IN ('Animation', 'Children','Classics','Comedy','Family','Music')
    ORDER BY 3,2
)

SELECT
    ff.film_title,
    ff.category_name,
    COUNT(*) AS rental_count
FROM family_films AS ff
JOIN inventory AS i
ON ff.film_id = i.film_id
JOIN rental AS r
ON i.inventory_id = r.inventory_id
GROUP BY 1,2
ORDER BY 2,1;

-- Question #2

-- Now we need to know how the length of rental duration of these family-friendly movies compares to the duration that all movies are rented for.
-- Can you provide a table with the movie titles and divide them into 4 levels (first_quarter, second_quarter, third_quarter, and final_quarter)
-- based on the quartiles (25%, 50%, 75%) of the rental duration for movies across all categories? Make sure to also indicate the category that these family-friendly movies fall into.

WITH family_films AS (
    SELECT
        f.film_id AS film_id,
        f.title AS film_title,
        c.name AS category_name,
        f.rental_duration AS rental_duration
    FROM film AS f
    JOIN film_category AS fc
    ON f.film_id = fc.film_id
    JOIN category AS c
    ON c.category_id = fc.category_id
    WHERE c.name IN ('Animation', 'Children','Classics','Comedy','Family','Music')
)

SELECT
    film_title,
    category_name,
    rental_duration,
	NTILE(4) OVER (ORDER BY rental_duration) AS quartile
FROM family_films AS ff
