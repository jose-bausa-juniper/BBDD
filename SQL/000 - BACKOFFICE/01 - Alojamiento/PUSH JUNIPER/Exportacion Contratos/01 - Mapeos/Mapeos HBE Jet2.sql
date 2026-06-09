USE BD_Nincoming

DECLARE @SE INT; SET @SE = 57;
DECLARE @ALO_W2M INT; SET @ALO_W2M = 239;
DECLARE @ALO_JET2 INT; SET @ALO_JET2 = 1866;

SELECT 
-- CONFIG
SE.Id_SEx																					AS	[ID Sistema Externo],
SE.SEx_Nombre																				AS	[Sistema Externo],

-- PROVEEDOR HBE
ANASE.id_Alo,
INA.IAl_Nombre,
CVA.Id_CVe,
CVA.CVe_Nombre,
ANT.Id_THa,
INANT.IAN_Nombre,

-- CLIENTE JET2
	--ASE.Id_ASE,
ASE.ASE_Codigo																				AS	[ID Alojamiento Cliente],
ASE.ASE_Nombre																				AS	[Nombre Alojamiento Cliente],
	--CSE.Id_CoS,
CSE.CoS_Codigo																				AS	[ID Contrato Cliente],
CSE.CoS_Nombre																				AS	[Nombre Contrato Cliente],
	--CBSE.Id_Cbs,
RIGHT(CBSE.Cbs_Codigo, LEN(CBSE.Cbs_Codigo)-CHARINDEX('|',CBSE.Cbs_Codigo))					AS	[ID Habitación Cliente],
CBSE.Cbs_Nombre																				AS	[Nombre Habitación Cliente],
CBSE.Cbs_Codigo
FROM 
				Tbl_SistemaExterno				SE
	INNER JOIN	Tbl_AlojamientoSistemaExterno	ASE		ON	ASE.Id_SEx = SE.Id_SEx	
	INNER JOIN	Tbl_AloNASE						ANASE	ON	ANASE.Id_ASE = ASE.Id_ASE
	INNER JOIN	Tbl_IDiNAlo						INA		ON	INA.Id_Alo = ANASE.id_Alo AND INA.Id_Idi = 'ES'
	INNER JOIN	Tbl_ContratoSistemaExterno		CSE		ON	CSE.Id_SEx = SE.Id_SEx
	INNER JOIN	Tbl_TCVNCoS						TCVNCOS	ON	TCVNCOS.Id_CoS = CSE.Id_CoS
	INNER JOIN	Tbl_TarifarioContratoVentaAloja	TCVA	ON	TCVA.Id_TCV = TCVNCOS.id_TCV
	INNER JOIN	Tbl_ContratoVentaAloja			CVA		ON	CVA.Id_CVe = TCVA.Id_CVe AND CVA.Id_Alo = ANASE.id_Alo
	INNER JOIN	Tbl_CombinacionSistemaExterno	CBSE	ON	CBSE.Id_SEx	= SE.Id_SEx
	INNER JOIN	Tbl_AntNCbs						ANCBS	ON	ANCBS.Id_Cbs = CBSE.Id_Cbs
	INNER JOIN	Tbl_AloNTHa						ANT		ON	ANT.id_Ant = ANCBS.id_Ant AND ANT.ANT_Eliminada = 0 AND ANT.Ant_Activa = 1
	INNER JOIN	Tbl_IDiNANT						INANT	ON	INANT.Id_Ant = ANT.id_Ant AND INANT.Id_Idi = 'ES'

WHERE 
	1 = 1
-- GLOBAL
	AND SE.Id_SEx = @SE
	AND LEFT(CBSE.Cbs_Codigo,LEN(CBSE.Cbs_Codigo) - CHARINDEX('|',REVERSE(CBSE.Cbs_Codigo),1)) = ASE.ASE_Codigo
	AND CVA.CVe_Activo = 1


-- PROVEEDOR HBE
	--AND ANASE.id_Alo = @ALO_W2M

-- CLIENTE JET2
	--AND ASE.ASE_Codigo = @ALO_JET2

