-- =========================================
-- LIMPIEZA
-- =========================================
DROP TRIGGER IF EXISTS trg_after_insert_flight_delay ON flight_delay;
DROP FUNCTION IF EXISTS fn_handle_flight_delay();
DROP PROCEDURE IF EXISTS sp_register_flight_delay(integer, integer, integer, timestamp, text);

-- =========================================
-- FUNCIÓN DEL TRIGGER
-- =========================================
CREATE OR REPLACE FUNCTION fn_handle_flight_delay()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_flight_id INT;
BEGIN
    -- Obtener vuelo desde el segmento
    SELECT flight_id
    INTO v_flight_id
    FROM flight_segment
    WHERE flight_segment_id = NEW.flight_segment_id;

    -- Si delay > 60 → cambiar estado a DELAYED
    IF NEW.delay_minutes > 60 THEN
        UPDATE flight
        SET flight_status_id = (
            SELECT flight_status_id
            FROM flight_status
            WHERE UPPER(name) = 'DELAYED'
            LIMIT 1
        )
        WHERE flight_id = v_flight_id;
    END IF;

    RETURN NEW;
END;
$$;

-- =========================================
-- TRIGGER
-- =========================================
CREATE TRIGGER trg_after_insert_flight_delay
AFTER INSERT ON flight_delay
FOR EACH ROW
EXECUTE FUNCTION fn_handle_flight_delay();

-- =========================================
-- PROCEDIMIENTO
-- =========================================
CREATE OR REPLACE PROCEDURE sp_register_flight_delay(
    p_flight_segment_id INT,
    p_delay_reason_type_id INT,
    p_delay_minutes INT,
    p_reported_at TIMESTAMP,
    p_notes TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO flight_delay (
        flight_segment_id,
        delay_reason_type_id,
        delay_minutes,
        reported_at,
        notes
    )
    VALUES (
        p_flight_segment_id,
        p_delay_reason_type_id,
        p_delay_minutes,
        p_reported_at,
        p_notes
    );
END;
$$;