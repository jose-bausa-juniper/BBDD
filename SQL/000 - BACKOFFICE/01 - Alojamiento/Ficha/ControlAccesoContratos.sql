USE BD_Nincoming
DECLARE @ALO INT; SET @ALO = 96;
DECLARE @CONTRATO_CUPO INT; SET @CONTRATO_CUPO = 38212;
DECLARE @CONTRATO_COMPRA INT; SET @CONTRATO_COMPRA = 254636;
DECLARE @CONTRATO_VENTA INT; SET @CONTRATO_VENTA = 126026;


--SELECT
--	A.Id_Alo,
--	CCuA.Id_CCu,
--	CACu.Id_Con,
--	CCoA.Id_CCo,
--	CACo.Id_Con,
--	CVeA.Id_CVe,
--	CAVe.Id_CCo
--FROM 
--					Tbl_Alojamiento			A
--	LEFT JOIN		Tbl_ContratoCupoAloja	CCuA	ON	CCuA.Id_Alo = A.Id_Alo
--	LEFT JOIN		Tbl_ContratoCompraAloja	CCoA	ON	CCoA.Id_Alo = A.Id_Alo
--	LEFT JOIN		Tbl_ContratoVentaAloja	CVeA	ON	CVeA.Id_Alo = A.Id_Alo
--	LEFT JOIN		Tbl_ContratoAloja		CACu	ON	CACu.Id_CCu = CCuA.Id_CCu
--	LEFT JOIN		Tbl_ContratoAloja		CACo	ON	CACo.Id_CCu = CCoA.Id_CCo
--	LEFT JOIN		Tbl_ContratoAloja		CAVe	ON	CAVe.Id_CCu = CVeA.Id_CVe
--WHERE
--	A.Id_Alo = @ALO



-------- CONTRATOS CUPO ------------
SELECT 
	CCuA.Id_Alo											AS [ALO],
	CCuA.Id_CCu											AS [ID_CON_CUPO],
	CCuA.Ccu_Nombre										AS [CON_CUPO_NOMBRE],
	CASE 
		WHEN C.Cli_Nombre IS NULL THEN 'Todos'
		ELSE C.Cli_Nombre
	END													AS [CLIENTE],
	CASE
		WHEN GA.GRA_Nombre IS NULL THEN 'Todos'
		ELSE GA.GRA_Nombre
	END													AS [GRUPO AGENCIA],
	CASE
		WHEN M.Mer_Nombre IS NULL THEN 'Todos'
		ELSE M.Mer_Nombre
	END													AS [MERCADO],
	CASE
		WHEN P.pai_Nombre IS NULL THEN 'Todos'
		ELSE P.pai_Nombre
	END													AS [PAIS],
	CASE
		WHEN GP.GPa_Nombre IS NULL THEN 'Todos'
		ELSE GP.GPa_Nombre
	END													AS [GRUPO PAIS],
	CASE 
		WHEN CAE.CAE_denegar IS NULL	THEN 'PERMITIDO'
		WHEN CAE.CAE_denegar = 0		THEN 'PERMITIDO'
		WHEN CAE.CAE_denegar = 1		THEN 'DENEGADO'

	END													AS [ACCESO]
FROM 
				Tbl_ContratoCupoAloja		CCuA
	LEFT JOIN	Tbl_ControlAcceso			CA	ON CA.CAc_Tipo = 'CCuA' AND CA.CAc_Codigo = CCuA.Id_CCu
	LEFT JOIN	Tbl_ControlAccesoExtendido	CAE	ON CAE.Id_CAc = CA.Id_CAc
	LEFT JOIN	Tbl_Cliente					C	ON C.Id_Cli = CA.Id_Cli
	LEFT JOIN	Tbl_GrupoAgencia			GA	ON GA.Id_GRA = CA.Id_Gra 
	LEFT JOIN	Tbl_Mercado					M	ON M.Id_Mer = CA.Id_Mer
	LEFT JOIN	Tbl_Paises					p	ON P.id_pai	= CAE.Id_Pai
	LEFT JOIN	Tbl_GrupoPais				GP	ON GP.id_GPa = CAE.Id_GPa
WHERE 
	1 = 1
	AND CCuA.Id_Alo = @ALO
	AND CCuA.Ccu_Activo = 1
	AND CCuA.Ccu_FechaFinTemporada >= GETDATE()
	--AND CCuA.Id_CCu = @CONTRATO_CUPO
ORDER BY
	CCuA.Id_CCu

-------- CONTRATOS COMPRA ------------
SELECT 
	CCoA.Id_Alo											AS [ALO],
	CCoA.Id_CCo											AS [ID_CON_COMPRA],
	ITC.ITT_Descripcion									AS [TIPO_CON_VENTA],
	CCoA.CCo_Nombre										AS [CON_COMPRA_NOMBRE],
	CASE 
		WHEN C.Cli_Nombre IS NULL THEN 'Todos'
		ELSE C.Cli_Nombre
	END													AS [CLIENTE],
	CASE
		WHEN GA.GRA_Nombre IS NULL THEN 'Todos'
		ELSE GA.GRA_Nombre
	END													AS [GRUPO AGENCIA],
	CASE
		WHEN M.Mer_Nombre IS NULL THEN 'Todos'
		ELSE M.Mer_Nombre
	END													AS [MERCADO],
	CASE
		WHEN P.pai_Nombre IS NULL THEN 'Todos'
		ELSE P.pai_Nombre
	END													AS [PAIS],
	CASE
		WHEN GP.GPa_Nombre IS NULL THEN 'Todos'
		ELSE GP.GPa_Nombre
	END													AS [GRUPO PAIS],
	CASE CAE.CAE_denegar
		WHEN 0 THEN 'PERMITIDO'
		WHEN 1 THEN	'DENEGADO'
	END													AS [ACCESO]
