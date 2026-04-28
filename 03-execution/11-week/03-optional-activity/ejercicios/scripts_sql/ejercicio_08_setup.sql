-- =========================================
-- LIMPIEZA
-- =========================================
DROP TRIGGER IF EXISTS trg_after_insert_user_role ON user_role;
DROP FUNCTION IF EXISTS fn_after_insert_user_role();
DROP PROCEDURE IF EXISTS sp_assign_role_to_user(integer, integer, timestamp);

-- =========================================
-- FUNCIÓN DEL TRIGGER
-- =========================================
CREATE OR REPLACE FUNCTION fn_after_insert_user_role()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_role_name TEXT;
BEGIN
    -- Obtener nombre del rol
    SELECT name INTO v_role_name
    FROM security_role
    WHERE security_role_id = NEW.security_role_id;

    -- Si es rol crítico → activar usuario
    IF UPPER(v_role_name) IN ('ADMIN', 'SUPERUSER') THEN
        UPDATE user_account
        SET user_status_id = (
            SELECT user_status_id
            FROM user_status
            WHERE UPPER(name) = 'ACTIVE'
            LIMIT 1
        )
        WHERE user_account_id = NEW.user_account_id;
    END IF;

    RETURN NEW;
END;
$$;

-- =========================================
-- TRIGGER
-- =========================================
CREATE TRIGGER trg_after_insert_user_role
AFTER INSERT ON user_role
FOR EACH ROW
EXECUTE FUNCTION fn_after_insert_user_role();

-- =========================================
-- PROCEDIMIENTO
-- =========================================
CREATE OR REPLACE PROCEDURE sp_assign_role_to_user(
    p_user_account_id INT,
    p_security_role_id INT,
    p_assigned_at TIMESTAMP
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO user_role (
        user_account_id,
        security_role_id,
        assigned_at
    )
    VALUES (
        p_user_account_id,
        p_security_role_id,
        p_assigned_at
    );
END;
$$;