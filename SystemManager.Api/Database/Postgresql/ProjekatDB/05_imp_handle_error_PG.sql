CREATE OR REPLACE FUNCTION spec.handle_error(
    p_error_message TEXT,
    p_procedure_name TEXT
)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    -- Logovanje greške u Error_Log tabelu
    INSERT INTO impl.error_log (error_message, procedure_name)
    VALUES (p_error_message, p_procedure_name);

    -- Ne vrši se RAISE ovde — bare RAISE radi samo unutar EXCEPTION bloka
    -- koji je uhvatio grešku. Pozivalac vrši RAISE nakon poziva ove funkcije.
END;
$$;
