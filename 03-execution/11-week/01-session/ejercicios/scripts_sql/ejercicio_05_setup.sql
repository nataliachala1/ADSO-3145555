-- =========================================
-- LIMPIEZA
-- =========================================
DROP TRIGGER IF EXISTS trg_after_maintenance_update ON maintenance_event;
DROP FUNCTION IF EXISTS fn_post_maintenance_control();
DROP PROCEDURE IF EXISTS sp_register_maintenance_event(integer, integer, integer, varchar, timestamp, text);

-- =========================================
-- FUNCIÓN DEL TRIGGER
-- =========================================
CREATE OR REPLACE FUNCTION fn_post_maintenance_control()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    inspection_type_id INT;
BEGIN
    -- Solo actuar cuando cambia a COMPLETED
    IF NEW.status = 'COMPLETED' AND (OLD.status IS DISTINCT FROM NEW.status) THEN

        -- Buscar tipo INSPECTION
        SELECT maintenance_type_id
        INTO inspection_type_id
        FROM maintenance_type
        WHERE maintenance_type_name = 'INSPECTION'
        LIMIT 1;

        -- Insertar evento automático
        IF inspection_type_id IS NOT NULL THEN
            INSERT INTO maintenance_event (
                aircraft_id,
                maintenance_type_id,
                maintenance_provider_id,
                status,
                start_date,
                notes
            )
            VALUES (
                NEW.aircraft_id,
                inspection_type_id,
                NEW.maintenance_provider_id,
                'PENDING',
                NOW(),
                'Auto-generado por finalización de mantenimiento'
            );
        END IF;

    END IF;

    RETURN NEW;
END;
$$;

-- =========================================
-- TRIGGER
-- =========================================
CREATE TRIGGER trg_after_maintenance_update
AFTER UPDATE ON maintenance_event
FOR EACH ROW
EXECUTE FUNCTION fn_post_maintenance_control();

-- =========================================
-- PROCEDIMIENTO
-- =========================================
CREATE OR REPLACE PROCEDURE sp_register_maintenance_event(
    p_aircraft_id integer,
    p_maintenance_type_id integer,
    p_provider_id integer,
    p_status varchar,
    p_start_date timestamp,
    p_notes text
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO maintenance_event (
        aircraft_id,
        maintenance_type_id,
        maintenance_provider_id,
        status,
        start_date,
        notes
    )
    VALUES (
        p_aircraft_id,
        p_maintenance_type_id,
        p_provider_id,
        p_status,
        p_start_date,
        p_notes
    );
END;
$$;