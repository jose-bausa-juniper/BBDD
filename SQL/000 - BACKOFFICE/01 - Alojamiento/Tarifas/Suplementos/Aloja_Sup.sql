USE BD_Nincoming
SELECT 
	--COUNT(ASU.Id_Asu) AS COUNT,
	ASU.Id_Asu,
	A.Id_Alo,
	INA.IAl_Nombre,
	CCOA.Id_CCo,
	CCOA.CCo_Nombre,
	INASU.IAS_Nombre,
	ASU.Id_TSu,
	TSU.TSu_Clase,
	ASU.ASu_Extranet,
	ASU.UsuCre,
	ASU.ASu_TipoSuplemento,
	ASU.ASu_AplicacionSuplemento,
	ASUP.ASP_BaseTipo,
	ASUP.ASP_Porce,
	ASUP.Id_Reg
FROM
				Tbl_Alojamiento					A
	INNER JOIN	Tbl_IDiNAlo						INA		ON INA.Id_Alo = A.Id_Alo AND INA.Id_Idi = 'ES'
	INNER JOIN	Tbl_ASuNAlo						ASUNALO ON ASUNALO.Id_Alo = A.Id_Alo
	INNER JOIN	Tbl_AlojamientoSuplemento		ASU		ON ASU.Id_ASu = ASUNALO.Id_ASu
	INNER JOIN	Tbl_TipoSuplemento				TSU		ON TSU.Id_TSu = ASU.Id_TSu
	INNER JOIN	Tbl_AlojamientoSuplementoPrecio	ASUP	ON ASUP.Id_ASu = ASU.Id_ASu
	--INNER JOIN	Tbl_AlojamientoSuplementoFecha	ASUF	ON ASUF.Id_ASu = ASU.Id_ASu
	INNER JOIN	Tbl_IdiNASu						INASU	ON INASU.Id_Asu = ASU.Id_ASu AND INASU.Id_Idi = 'ES'
	INNER JOIN	Tbl_ASuNCCo						ASUNCO	ON ASUNCO.Id_ASu = ASU.Id_ASu
	INNER JOIN	Tbl_ContratoCompraAloja			CCOA	ON CCOA.Id_CCo = ASUNCO.Id_CCo
WHERE
	1 = 1
	AND A.Id_Alo = 28975
	AND CCOA.Id_CCo = 298775
	--AND INASU.IAS_Nombre IN ('SPWIN2025-05 (%D ON BB)')
	--AND ASU.Id_ASu = 137951526
GROUP BY
	ASU.Id_Asu,
	A.Id_Alo,
	INA.IAl_Nombre,
	CCOA.Id_CCo,
	CCOA.CCo_Nombre,
	INASU.IAS_Nombre,
	ASU.Id_TSu,
	TSU.TSu_Clase,
	ASU.ASu_Extranet,
	ASU.UsuCre,
	ASU.ASu_TipoSuplemento,
	ASU.ASu_AplicacionSuplemento,
	ASUP.ASP_BaseTipo,
	ASUP.ASP_Porce,
	ASUP.Id_Reg
ORDER BY
	A.Id_Alo,
	INA.IAl_Nombre,
	CCOA.Id_CCo,
	CCOA.CCo_Nombre,
	INASU.IAS_Nombre,
	ASU.Id_TSu,
	TSU.TSu_Clase,
	ASU.ASu_Extranet,
	ASU.UsuCre,
	ASU.ASu_TipoSuplemento,
	ASU.ASu_AplicacionSuplemento,
	ASUP.ASP_BaseTipo,
	ASUP.ASP_Porce,
	ASUP.Id_Reg,
	ASU.Id_Asu



--SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME LIKE '%Id_TSu%'

--SELECT * FROM Tbl_AlojamientoSuplementoPrecio WHERE Id_Asu = 137910774

