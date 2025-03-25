-- Определить, какие автомобили имеют среднюю позицию лучше (меньше) средней позиции всех автомобилей
-- в своем классе (то есть автомобилей в классе должно быть минимум два, чтобы выбрать один из них).
-- Вывести информацию об этих автомобилях, включая их имя, класс, среднюю позицию, количество гонок,
-- в которых они участвовали, и страну производства класса автомобиля.
-- Также отсортировать результаты по классу и затем по средней позиции в порядке возрастания.

WITH class_average_positions AS (
    SELECT
        c.class,
        AVG(r.position) AS class_avg_position
    FROM
        cars c
    JOIN
        results r ON c.name = r.car
    GROUP BY
        c.class
    HAVING
        COUNT(c.name) >= 2  -- в классе минимум два автомобиля
),
car_average_positions AS (
    SELECT
        c.name,
        c.class,
        AVG(r.position) AS car_avg_position,
        COUNT(r.race) AS race_count
    FROM
        Cars c
    JOIN
        Results r ON c.name = r.car
    GROUP BY
        c.name, c.class
)
SELECT
    cap.name,
    cap.class,
    ROUND(cap.car_avg_position, 2) AS car_avg_position,
    cap.race_count,
    cl.country
FROM
    car_average_positions cap
JOIN
    class_average_positions class_avg ON cap.class = class_avg.class
JOIN
    classes cl ON cap.class = cl.class
WHERE
    cap.car_avg_position < class_avg.class_avg_position
ORDER BY
    cap.class, cap.car_avg_position;