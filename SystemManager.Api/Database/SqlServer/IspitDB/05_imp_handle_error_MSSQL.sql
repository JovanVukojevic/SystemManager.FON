CREATE OR ALTER PROCEDURE [spec].[HandleError]
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ErrorNumber    INT             = ERROR_NUMBER();
    DECLARE @ErrorMessage   NVARCHAR(4000)  = ERROR_MESSAGE();
    DECLARE @ProcedureName  NVARCHAR(128)   = ERROR_PROCEDURE();

    -- Logovanje greške u Error_Log tabelu
    INSERT INTO impl.Error_Log (ErrorNumber, ErrorMessage, ProcedureName)
    VALUES (@ErrorNumber, @ErrorMessage, @ProcedureName);

    -- Ponovo bacanje originalne greške pozivaocu
    -- THROW zahteva broj >= 50000; sistemske greške reraise-ujemo via RAISERROR
    IF @ErrorNumber >= 50000
        THROW @ErrorNumber, @ErrorMessage, 1;
    ELSE
        RAISERROR(@ErrorMessage, 16, 1);
END;
GO
