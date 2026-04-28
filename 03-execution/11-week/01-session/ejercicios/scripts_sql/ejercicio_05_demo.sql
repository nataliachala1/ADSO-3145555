DO $$
DECLARE
    v_aircraft_id INT;
    v_type_id INT;
    v_provider_id INT;
BEGIN
    -- =========================================
    -- 1. Obtener datos reales
    -- =========================================
    SELECT aircraft_id INTO v_aircraft_id
    FROM aircraft
    ORDER BY aircraft_id
    LIMIT 1;

    SELECT maintenance_type_id INTO v_type_id
    FROM maintenance_type
    ORDER BY maintenance_type_id
    LIMIT 1;

    SELECT maintenance_provider_id INTO v_provider_id
    FROM maintenance_provider
    ORDER BY maintenance_provider_id
    LIMIT 1;

    IF v_aircraft_id IS NULL THEN
        RAISE EXCEPTION 'No existe aircraft.';
    END IF;

    -- =========================================
    -- 2. Insertar mantenimiento inicial
    -- =========================================
    INSERT INTO maintenance_event (
        aircraft_id,
        maintenance_type_id,
        maintenance_provider_id,
        status,
        start_date,
        notes
    )
    VALUES (
        v_aircraft_id,
        v_type_id,
        v_provider_id,
        'IN_PROGRESS',
        NOW(),
        'Demo mantenimiento inicial'
    );

    -- =========================================
    -- 3. Completar mantenimiento (DISPARA TRIGGER)
    -- =========================================
    UPDATE maintenance_event
    SET status = 'COMPLETED',
        end_date = NOW()
    WHERE aircraft_id = v_aircraft_id
    AND status = 'IN_PROGRESS'
    ORDER BY start_date DESC
    LIMIT 1;

    -- =========================================
    -- 4. Usar procedimiento
    -- =========================================
    CALL sp_register_maintenance_event(
        v_aircraft_id,
        v_type_id,
        v_provider_id,
        'IN_PROGRESS',
        NOW(),
        'Demo desde procedure'
    );

END;
$$;

--VALIDACIÓN

--Ver eventos de mantenimiento
SELECT
    maintenance_event_id,
    aircraft_id,
    status,
    start_date,
    end_date,
    notes
FROM maintenance_event
ORDER BY start_date DESC
LIMIT 10;0

--ver eventos generados automaticamente
SELECT
    maintenance_event_id,
    aircraft_id,
    status,
    notes,
    start_date
FROM maintenance_event
WHERE notes LIKE '%Auto-generado%'
ORDER BY start_date DESC;