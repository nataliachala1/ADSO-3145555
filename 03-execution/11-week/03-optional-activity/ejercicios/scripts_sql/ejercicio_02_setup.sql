-- Limpieza previa
DROP TRIGGER IF EXISTS trg_generate_refund ON payment_transaction;
DROP FUNCTION IF EXISTS fn_generate_refund();
DROP PROCEDURE IF EXISTS sp_register_payment_transaction(uuid, varchar, varchar, numeric, text);

-- =========================================
-- FUNCIÓN DEL TRIGGER
-- =========================================
CREATE OR REPLACE FUNCTION fn_generate_refund()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.transaction_type IN ('REFUND', 'REVERSAL') THEN
        
        INSERT INTO refund (
            refund_id,
            payment_id,
            refund_reference,
            amount,
            requested_at,
            processed_at,
            refund_reason,
            created_at,
            updated_at
        )
        VALUES (
            gen_random_uuid(),
            NEW.payment_id,
            'RF-' || substr(NEW.transaction_reference, 1, 10),
            NEW.transaction_amount,
            NEW.processed_at,
            NEW.processed_at,
            'AUTO GENERATED FROM ' || NEW.transaction_type,
            now(),
            now()
        );

    END IF;

    RETURN NEW;
END;
$$;

-- =========================================
-- TRIGGER
-- =========================================
CREATE TRIGGER trg_generate_refund
AFTER INSERT ON payment_transaction
FOR EACH ROW
EXECUTE FUNCTION fn_generate_refund();

-- =========================================
-- PROCEDIMIENTO
-- =========================================
CREATE OR REPLACE PROCEDURE sp_register_payment_transaction(
    p_payment_id uuid,
    p_transaction_reference varchar,
    p_transaction_type varchar,
    p_transaction_amount numeric,
    p_provider_message text
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO payment_transaction (
        payment_transaction_id,
        payment_id,
        transaction_reference,
        transaction_type,
        transaction_amount,
        processed_at,
        provider_message,
        created_at,
        updated_at
    )
    VALUES (
        gen_random_uuid(),
        p_payment_id,
        p_transaction_reference,
        p_transaction_type,
        p_transaction_amount,
        now(),
        p_provider_message,
        now(),
        now()
    );
END;
$$;