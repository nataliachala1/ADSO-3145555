DO $$
DECLARE
    v_segment_id INT;
    v_reason_id INT;
BEGIN
    -- =========================================
    -- 1. Obtener datos reales
    -- =========================================
    SELECT flight_segment_id
    INTO v_segment_id
    FROM flight_segment
    ORDER BY flight_segment_id
    LIMIT 1;

    SELECT delay_reason_type_id
    INTO v_reason_id
    FROM delay_reason_type
    ORDER BY delay_reason_type_id
    LIMIT 1;

    IF v_segment_id IS NULL THEN
        RAISE EXCEPTION 'No existe flight_segment.';
    END IF;

    -- =========================================
    -- 2. Insertar demora (DISPARA TRIGGER)
    -- =========================================
    CALL sp_register_flight_delay(
        v_segment_id,
        v_reason_id,
        90, -- mayor a 60 → cambia estado
        NOW(),
        'Demo delay severo'
    );

END;
$$;

--validaciones 
--ver delays registrados
SELECT
    fd.flight_delay_id,
    fd.flight_segment_id,
    fd.delay_minutes,
    fd.reported_at
FROM flight_delay fd
ORDER BY fd.reported_at DESC
LIMIT 5;

--validar cambio de estado del vuelo
SELECT
    f.flight_id,
    f.flight_number,
    fs.name AS status
FROM flight f
INNER JOIN flight_status fs
    ON fs.flight_status_id = f.flight_status_id
ORDER BY f.flight_id
LIMIT 10;