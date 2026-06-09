USE BD_Nincoming;

--SELECT * FROM Tbl_Parametro WHERE Par_Codigo = 'ActiveXForwardedSecurityFix' AND Id_Par = 6460;

 --UPDATE Tbl_Parametro
 --SET Par_Valor = 'true'
 --WHERE Id_Par = 6460 AND Par_Codigo='ActiveXForwardedSecurityFix'

SELECT id_Res, his_fecha, his_texto 
FROM Tbl_Historial H
WHERE 1=1
	AND His_Usuario = 'Adm:w2m.hub.task'
	AND h.feccre >= '2024-04-10'
	AND 
		(
		his_texto LIKE '<text><es>Se ha marcado la reserva como facturada externa%'
		OR 
		his_texto LIKE '<text><es>Se ha guardado una factura externa para esta reserva%'
		)
	AND h.id_res IN (SELECT id_res FROM tbl_lineareserva WHERE (LRe_finiViaje BETWEEN '2024-04-03 00:00' AND '2024-04-10 23:59') AND LRe_CupoAsignado=1)
ORDER BY his_Fecha