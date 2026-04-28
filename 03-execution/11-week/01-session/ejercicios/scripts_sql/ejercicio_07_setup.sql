-- =========================================
-- LIMPIEZA
-- =========================================
DROP TRIGGER IF EXISTS trg_after_insert_baggage ON baggage;
DROP FUNCTION IF EXISTS fn_after_insert_baggage();
DROP PROCEDURE IF EXISTS sp_register_baggage(integer, varchar, varchar, varchar, timestamp);

-- =========================================
-- FUNCIÓN DEL TRIGGER
-- =========================================
CREATE OR REPLACE FUNCTION fn_after_insert_baggage()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_exists INT;
BEGIN
    -- Verificar si existe asiento asignado
    SELECT COUNT(*)
    INTO v_exists
    FROM seat_assignment
    WHERE ticket_segment_id = NEW.ticket_segment_id;

    -- Validación lógica
    IF v_exists = 0 THEN
        RAISE NOTICE 'Segmento con equipaje pero sin asiento asignado';
    END IF;

    RETURN NEW;
END;
$$;

-- =========================================
-- TRIGGER
-- =========================================
CREATE TRIGGER trg_after_insert_baggage
AFTER INSERT ON baggage
FOR EACH ROW
EXECUTE FUNCTION fn_after_insert_baggage();

-- =========================================
-- PROCEDIMIENTO
-- =========================================
CREATE OR REPLACE PROCEDURE sp_register_baggage(
    p_ticket_segment_id INT,
    p_baggage_tag VARCHAR,
    p_baggage_type VARCHAR,
    p_status VARCHAR,
    p_registered_at TIMESTAMP
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO baggage (
        ticket_segment_id,
        baggage_tag,
        baggage_type,
        status,
        registered_at
    )
    VALUES (
        p_ticket_segment_id,
        p_baggage_tag,
        p_baggage_type,
        p_status,
        p_registered_at
    );
END;
$$;