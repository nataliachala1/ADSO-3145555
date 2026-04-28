DO $$
DECLARE
    v_invoice_id uuid;
    v_tax_id uuid;
BEGIN
    -- =========================================
    -- 1. Obtener datos reales
    -- =========================================
    SELECT i.invoice_id
    INTO v_invoice_id
    FROM invoice i
    ORDER BY i.created_at
    LIMIT 1;

    SELECT t.tax_id
    INTO v_tax_id
    FROM tax t
    ORDER BY t.created_at
    LIMIT 1;

    IF v_invoice_id IS NULL THEN
        RAISE EXCEPTION 'No existe invoice disponible.';
    END IF;

    IF v_tax_id IS NULL THEN
        RAISE EXCEPTION 'No existe tax disponible.';
    END IF;

    -- =========================================
    -- 2. Insert directo (dispara trigger)
    -- =========================================
    INSERT INTO invoice_line (
        invoice_line_id,
        invoice_id,
        tax_id,
        line_number,
        line_description,
        quantity,
        unit_price,
        created_at,
        updated_at
    )
    VALUES (
        gen_random_uuid(),
        v_invoice_id,
        v_tax_id,
        1,
        'Demo line 1',
        2,
        50.00,
        now(),
        now()
    );

    -- =========================================
    -- 3. Usar procedimiento
    -- =========================================
    CALL sp_add_invoice_line(
        v_invoice_id,
        v_tax_id,
        2,
        'Demo line 2',
        1,
        100.00
    );

END;
$$;

--validaciones

--ver lineas creadas
SELECT
    il.invoice_line_id,
    il.invoice_id,
    il.line_number,
    il.line_description,
    il.quantity,
    il.unit_price
FROM invoice_line il
ORDER BY il.created_at DESC
LIMIT 5;

--validar que el trigger actualizo el invoice
SELECT
    i.invoice_id,
    i.updated_at
FROM invoice i
ORDER BY i.updated_at DESC
LIMIT 5;

