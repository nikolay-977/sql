-- Определить автомобиль, который имеет наименьшую среднюю позицию в гонках среди всех автомобилей,
-- и вывести информацию об этом автомобиле, включая его класс, среднюю позицию, количество гонок,
-- в которых он участвовал, и страну производства класса автомобиля.
-- Если несколько автомобилей имеют одинаковую наименьшую среднюю позицию,
-- выбрать один из них по алфавиту (по имени автомобиля).

WITH AveragePositions AS (
    SELECT
        c.name,
        c.class,
        AVG(r.position) AS avg_position,
        COUNT(r.race) AS race_count
    FROM
        Cars c
    JOIN
        Results r ON c.name = r.car
    GROUP BY
        c.name, c.class
)
SELECT
    ap.name,
    ap.class,
    ap.avg_position,
    ap.race_count,
    cl.country
FROM
    AveragePositions ap
JOIN
    Classes cl ON ap.class = cl.class
ORDER BY
    ap.avg_position, ap.name
LIMIT 1;