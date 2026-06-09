USE BD_Nincoming;

SELECT
	A.Id_Alo AS [ID Alojamiento],
	INA.IAl_Nombre AS [Nombre Alojamiento],
	--CONCAT(A.Id_Alo, ' - ', INA.IAl_Nombre) AS [ID + Nombre Alojamiento],
	ASH.Id_Tha AS [ID Tipo Habitación],
	INH.ITH_Nombre AS [Nombre Tipo Habitación],
	--CONCAT(ASH.Id_Tha, ' - ', INH.ITH_Nombre) AS [ID + Nombre Tipo Habitación],
	S.Ser_Tipo AS [Tipo Servicio],
	ASH.Id_Ser AS [ID Servicio],
	INS.ISe_Nombre AS [Nombre Servicio]
	--CONCAT(ASH.Id_Ser, ' - ', INS.ISe_Nombre) AS [ID + Nombre Servicio]
FROM 
				Tbl_Alojamiento			A
	INNER JOIN	Tbl_AloNSerTha			ASH		ON ASH.Id_Alo = A.Id_Alo
	INNER JOIN	Tbl_Servicio			S		ON S.Id_Ser = ASH.Id_Ser 
	INNER JOIN	Tbl_IDiNAlo				INA		ON INA.Id_Alo = A.Id_Alo AND INA.Id_Idi = 'ES'
	INNER JOIN	Tbl_IDiNser				INS		ON INS.Id_Ser = S.Id_Ser AND INS.Id_Idi = 'ES'
	INNER JOIN	Tbl_IdiNTHa				INH		ON INH.Id_THa = ASH.Id_Tha AND INH.Id_Idi = 'ES'
	INNER JOIN	Tbl_AloNTHa				ANH		ON ANH.Id_Alo = ASH.Id_Alo 
WHERE 1 = 1
	AND A.Alo_borrado = 0
	AND INA.IAl_Act = 1
	AND ANT_Eliminada = 0 
	AND Ant_Activa = 1
	AND A.Id_Alo = 32537
	AND ASH.Id_Tha IN (498)--,1938)
GROUP BY
	A.Id_Alo,
	INA.IAl_Nombre,
	ASH.Id_Tha,
	INH.ITH_Nombre,
	S.Ser_Tipo,
	ASH.Id_Ser,
	INS.ISe_Nombre
ORDER BY 
	A.Id_Alo,
	ASH.Id_Tha,
	ASH.Id_Ser




