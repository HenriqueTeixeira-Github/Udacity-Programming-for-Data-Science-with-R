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
	NTILE(4) OVER (ORDER BY rental_duration) AS standard_quartile
FROM family_films AS ff;

-- Question #3

-- Finally, provide a table with the family-friendly film category, each of the quartiles,
-- and the corresponding count of movies within each combination of film category for each corresponding rental duration category.
-- The resulting table should have three columns: film_name, standard_quartile and count

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
    category_name,
    CASE
        WHEN standard_quartile = 1 THEN '1. First Quartile'
        WHEN standard_quartile = 2 THEN '2. Secound Quartile'
        WHEN standard_quartile = 3 THEN '3. Third Quartile'
        WHEN standard_quartile = 4 THEN '4. Fourth Quartile'
    END AS standard_quartile_group,
    COUNT(*) AS film_count
FROM
    (SELECT
        film_title,
        category_name,
        rental_duration,
    	NTILE(4) OVER (ORDER BY rental_duration) AS standard_quartile
    FROM family_films AS ff) AS sub
GROUP BY 1,2
ORDER BY 1,2;

-- Question Set #2

-- Question #1
-- We want to find out how the two stores compare in their count of rental orders during every month for all the years we have data for.
-- Write a query that returns the store ID for the store, the year and month and the number of rental orders each store has fulfilled for that month.
-- Your table should include a column for each of the following: year, month, store ID and count of rental orders fulfilled during that month.

SELECT
    DATE_PART('month', r.rental_date) AS rental_month,
    DATE_PART('year', r.rental_date) AS rental_year,
    str.store_id AS store_id,
    COUNT(*) AS rental_count
FROM rental AS r
JOIN staff AS stf
ON r.staff_id = stf.staff_id
JOIN store AS str
ON stf.store_id = str.store_id
GROUP BY 1,2,3
ORDER BY 4 DESC

-- Question #2
-- We would like to know who were our top 10 paying customers, how many payments they made on a monthly basis during 2007, and what was the amount of the monthly payments.
-- Can you write a query to capture the customer name, month and year of payment, and total payment amount for each month by these top 10 paying customers?

WITH sub AS (
    SELECT
        p.payment_id AS payment_id,
        c.customer_id AS customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS full_name,
        p.amount AS payment_amout,
        p.payment_date AS payment_date
    FROM customer AS c
    JOIN payment AS p
    ON c.customer_id = p.customer_id
)

SELECT
    DATE_TRUNC('month', payment_date) AS rental_month,
    full_name,
    COUNT(*) AS count_payments_per_month,
    SUM(payment_amout) AS sum_amount_per_month
FROM sub
WHERE full_name IN
    (SELECT
        full_name
    FROM sub
    WHERE DATE_PART('year', payment_date) = 2007
    GROUP BY 1
    ORDER BY SUM(payment_amout) DESC
    LIMIT 10
)
GROUP BY 1,2
ORDER BY 2,1

-- Question #3
-- Finally, for each of these top 10 paying customers, I would like to find out the difference across their monthly payments during 2007. Please go ahead and write a query to compare the payment amounts in each successive month.
-- Repeat this for each of these 10 paying customers. Also, it will be tremendously helpful if you can identify the customer name who paid the most difference in terms of payments.

WITH sub AS (
    SELECT
        p.payment_id AS payment_id,
        c.customer_id AS customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS full_name,
        p.amount AS payment_amout,
        p.payment_date AS payment_date
    FROM customer AS c
    JOIN payment AS p
    ON c.customer_id = p.customer_id
)

SELECT
    *
FROM
    (SELECT
        rental_month,
        full_name,
        sum_amount_per_month AS current_sum_amount_per_month,
        LEAD(sum_amount_per_month) OVER (ORDER BY full_name, rental_month) AS lead_sum_amount_per_month,
        CASE
            WHEN full_name = LEAD(full_name) OVER (ORDER BY full_name, rental_month) THEN LEAD(sum_amount_per_month) OVER (ORDER BY full_name, rental_month) - sum_amount_per_month
            ELSE null
        END
            AS diff
    FROM
        (SELECT
            DATE_TRUNC('month', payment_date) AS rental_month,
            full_name,
            SUM(payment_amout) AS sum_amount_per_month
        FROM sub
        WHERE full_name IN
            (SELECT
                full_name
            FROM sub
            WHERE DATE_PART('year', payment_date) = 2007
            GROUP BY 1
            ORDER BY SUM(payment_amout) DESC
            LIMIT 10
            )
        GROUP BY 1,2
        ORDER BY 2,1
        ) AS sub2
    ORDER BY 5 DESC
    ) AS sub3
WHERE diff IS NOT NULL
LIMIT 1

/*
EXTRA:
-- Among the top 10 actor/actress who acted in the films from the dxd rental, what is the average of the amount rented in 2017 by category.
*/

WITH top_10_actors AS (
    SELECT
        a.actor_id AS actor_id
    FROM actor AS a
    JOIN film_actor AS fa
    ON a.actor_id = fa.actor_id
    JOIN film AS f
    ON f.film_id = fa.film_id
    GROUP BY 1
    ORDER BY COUNT(*) DESC
    LIMIT 10
)

SELECT
    category,
    AVG(amount_retal)::decimal(10,2) AS rental_average
