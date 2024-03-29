BEGIN TRANSACTION;

BEGIN TRY

DELETE
FROM dbo.tmp_issue_changelog 
WHERE created <= convert(datetime, '2019-08-01', 120)

END TRY
       
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

    SELECT 
        @ErrorMessage = ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE();

    RAISERROR (@ErrorMessage, -- Message text.
               @ErrorSeverity, -- Severity.
               @ErrorState -- State.
               );
END CATCH;

IF @@TRANCOUNT > 0 BEGIN
    COMMIT TRANSACTION;
    print 'OK'
END 
GO