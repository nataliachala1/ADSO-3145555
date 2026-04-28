DO $$
DECLARE
    v_airline_id INT;
    v_origin_id INT;
    v_destination_id INT;
    v_class_id INT;
    v_currency_id INT;
BEGIN
    -- Obtener datos
    SELECT airline_id INTO v_airline_id FROM airline LIMIT 1;
    SELECT airport_id INTO v_origin_id FROM airport LIMIT 1;
    SELECT airport_id INTO v_destination_id FROM airport OFFSET 1 LIMIT 1;
    SELECT fare_class_id INTO v_class_id FROM fare_class LIMIT 1;
    SELECT currency_id INTO v_currency_id FROM currency LIMIT 1;

    IF v_airline_id IS NULL THEN
        RAISE EXCEPTION 'No hay airline disponible';
    END IF;

    -- Crear tarifa (dispara trigger)
    CALL sp_create_fare(
        v_airline_id,
        v_origin_id,
        v_destination_id,
        v_class_id,
        v_currency_id,
        500.00,
        CURRENT_DATE,
        CURRENT_DATE + INTERVAL '30 days'
    );
END;
$$;

--validar resultado
--validar reservas con tarifa asignada

SELECT *
FROM reservation
WHERE fare_id IS NOT NULL;

--validad uso de tarifas en venta
SELECT
    f.fare_code,
    COUNT(t.ticket_id) AS tickets_generated
FROM fare f
INNER JOIN reservation r 
    ON r.fare_id = f.fare_id
INNER JOIN sale s 
    ON s.reservation_id = r.reservation_id
INNER JOIN ticket t 
    ON t.sale_id = s.sale_id
GROUP BY f.fare_code;

--validad rutas tarifarias
SELECT
    f.fare_code,
    ao.name AS origin,
    ad.name AS destination,
    f.base_amount
FROM fare f
INNER JOIN airport ao 
    ON ao.airport_id = f.origin_airport_id
INNER JOIN airport ad 
    ON ad.airport_id = f.destination_airport_id;