FROM
    (SELECT
        c.name AS category,
        a.actor_id,
        CONCAT(a.first_name, ' ', a.last_name) AS actor_full_name,
        SUM(p.amount) AS amount_retal
    FROM actor AS a
    JOIN film_actor AS fa
    ON a.actor_id = fa.actor_id
    JOIN film AS f
    ON f.film_id = fa.film_id
    JOIN inventory AS i
    ON f.film_id = i.film_id
    JOIN rental AS r
    ON r.inventory_id = i.inventory_id
    JOIN payment AS p
    ON p.rental_id = r.rental_id
    JOIN film_category AS fc
    ON f.film_id = fc.film_id
    JOIN category AS c
    ON c.category_id = fc.category_id
    WHERE
        a.actor_id IN (SELECT * FROM top_10_actors) AND
        DATE_PART('year', p.payment_date) = 2007
    GROUP BY 1,2,3
    ORDER BY 4 DESC
    ) AS sub
GROUP BY 1
ORDER BY 2 DESC

----------------------------FINAL PROJECT----------------------------

/*
FINAL PROJECT
Question 1: What were the total Rental Orders per Category among the TOP 10 customers .
*/

WITH top_10_customers AS (
    SELECT
        ctm.customer_id AS customer_id,
        p.amount AS payment_amount,
        p.payment_date AS payment_date
    FROM customer AS ctm
    JOIN payment AS p
    ON ctm.customer_id = p.customer_id
)

SELECT
    c.name AS category,
    COUNT(*)::INTEGER AS rental_count
FROM customer AS ctm
JOIN rental AS r
ON ctm.customer_id = r.customer_id
JOIN inventory AS i
ON i.inventory_id = r.inventory_id
JOIN film AS f
ON f.film_id = i.film_id
JOIN film_category AS fc
ON f.film_id = fc.film_id
JOIN category AS c
ON c.category_id = fc.category_id
WHERE ctm.customer_id IN
    (SELECT
        customer_id
    FROM top_10_customers
    GROUP BY 1
    ORDER BY SUM(payment_amount) DESC
    LIMIT 10
    )
GROUP BY 1
ORDER BY 2 DESC

/*
FINAL PROJECT
Question 2: The distribution of family type films rented from the total rental orders
*/

SELECT
    type_group,
    (SUM(num_rentals)/MAX(total)*100)::decimal(10,2) AS percentage
FROM
    (SELECT
        category,
        COUNT(*) AS num_rentals,
        CASE
            WHEN category IN ('Animation', 'Children','Classics','Comedy','Family','Music') THEN 'Family Film'
            ELSE 'Not Family Film'
        END AS type_group,
        MAX(total) AS total
    FROM
        (SELECT
            c.name AS category,
            COUNT(*) OVER () AS total
        FROM film AS f
        JOIN film_category AS fc
        ON f.film_id = fc.film_id
        JOIN category AS c
        ON c.category_id = fc.category_id
        JOIN inventory AS i
        ON f.film_id = i.film_id
        JOIN rental AS r
        ON r.inventory_id = i.inventory_id
    ) AS sub
    GROUP BY 1
) AS sub2
GROUP BY 1

/*
FINAL PROJECT
Question 3: The distribution of family type films rented from the total rental orders
*/

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
    category_name,
    CASE
        WHEN standard_quartile = 1 THEN '1. First Quartile'
        WHEN standard_quartile = 2 THEN '2. Secound Quartile'
        WHEN standard_quartile = 3 THEN '3. Third Quartile'
        WHEN standard_quartile = 4 THEN '4. Fourth Quartile'
    END AS standard_quartile_group,
    COUNT(*) AS film_count
FROM
    (SELECT
        film_title,
        category_name,
        rental_duration,
    	NTILE(4) OVER (ORDER BY rental_duration) AS standard_quartile
    FROM family_films AS ff) AS sub
GROUP BY 1,2
ORDER BY 1,2;


/*
FINAL PROJECT
Question 4: What is the minimum number of films to reach 50% of the total amount rented per film_rating?
*/

SELECT
    film_rating,
    COUNT(*) AS min_films_to_reach_50perc
FROM
    (SELECT
        film_id,
        film_rating,
        amount_percentage,
        running_total,
        LAG(running_total) OVER (film_rating_window),
        CASE
            WHEN (LAG(running_total) OVER (film_rating_window) <= 50 OR
                LAG(running_total) OVER (film_rating_window) IS NULL) THEN 'OK'
            WHEN LAG(running_total) OVER (film_rating_window) > 50 THEN 'NOT OK'
        END AS status
    FROM
        (SELECT
            film_id,
            film_rating,
            amount_percentage::decimal(9,2),
            (SUM(amount_percentage) OVER (PARTITION BY film_rating ORDER BY amount_percentage DESC))::decimal(9,2) AS running_total
        FROM
            (SELECT
                film_id,
                film_rating,
                SUM(amount)/MAX(amount_retal)*100 AS amount_percentage
            FROM
                (SELECT
                    f.film_id AS film_id,
                    SUM(p.amount) OVER (PARTITION BY f.rating) AS amount_retal,
                    p.amount AS amount,
                    f.rating AS film_rating
                FROM film AS f
                JOIN inventory AS i
                ON f.film_id = i.film_id
                JOIN rental AS r
                ON r.inventory_id = i.inventory_id
                JOIN payment AS p
                ON p.rental_id = r.rental_id
                ) AS sub
            GROUP BY 1,2
            ORDER BY 2,3 DESC
        ) AS sub2
    ) AS sub3
    WINDOW film_rating_window AS (PARTITION BY film_rating ORDER BY amount_percentage DESC)
    ORDER BY 2,4
) AS sub4
WHERE status = 'OK'
GROUP BY 1
ORDER BY 2 DESC

-- PROJECT APPROVED (22/11/2021 - UDACITY)
