-- ============================================
-- FUNCIÓN: Asignar tarifa automáticamente
-- ============================================

CREATE OR REPLACE FUNCTION fn_after_fare_insert()
RETURNS TRIGGER AS $$
BEGIN
    -- Asignar nueva tarifa a reservas sin tarifa
    UPDATE reservation
    SET fare_id = NEW.fare_id
    WHERE fare_id IS NULL;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- ============================================
-- TRIGGER
-- ============================================

CREATE TRIGGER trg_after_fare_insert
AFTER INSERT ON fare
FOR EACH ROW
EXECUTE FUNCTION fn_after_fare_insert();


-- ============================================
-- PROCEDIMIENTO: Crear tarifa
-- ============================================

CREATE OR REPLACE PROCEDURE sp_create_fare(
    p_airline_id INT,
    p_origin_airport_id INT,
    p_destination_airport_id INT,
    p_fare_class_id INT,
    p_currency_id INT,
    p_base_amount NUMERIC,
    p_valid_from DATE,
    p_valid_to DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO fare (
        airline_id,
        origin_airport_id,
        destination_airport_id,
        fare_class_id,
        currency_id,
        base_amount,
        valid_from,
        valid_to
    )
    VALUES (
        p_airline_id,
        p_origin_airport_id,
        p_destination_airport_id,
        p_fare_class_id,
        p_currency_id,
        p_base_amount,
        p_valid_from,
        p_valid_to
    );
END;
$$;