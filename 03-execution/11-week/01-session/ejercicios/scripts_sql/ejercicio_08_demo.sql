DO $$
DECLARE
    v_user_id INT;
    v_role_id INT;
BEGIN
    -- =========================================
    -- 1. Obtener usuario
    -- =========================================
    SELECT user_account_id
    INTO v_user_id
    FROM user_account
    ORDER BY user_account_id
    LIMIT 1;

    -- =========================================
    -- 2. Obtener rol crítico (ADMIN o SUPERUSER)
    -- =========================================
    SELECT security_role_id
    INTO v_role_id
    FROM security_role
    WHERE UPPER(name) IN ('ADMIN', 'SUPERUSER')
    ORDER BY security_role_id
    LIMIT 1;

    IF v_user_id IS NULL THEN
        RAISE EXCEPTION 'No existe usuario.';
    END IF;

    IF v_role_id IS NULL THEN
        RAISE EXCEPTION 'No existe rol crítico.';
    END IF;

    -- =========================================
    -- 3. Asignar rol (DISPARA TRIGGER)
    -- =========================================
    CALL sp_assign_role_to_user(
        v_user_id,
        v_role_id,
        NOW()
    );

END;
$$;

--validaciones
--ver eventos de mantenimiento registrados
SELECT *
FROM maintenance_event
WHERE aircraft_id = 1
ORDER BY start_date DESC;

--ver eventos generados automáticamente
SELECT *
FROM maintenance_event
WHERE notes LIKE '%Auto-generado%'
ORDER BY start_date DESC;