-- Вам необходимо провести анализ данных о бронированиях в отелях и определить предпочтения клиентов по типу отелей. Для этого выполните следующие шаги:
-- 
-- Категоризация отелей.
-- Определите категорию каждого отеля на основе средней стоимости номера:
-- 
-- «Дешевый»: средняя стоимость менее 175 долларов.
-- «Средний»: средняя стоимость от 175 до 300 долларов.
-- «Дорогой»: средняя стоимость более 300 долларов.
-- Анализ предпочтений клиентов.
-- Для каждого клиента определите предпочитаемый тип отеля на основании условия ниже:
-- 
-- Если у клиента есть хотя бы один «дорогой» отель, присвойте ему категорию «дорогой».
-- Если у клиента нет «дорогих» отелей, но есть хотя бы один «средний», присвойте ему категорию «средний».
-- Если у клиента нет «дорогих» и «средних» отелей, но есть «дешевые», присвойте ему категорию предпочитаемых отелей «дешевый».
-- Вывод информации.
-- Выведите для каждого клиента следующую информацию:
-- 
-- ID_customer: уникальный идентификатор клиента.
-- name: имя клиента.
-- preferred_hotel_type: предпочитаемый тип отеля.
-- visited_hotels: список уникальных отелей, которые посетил клиент.
-- Сортировка результатов.
-- Отсортируйте клиентов так, чтобы сначала шли клиенты с «дешевыми» отелями, затем со «средними» и в конце — с «дорогими».

WITH hotel_categories AS (
    SELECT
        h.id_hotel,
        h.name,
        AVG(r.price) AS average_price,
        CASE
            WHEN AVG(r.price) < 175 THEN 'Дешевый'
            WHEN AVG(r.price) BETWEEN 175 AND 300 THEN 'Средний'
            ELSE 'Дорогой'
        END AS hotel_category
    FROM
        hotel h
    JOIN
        room r ON h.ID_hotel = r.ID_hotel
    GROUP BY
        h.id_hotel, h.name
), customer_preferences AS (
	SELECT
        b.ID_customer,
        c.name,
        MAX(CASE WHEN hc.hotel_category = 'Дорогой' THEN 1 ELSE 0 END) AS has_expensive,
        MAX(CASE WHEN hc.hotel_category = 'Средний' THEN 1 ELSE 0 END) AS has_average,
        MAX(CASE WHEN hc.hotel_category = 'Дешевый' THEN 1 ELSE 0 END) AS has_cheap,
        STRING_AGG(DISTINCT h.name, ', ') AS visited_hotels
    FROM
        booking b
    JOIN
        room r ON b.ID_room = r.ID_room
    JOIN
        hotel h ON r.ID_hotel = h.ID_hotel
    JOIN
        customer c ON b.ID_customer = c.ID_customer
    JOIN
        hotel_categories hc ON h.ID_hotel = hc.ID_hotel
    GROUP BY
        b.ID_customer, c.name)
SELECT
    ID_customer,
    name,
    CASE
    	WHEN has_expensive = 1 THEN 'Дорогой'
        WHEN has_average = 1 and has_expensive = 0 THEN 'Средний'
        WHEN has_cheap = 1  and has_average = 0 and has_expensive = 0 THEN 'Дешевый'
        ELSE ''
    END AS preferred_hotel_type,
    visited_hotels
FROM
    customer_preferences
ORDER BY
    CASE
	    WHEN has_cheap = 1  and has_average = 0 and has_expensive = 0 THEN 1
	    WHEN has_average = 1 and has_expensive = 0 THEN 2
    	WHEN has_expensive = 1 THEN 3
        ELSE 4
    end,
    id_customer
