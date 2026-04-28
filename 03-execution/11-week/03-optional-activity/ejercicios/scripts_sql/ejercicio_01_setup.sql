-- ============================================
-- PROCEDIMIENTO: Registrar Check-in
-- ============================================

CREATE OR REPLACE PROCEDURE sp_register_check_in(
    p_ticket_segment_id uuid,
    p_check_in_status_id uuid,
    p_boarding_group_id uuid,
    p_user_id uuid,
    p_checked_in_at timestamp
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO check_in (
        check_in_id,
        ticket_segment_id,
        check_in_status_id,
        boarding_group_id,
        checked_in_by_user_id,
        checked_in_at,
        created_at,
        updated_at
    )
    VALUES (
        gen_random_uuid(),
        p_ticket_segment_id,
        p_check_in_status_id,
        p_boarding_group_id,
        p_user_id,
        p_checked_in_at,
        now(),
        now()
    );
END;
$$;


-- ============================================
-- FUNCIÓN: Generar Boarding Pass automáticamente
-- ============================================

CREATE OR REPLACE FUNCTION fn_generate_boarding_pass()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO boarding_pass (
        boarding_pass_id,
        check_in_id,
        boarding_pass_code,
        barcode_value,
        issued_at,
        created_at,
        updated_at
    )
    VALUES (
        gen_random_uuid(),
        NEW.check_in_id,
        'BP-' || substr(NEW.check_in_id::text, 1, 8),
        encode(digest(NEW.check_in_id::text, 'sha256'), 'hex'),
        now(),
        now(),
        now()
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- ============================================
-- TRIGGER
-- ============================================

CREATE TRIGGER trg_generate_boarding_pass
AFTER INSERT ON check_in
FOR EACH ROW
EXECUTE FUNCTION fn_generate_boarding_pass();