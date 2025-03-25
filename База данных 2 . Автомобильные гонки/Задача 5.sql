-- Определить, какие классы автомобилей имеют наибольшее количество автомобилей с низкой средней позицией (больше 3.0)
-- и вывести информацию о каждом автомобиле из этих классов, включая его имя, класс, среднюю позицию,
-- количество гонок, в которых он участвовал, страну производства класса автомобиля,
-- а также общее количество гонок для каждого класса.
-- Отсортировать результаты по количеству автомобилей с низкой средней позицией.

WITH CarAveragePositions AS (
    SELECT
        r.car,
        AVG(r.position) AS avg_position,
        COUNT(r.race) AS race_count
    FROM
        Results r
    GROUP BY
        r.car
    HAVING
        AVG(r.position) > 3.0
),
ClassCarCounts AS (
    SELECT
        c.class,
        COUNT(DISTINCT cp.car) AS low_avg_position_count,
        COUNT(DISTINCT r.name) AS total_races
    FROM
        CarAveragePositions cp
    JOIN
        Cars c ON cp.car = c.name
    JOIN
        Races r ON r.name IN (SELECT race FROM Results WHERE car = cp.car)
    GROUP BY
        c.class
),
ClassDetails AS (
    SELECT
        cl.class,
        cl.country,
        cc.low_avg_position_count,
        cc.total_races
    FROM
        Classes cl
    JOIN
        ClassCarCounts cc ON cl.class = cc.class
)
SELECT
    c.name,
    c.class,
    ap.avg_position,
    ap.race_count,
    cd.country,
    cd.total_races
FROM
    CarAveragePositions ap
JOIN
    Cars c ON ap.car = c.name
JOIN
    ClassDetails cd ON c.class = cd.class
ORDER BY
    cd.low_avg_position_count DESC;