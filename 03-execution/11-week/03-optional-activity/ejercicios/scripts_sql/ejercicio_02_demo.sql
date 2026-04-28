DO $$
DECLARE
    v_payment_id uuid;
BEGIN
    -- 1. Obtener un payment existente
    SELECT p.payment_id
    INTO v_payment_id
    FROM payment p
    ORDER BY p.created_at
    LIMIT 1;

    IF v_payment_id IS NULL THEN
        RAISE EXCEPTION 'No existe payment disponible.';
    END IF;

    -- =========================================
    -- 2. Ejecutar procedimiento (REVERSAL)
    -- =========================================
    CALL sp_register_payment_transaction(
        v_payment_id,
        'TX-REV-' || substring(md5(random()::text),1,6),
        'REVERSAL',
        150.00,
        'Reversal demo'
    );

    -- =========================================
    -- 3. Ejecutar procedimiento (REFUND)
    -- =========================================
    CALL sp_register_payment_transaction(
        v_payment_id,
        'TX-REF-' || substring(md5(random()::text),1,6),
        'REFUND',
        100.00,
        'Refund demo'
    );

END;
$$;

--validación resultado
SELECT
    pt.payment_transaction_id,
    pt.payment_id,
    pt.transaction_reference,
    pt.transaction_type,
    pt.transaction_amount,
    pt.processed_at
FROM payment_transaction pt
ORDER BY pt.created_at DESC
LIMIT 5;

--ver refunds generados automáticamente
SELECT
    r.refund_id,
    r.payment_id,
    r.refund_reference,
    r.amount,
    r.refund_reason,
    r.created_at
FROM refund r
ORDER BY r.created_at DESC
LIMIT 5;

--trazabilidad del refund generado automáticamente
SELECT
    s.sale_code,
    r.reservation_code,
    p.payment_reference,
    ps.status_name AS payment_status,
    pm.method_name AS payment_method,
    pt.transaction_reference,
    pt.transaction_type,
    pt.transaction_amount,
    c.iso_currency_code AS currency
FROM sale s
INNER JOIN reservation r 
    ON s.reservation_id = r.reservation_id
INNER JOIN payment p 
    ON s.sale_id = p.sale_id
INNER JOIN payment_status ps 
    ON p.payment_status_id = ps.payment_status_id
INNER JOIN payment_method pm 
    ON p.payment_method_id = pm.payment_method_id
INNER JOIN payment_transaction pt 
    ON p.payment_id = pt.payment_id
INNER JOIN currency c 
    ON p.currency_id = c.currency_id
ORDER BY pt.created_at DESC
LIMIT 10;

--relacion pago transacción refund
SELECT
    p.payment_reference,
    pt.transaction_reference,
    pt.transaction_type,
    pt.transaction_amount,
    r.refund_reference,
    r.amount
FROM payment p
INNER JOIN payment_transaction pt 
    ON p.payment_id = pt.payment_id
LEFT JOIN refund r 
    ON p.payment_id = r.payment_id
ORDER BY pt.created_at DESC;