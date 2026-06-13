-- Opprett et eksempel-skjema
CREATE SCHEMA IF NOT EXISTS analytics;

-- Tabell for logging
CREATE TABLE IF NOT EXISTS analytics.event_log (
    id SERIAL PRIMARY KEY,
    event_time TIMESTAMP DEFAULT NOW(),
    event_type TEXT,
    details JSONB
);

-- Funksjon som gjør masse PL/pgSQL-greier
CREATE OR REPLACE FUNCTION analytics.process_user_activity(user_id INT)
RETURNS TEXT AS $$
DECLARE
    activity_count INT;
    last_activity TIMESTAMP;
    msg TEXT;
BEGIN
    -- Tell aktiviteter
    SELECT COUNT(*), MAX(timestamp)
    INTO activity_count, last_activity
    FROM user_activity
    WHERE uid = user_id;

    -- Hvis ingen aktivitet
    IF activity_count = 0 THEN
        msg := 'No activity found';
    ELSE
        msg := FORMAT('User %s has %s activities. Last at %s',
                      user_id, activity_count, last_activity);
    END IF;

    -- Logg resultatet
    INSERT INTO analytics.event_log(event_type, details)
    VALUES ('process_user_activity', jsonb_build_object(
        'user_id', user_id,
        'activity_count', activity_count,
        'last_activity', last_activity
    ));

    RETURN msg;
EXCEPTION
    WHEN OTHERS THEN
        INSERT INTO analytics.event_log(event_type, details)
        VALUES ('error', jsonb_build_object(
            'user_id', user_id,
            'error', SQLERRM
        ));
        RETURN 'Error occurred';
END;
$$ LANGUAGE plpgsql;

-- Trigger-funksjon
CREATE OR REPLACE FUNCTION analytics.log_user_insert()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO analytics.event_log(event_type, details)
    VALUES ('user_insert', jsonb_build_object(
        'new_user_id', NEW.id,
        'username', NEW.username
    ));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger
CREATE TRIGGER trg_log_user_insert
AFTER INSERT ON users
FOR EACH ROW
EXECUTE FUNCTION analytics.log_user_insert();

-- Eksempel på dynamisk SQL
CREATE OR REPLACE FUNCTION analytics.count_rows(tablename TEXT)
RETURNS INT AS $$
DECLARE
    result INT;
    sql TEXT;
BEGIN
    sql := FORMAT('SELECT COUNT(*) FROM %I', tablename);
    EXECUTE sql INTO result;
    RETURN result;
END;
$$ LANGUAGE plpgsql;