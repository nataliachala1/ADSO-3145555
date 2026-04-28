DO $$
DECLARE
    v_ticket_segment_id INT;
BEGIN
    -- =========================================
    -- 1. Obtener segmento válido
    -- =========================================
    SELECT ticket_segment_id
    INTO v_ticket_segment_id
    FROM ticket_segment
    ORDER BY ticket_segment_id
    LIMIT 1;

    IF v_ticket_segment_id IS NULL THEN
        RAISE EXCEPTION 'No existe ticket_segment.';
    END IF;

    -- =========================================
    -- 2. Insert directo (dispara trigger)
    -- =========================================
    INSERT INTO baggage (
        ticket_segment_id,
        baggage_tag,
        baggage_type,
        status,
        registered_at
    )
    VALUES (
        v_ticket_segment_id,
        'BG-' || substring(md5(random()::text),1,6),
        'CHECKED',
        'RECEIVED',
        NOW()
    );

    -- =========================================
    -- 3. Usar procedimiento
    -- =========================================
    CALL sp_register_baggage(
        v_ticket_segment_id,
        'BG-' || substring(md5(random()::text),1,6),
        'CHECKED',
        'RECEIVED',
        NOW()
    );

END;
$$;

--validaciones
-- ver equipae registrado

SELECT
    b.baggage_id,
    b.ticket_segment_id,
    b.baggage_tag,
    b.baggage_type,
    b.status,
    b.registered_at
FROM baggage b
ORDER BY b.registered_at DESC
LIMIT 10;

--validad consistencia (equipaje vs asiento)
SELECT
    ts.ticket_segment_id,
    COUNT(b.baggage_id) AS total_baggage,
    COUNT(sa.seat_assignment_id) AS has_seat
FROM ticket_segment ts
LEFT JOIN baggage b 
    ON ts.ticket_segment_id = b.ticket_segment_id
LEFT JOIN seat_assignment sa 
    ON ts.ticket_segment_id = sa.ticket_segment_id
GROUP BY ts.ticket_segment_id
ORDER BY total_baggage DESC;