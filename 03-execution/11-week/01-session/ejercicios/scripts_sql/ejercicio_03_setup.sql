-- =========================================
-- LIMPIEZA
-- =========================================
DROP TRIGGER IF EXISTS trg_invoice_line_after_insert ON invoice_line;
DROP FUNCTION IF EXISTS fn_update_invoice_timestamp();
DROP PROCEDURE IF EXISTS sp_add_invoice_line(uuid, uuid, integer, varchar, numeric, numeric);

-- =========================================
-- FUNCIÓN DEL TRIGGER
-- =========================================
CREATE OR REPLACE FUNCTION fn_update_invoice_timestamp()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE invoice
    SET updated_at = now()
    WHERE invoice_id = NEW.invoice_id;

    RETURN NEW;
END;
$$;

-- =========================================
-- TRIGGER
-- =========================================
CREATE TRIGGER trg_invoice_line_after_insert
AFTER INSERT ON invoice_line
FOR EACH ROW
EXECUTE FUNCTION fn_update_invoice_timestamp();

-- =========================================
-- PROCEDIMIENTO
-- =========================================
CREATE OR REPLACE PROCEDURE sp_add_invoice_line(
    p_invoice_id uuid,
    p_tax_id uuid,
    p_line_number integer,
    p_description varchar,
    p_quantity numeric,
    p_unit_price numeric
)
LANGUAGE plpgsql
AS $$
BEGIN
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
        p_invoice_id,
        p_tax_id,
        p_line_number,
        p_description,
        p_quantity,
        p_unit_price,
        now(),
        now()
    );
END;
$$;