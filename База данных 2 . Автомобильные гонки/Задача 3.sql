-- Определить классы автомобилей, которые имеют наименьшую среднюю позицию в гонках,
-- и вывести информацию о каждом автомобиле из этих классов, включая его имя, среднюю позицию,
-- количество гонок, в которых он участвовал, страну производства класса автомобиля,
-- а также общее количество гонок, в которых участвовали автомобили этих классов.
-- Если несколько классов имеют одинаковую среднюю позицию, выбрать все из них.

WITH class_average_positions AS (
    SELECT
        c.class,
        AVG(r.position) AS avg_position,
        COUNT(r.race) AS total_races
    FROM
        cars c
    JOIN
        results r ON c.name = r.car
    GROUP BY
        c.class
),
min_average_position AS (
    SELECT
        MIN(avg_position) AS min_avg_position
    FROM
        class_average_positions
)
SELECT
    c.name,
    c.class,
    ROUND(AVG(r.position), 2) AS avg_position,
    COUNT(r.race) AS race_count,
    cl.country,
    cap.total_races
FROM
    cars c
JOIN
    results r ON c.name = r.car
JOIN
    classes cl ON c.class = cl.class
JOIN
    class_average_positions cap ON c.class = cap.class
WHERE
    cap.avg_position = (SELECT min_avg_position FROM min_average_position)
GROUP BY
    c.name, c.class, cl.country, cap.total_races
ORDER BY
    c.class, c.name;