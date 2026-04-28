DO $$
DECLARE
    v_loyalty_account_id integer;
BEGIN
    -- =========================================
    -- 1. Obtener cuenta válida
    -- =========================================
    SELECT la.loyalty_account_id
    INTO v_loyalty_account_id
    FROM loyalty_account la
    ORDER BY la.loyalty_account_id
    LIMIT 1;

    IF v_loyalty_account_id IS NULL THEN
        RAISE EXCEPTION 'No existe loyalty_account disponible.';
    END IF;

    -- =========================================
    -- 2. Insert directo (dispara trigger)
    -- =========================================
    INSERT INTO miles_transaction (
        loyalty_account_id,
        transaction_type,
        miles_amount,
        event_date,
        reference
    )
    VALUES (
        v_loyalty_account_id,
        'ACCUMULATION',
        12000,
        NOW(),
        'Demo international flight'
    );

    -- =========================================
    -- 3. Procedimiento almacenado
    -- =========================================
    CALL sp_register_miles_transaction(
        v_loyalty_account_id,
        'ACCUMULATION',
        5000,
        NOW(),
        'Demo extra purchase'
    );

END;
$$;

--validación

--ver millas acumuladas
SELECT
    loyalty_account_id,
    SUM(miles_amount) AS total_miles
FROM miles_transaction
GROUP BY loyalty_account_id
ORDER BY total_miles DESC
LIMIT 10;

--ver historial de niveles
SELECT
    lat.loyalty_account_id,
    lt.tier_name,
    lat.assigned_date
FROM loyalty_account_tier lat
INNER JOIN loyalty_tier lt
    ON lt.loyalty_tier_id = lat.loyalty_tier_id
ORDER BY lat.assigned_date DESC
LIMIT 10;