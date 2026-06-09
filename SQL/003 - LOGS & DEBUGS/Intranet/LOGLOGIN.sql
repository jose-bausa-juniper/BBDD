USE BD_TestSuppliers

SELECT
	CASE Log_EstadoValidacion
		WHEN 0 THEN 'SINVALIDACION'
		WHEN 1 THEN 'ESPERANDO'
		WHEN 2 THEN 'VALIDADO'
		WHEN 3 THEN 'VALIDADO_NAVEGADOR_SO'
		WHEN 4 THEN 'VALIDADO_IP'
	END,
	*
FROM
	Tbl_LogLogins
WHERE 
	1 = 1
	AND Feccre > '2025-02-19 09:05:00.000'
	--AND Log_IdUsuario = 917
	--AND Log_EstadoValidacion = 2




--INSERT INTO tbl_parametro (Par_Libreria, Par_Codigo, Par_Valor, Feccre, Fecmod) VALUES ('BookingEngine','Seguridad/ValidacionMFASegura','true', GETDATE(),GETDATE()) 
--SELECT * FROM Tbl_Parametro WHERE Par_Codigo LIKE 'Seguridad/ValidacionMFASegura'



