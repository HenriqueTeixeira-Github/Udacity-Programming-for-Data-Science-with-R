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
