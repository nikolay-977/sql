-- Определить, какие автомобили из каждого класса имеют наименьшую среднюю позицию в гонках,
-- и вывести информацию о каждом таком автомобиле для данного класса,
-- включая его класс, среднюю позицию и количество гонок, в которых он участвовал.
-- Также отсортировать результаты по средней позиции.

WITH average_positions AS (
    SELECT
        c.class,
        c.name,
        AVG(r.position) AS avg_position,
        COUNT(r.race) AS race_count
    FROM
        Cars c
    JOIN
        Results r ON c.name = r.car
    GROUP BY
        c.class, c.name
),
min_average_positions AS (
    SELECT
        class,
        MIN(avg_position) AS min_avg_position
    FROM
        average_positions
    GROUP BY
        class
)
SELECT
    ap.class,
    ap.name,
    ap.avg_position,
    ap.race_count
FROM
    average_positions ap
JOIN
    min_average_positions map ON ap.class = map.class AND ap.avg_position = map.min_avg_position
ORDER BY
    ap.avg_position;
