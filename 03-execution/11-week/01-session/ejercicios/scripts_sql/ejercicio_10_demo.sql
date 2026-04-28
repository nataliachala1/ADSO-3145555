DO $$
DECLARE
    v_person_id INT;
    v_document_type_id INT;
BEGIN
    -- Obtener datos
    SELECT person_id INTO v_person_id FROM person LIMIT 1;
    SELECT document_type_id INTO v_document_type_id FROM document_type LIMIT 1;

    IF v_person_id IS NULL THEN
        RAISE EXCEPTION 'No existe persona disponible';
    END IF;

    -- Ejecutar procedimiento (dispara trigger)
    CALL sp_register_person_document(
        v_person_id,
        v_document_type_id,
        'AUTO-' || v_person_id,
        CURRENT_DATE,
        CURRENT_DATE + INTERVAL '10 years'
    );
END;
$$;

--validación 
--verificar documento insertado
SELECT *
FROM person_document
WHERE document_number = 'ABC123456';

--validar que la persona tiene contacto
SELECT *
FROM person_contact
WHERE person_id = 1;

--trazabilidad completa
SELECT
    p.person_id,
    p.first_name,
    p.last_name,
    pd.document_number,
    pc.contact_value
FROM person p
INNER JOIN person_document pd 
    ON p.person_id = pd.person_id
INNER JOIN person_contact pc 
    ON p.person_id = pc.person_id;