USE BD_Nincoming

SELECT 
TOP 10
	* 
FROM			Tbl_Historial	H
	INNER JOIN	Tbl_Reserva		R ON H.id_Res = R.Id_Res
WHERE
	1 = 1
	AND R.Feccre > GETDATE()
	AND	R.Id_Can = 'WPRO'
	AND R.Id_Ifz = 'XML'
	--AND H.His_Usuario = 'Adm:next.payments'