-- Определить классы автомобилей, которые имеют наименьшую среднюю позицию в гонках,
-- и вывести информацию о каждом автомобиле из этих классов, включая его имя, среднюю позицию,
-- количество гонок, в которых он участвовал, страну производства класса автомобиля,
-- а также общее количество гонок, в которых участвовали автомобили этих классов.
-- Если несколько классов имеют одинаковую среднюю позицию, выбрать все из них.

WITH ClassAveragePositions AS (
    SELECT
        c.class,
        AVG(r.position) AS avg_position,
        COUNT(r.race) AS total_races
    FROM
        Cars c
    JOIN
        Results r ON c.name = r.car
    GROUP BY
        c.class
),
MinAveragePosition AS (
    SELECT
        MIN(avg_position) AS min_avg_position
    FROM
        ClassAveragePositions
)
SELECT
    c.name,
    c.class,
    ROUND(AVG(r.position), 2) AS avg_position,
    COUNT(r.race) AS race_count,
    cl.country,
    cap.total_races
FROM
    Cars c
JOIN
    Results r ON c.name = r.car
JOIN
    Classes cl ON c.class = cl.class
JOIN
    ClassAveragePositions cap ON c.class = cap.class
WHERE
    cap.avg_position = (SELECT min_avg_position FROM MinAveragePosition)
GROUP BY
    c.name, c.class, cl.country, cap.total_races
ORDER BY
    c.class, c.name;