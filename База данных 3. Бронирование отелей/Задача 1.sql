-- Определить, какие клиенты сделали более двух бронирований в разных отелях,
-- и вывести информацию о каждом таком клиенте, включая его имя, электронную почту, телефон,
-- общее количество бронирований, а также список отелей,
-- в которых они бронировали номера (объединенные в одно поле через запятую с помощью CONCAT).
-- Также подсчитать среднюю длительность их пребывания (в днях) по всем бронированиям.
-- Отсортировать результаты по количеству бронирований в порядке убывания.

SELECT 
    c.name,
    c.email,
    c.phone,
    COUNT(b.id_booking) AS total_bookings,
    STRING_AGG(DISTINCT h.name, ', ') AS hotels,
    AVG(b.check_out_date - b.check_in_date) AS average_stay_duration
FROM 
    booking b
JOIN 
    room r ON b.id_room = r.id_room
JOIN 
    hotel h ON r.id_hotel = h.id_hotel
JOIN 
    customer c ON b.id_customer = c.id_customer
GROUP BY 
    c.id_customer, c.name, c.email, c.phone
HAVING 
    COUNT(b.id_booking) > 2 AND 
    COUNT(DISTINCT h.id_hotel) > 1
ORDER BY 
    total_bookings DESC;