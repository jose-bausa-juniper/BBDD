SELECT
TOP 100 *
FROM Tbl_LogLogins
WHERE Log_IdUsuario = 4 AND Log_Tipo = 'WSA'
ORDER BY id_log DESC


-- VALIDADO SE REGISTRA webservicejpdm/operations/usertransactions.asmx  VALIDA IP
-- VALIDADO SE REGISTRA webservicejpdm/operations/booktransactions.asmx NO VALIDA IP
-- VALIDADO SE REGISTRA wsExportacion/wsBookings.asmx NO VALIDA IP