FROM 
				Tbl_ContratoCompraAloja		CCoA
	LEFT JOIN	Tbl_IdiNTTa					ITC	ON ITC.Id_TTa = CCoA.Id_TTa
	LEFT JOIN	Tbl_ControlAcceso			CA	ON CA.CAc_Tipo = 'CCoA' AND CA.CAc_Codigo = CCoA.Id_CCo
	LEFT JOIN	Tbl_ControlAccesoExtendido	CAE	ON CAE.Id_CAc = CA.Id_CAc
	LEFT JOIN	Tbl_Cliente					C	ON C.Id_Cli = CA.Id_Cli
	LEFT JOIN	Tbl_GrupoAgencia			GA	ON GA.Id_GRA = CA.Id_Gra 
	LEFT JOIN	Tbl_Mercado					M	ON M.Id_Mer = CA.Id_Mer
	LEFT JOIN	Tbl_Paises					p	ON P.id_pai	= CAE.Id_Pai
	LEFT JOIN	Tbl_GrupoPais				GP	ON GP.id_GPa = CAE.Id_GPa
WHERE 
	1 = 1
	AND CCoA.Id_Alo = @ALO
	AND CCoA.CCo_Activo = 1
	AND CCoA.CCo_FinTemporada >= GETDATE()
	--AND CCoA.Id_CCo = @CONTRATO_COMPRA
ORDER BY
	CCoA.Id_CCo

-------- CONTRATOS VENTA ------------
SELECT 
	CVeA.Id_Alo											AS [ALO],
	CVeA.Id_CVe											AS [ID_CON_VENTA],
	ITC.ITT_Descripcion									AS [TIPO_CON_VENTA],
	CVeA.CVe_Nombre										AS [CON_VENTA_NOMBRE],
	CASE 
		WHEN C.Cli_Nombre IS NULL THEN 'Todos'
		ELSE C.Cli_Nombre
	END													AS [CLIENTE],
	CASE
		WHEN GA.GRA_Nombre IS NULL THEN 'Todos'
		ELSE GA.GRA_Nombre
	END													AS [GRUPO AGENCIA],
	CASE
		WHEN M.Mer_Nombre IS NULL THEN 'Todos'
		ELSE M.Mer_Nombre
	END													AS [MERCADO],
	CASE
		WHEN P.pai_Nombre IS NULL THEN 'Todos'
		ELSE P.pai_Nombre
	END													AS [PAIS],
	CASE
		WHEN GP.GPa_Nombre IS NULL THEN 'Todos'
		ELSE GP.GPa_Nombre
	END													AS [GRUPO PAIS],
	CASE CAE.CAE_denegar
		WHEN 0 THEN 'PERMITIDO'
		WHEN 1 THEN	'DENEGADO'
	END													AS [ACCESO]
FROM 
				Tbl_ContratoVentaAloja		CVeA
	LEFT JOIN	Tbl_IdiNTTa					ITC	ON ITC.Id_TTa = CVeA.Id_TTa
	LEFT JOIN	Tbl_ControlAcceso			CA	ON CA.CAc_Tipo = 'CVeA' AND CA.CAc_Codigo = CVeA.Id_CVe
	LEFT JOIN	Tbl_ControlAccesoExtendido	CAE	ON CAE.Id_CAc = CA.Id_CAc
	LEFT JOIN	Tbl_Cliente					C	ON C.Id_Cli = CA.Id_Cli
	LEFT JOIN	Tbl_GrupoAgencia			GA	ON GA.Id_GRA = CA.Id_Gra 
	LEFT JOIN	Tbl_Mercado					M	ON M.Id_Mer = CA.Id_Mer
	LEFT JOIN	Tbl_Paises					p	ON P.id_pai	= CAE.Id_Pai
	LEFT JOIN	Tbl_GrupoPais				GP	ON GP.id_GPa = CAE.Id_GPa
WHERE 
	1 = 1
	AND CVeA.Id_Alo = @ALO
	AND CVeA.CVe_Activo = 1
	AND CVeA.CVe_FinTemporada >= GETDATE()

	--AND CVeA.Id_CVe = @CONTRATO_VENTA

ORDER BY
	CVeA.Id_CVe


--SELECT CVe_Tipo,* FROM Tbl_ContratoVentaAloja WHERE Id_CVe IN (115347,119212)

--SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME LIKE 'Id_tmp'

--SELECT * FROM tbl_ContratoAloja WHERE Id_CVe IN (115347,119212)

--SELECT * FROM Tbl_ConNTmp WHERE Id_Con IN (505014,552482)

--SELECT * FROM Tbl_Temporada




