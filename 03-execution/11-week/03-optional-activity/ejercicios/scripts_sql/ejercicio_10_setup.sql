-- ============================================
-- FUNCIÓN: Validar contacto después de documento
-- ============================================

CREATE OR REPLACE FUNCTION fn_validate_person_contact_after_document()
RETURNS TRIGGER AS $$
DECLARE
    v_contact_count INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO v_contact_count
    FROM person_contact
    WHERE person_id = NEW.person_id;

    IF v_contact_count = 0 THEN
        RAISE EXCEPTION 
        'La persona % no tiene contactos registrados. No se puede registrar documento.',
        NEW.person_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- ============================================
-- TRIGGER
-- ============================================

CREATE TRIGGER trg_after_person_document
AFTER INSERT OR UPDATE ON person_document
FOR EACH ROW
EXECUTE FUNCTION fn_validate_person_contact_after_document();


-- ============================================
-- PROCEDIMIENTO: Registrar documento de persona
-- ============================================

CREATE OR REPLACE PROCEDURE sp_register_person_document(
    p_person_id INT,
    p_document_type_id INT,
    p_document_number VARCHAR,
    p_issue_date DATE,
    p_expiration_date DATE
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_exists INTEGER;
BEGIN
    -- Validar existencia de persona
    SELECT COUNT(*) INTO v_exists
    FROM person
    WHERE person_id = p_person_id;

    IF v_exists = 0 THEN
        RAISE EXCEPTION 'La persona no existe';
    END IF;

    -- Validar duplicado
    SELECT COUNT(*) INTO v_exists
    FROM person_document
    WHERE document_number = p_document_number;

    IF v_exists > 0 THEN
        RAISE EXCEPTION 'Documento ya existe';
    END IF;

    -- Validar fechas
    IF p_expiration_date IS NOT NULL 
       AND p_expiration_date <= p_issue_date THEN
        RAISE EXCEPTION 'Fecha de expiración inválida';
    END IF;

    -- Insertar (dispara trigger)
    INSERT INTO person_document (
        person_id,
        document_type_id,
        document_number,
        issue_date,
        expiration_date
    )
    VALUES (
        p_person_id,
        p_document_type_id,
        p_document_number,
        p_issue_date,
        p_expiration_date
    );
END;
$$;