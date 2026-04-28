-- =========================================
-- LIMPIEZA
-- =========================================
DROP TRIGGER IF EXISTS trg_after_miles_transaction ON miles_transaction;
DROP FUNCTION IF EXISTS fn_update_loyalty_tier();
DROP PROCEDURE IF EXISTS sp_register_miles_transaction(integer, varchar, numeric, timestamp, text);

-- =========================================
-- FUNCIÓN DEL TRIGGER
-- =========================================
CREATE OR REPLACE FUNCTION fn_update_loyalty_tier()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    total_miles NUMERIC;
    current_tier_id INT;
    next_tier_id INT;
BEGIN
    -- Calcular millas acumuladas
    SELECT COALESCE(SUM(mt.miles_amount), 0)
    INTO total_miles
    FROM miles_transaction mt
    WHERE mt.loyalty_account_id = NEW.loyalty_account_id;

    -- Obtener nivel actual
    SELECT loyalty_tier_id
    INTO current_tier_id
    FROM loyalty_account_tier
    WHERE loyalty_account_id = NEW.loyalty_account_id
    ORDER BY assigned_date DESC
    LIMIT 1;

    -- Regla de promoción
    IF total_miles >= 10000 THEN

        SELECT loyalty_tier_id
        INTO next_tier_id
        FROM loyalty_tier
        WHERE loyalty_tier_id > current_tier_id
        ORDER BY loyalty_tier_id
        LIMIT 1;

        -- Insertar siguiente tier si existe
        IF next_tier_id IS NOT NULL THEN
            INSERT INTO loyalty_account_tier (
                loyalty_account_id,
                loyalty_tier_id,
                assigned_date
            )
            VALUES (
                NEW.loyalty_account_id,
                next_tier_id,
                NOW()
            );
        END IF;

    END IF;

    RETURN NEW;
END;
$$;

-- =========================================
-- TRIGGER
-- =========================================
CREATE TRIGGER trg_after_miles_transaction
AFTER INSERT ON miles_transaction
FOR EACH ROW
EXECUTE FUNCTION fn_update_loyalty_tier();

-- =========================================
-- PROCEDIMIENTO
-- =========================================
CREATE OR REPLACE PROCEDURE sp_register_miles_transaction(
    p_loyalty_account_id integer,
    p_transaction_type varchar,
    p_miles_amount numeric,
    p_event_date timestamp,
    p_reference text
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO miles_transaction (
        loyalty_account_id,
        transaction_type,
        miles_amount,
        event_date,
        reference
    )
    VALUES (
        p_loyalty_account_id,
        p_transaction_type,
        p_miles_amount,
        p_event_date,
        p_reference
    );
END;
$$;