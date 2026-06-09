/*
[SPE.SPE_CodHotel]
	AVT|390105 - Villa 10 Marias
	AVT|377336 - Villa Gill
	AVT|340999 - Villa Noixa
	AVT|337637 - Villas Playas de Fornells 01
	AVT|337614 - Villas Begonias (Azalea)
	AVT|495632 - Apartamento Alta Galdana Playa 1
	AVT|337653 - Villas Cala Galdana 1 - Alicia
	AVT|445238 - Villa Menorcahome 14
	AVT|398422 - Villa Sa Torreta
	AVT|413349 - Villa La Martina
	AVT|397998 - Villa Romani
	AVT|410408 - Villa Calan Brut 51
	AVT|393686 - Villa Zodiaco Aries
	AVT|335471 - Villa Aldebaran
	AVT|339473 - Villa Bea
	AVT|337816 - Villas Galdana Palms 04
	AVT|336259 - Villas Amarillas 01
*/

USE BD_Nincoming	

DECLARE @IDSEX INT; SET @IDSEX = 57;
DECLARE @REG NVARCHAR(MAX); SET @REG = '3';
DECLARE @AVTCODHOTROOM NVARCHAR(MAX); SET @AVTCODHOTROOM = 'GEN';
DECLARE @PROV varchar(10); SET @PROV = 'AVT';
DECLARE @AVTCODHOT INT; SET @AVTCODHOT = 411936 ;
DECLARE @VILLAS TABLE (AlE_Cod INT,AlE_Nombre VARCHAR(MAX), Ocupacion VARCHAR(MAX));
DECLARE @ALOJET2 NVARCHAR(MAX); SET @ALOJET2 = '5117' ;
DECLARE @HABJET2 NVARCHAR(MAX); SET @HABJET2 = '1189' ;
DECLARE @CONTJET2 NVARCHAR(MAX); SET @CONTJET2 = '101926' ;

INSERT INTO @VILLAS 
	SELECT 
		V.AlE_Cod,
		V.AlE_Nombre,
		CONCAT (ASPP.SPP_MinAdultos,' to ',ASPP.SPP_MaxAdultos,' Ad MAX. ',ASPP.SPP_MaxAdultos) AS [Ocupacion]
	FROM 
					vwQlik_JP_Externos				V
		INNER JOIN	Tbl_AlojaSupplierPushElemento	ASPE	ON ASPE.SPE_CodHotel = V.AlE_Cod
		INNER JOIN	Tbl_AlojaSupplierPushPrecio		ASPP	ON ASPP.Id_SPE = ASPE.Id_SPE
	WHERE 
		AlE_Prov = @PROV
	GROUP BY
		V.AlE_Cod,
		V.AlE_Nombre,
		ASPP.SPP_MinAdultos,
		ASPP.SPP_MaxAdultos

SELECT 
----- PROVEEDOR -----
--CombSE.Cbs_Codigo,
ASPMH.SPM_CodProv																			AS	[PROVEEDOR],
ASPMH.SPM_CodHotel																			AS	[ID_ALO_AVT],
V.AlE_Nombre																				AS	[NOM_ALO_AVT],
ASPMC.SPM_RatePlanCode																		AS	[ID_CON_AVT],
ASPMC.SPM_RatePlanCode																		AS	[NOM_CON_AVT],
ASPMHab.SPM_CodHabitacion																	AS	[ID_HAB_AVT],
ASPMHab.SPM_CodHabitacion																	AS	[NOM_HAB_AVT],
V.Ocupacion																					AS	[OCU_AVT],
--RNR.id_Reg																					AS	[ID_REG_W2M],
--INR.IRe_Nombre																				AS	[NOM_REG_W2M],
----- CLIENTE -----
SE.SEx_Nombre																				AS	[SISTEMA_EXTERNO],
ASE.ASE_Codigo																				AS	[ID_ALO_JET2],
ASE.ASE_Nombre																				AS	[NOM_ALO_JET2],
CSE.CoS_Codigo																				AS	[ID_CON_JET2],
CSE.CoS_Nombre																				AS	[NOM_CON_JET2],
--CombSE.Cbs_Codigo																			AS	[ALO|Tha],
--LEFT(CombSE.Cbs_Codigo, LEN(CombSE.Cbs_Codigo)-CHARINDEX('|',REVERSE(CombSE.Cbs_Codigo)))	AS	[ID Hotel Cliente],
RIGHT(CombSE.Cbs_Codigo, LEN(CombSE.Cbs_Codigo)-CHARINDEX('|',CombSE.Cbs_Codigo))			AS	[ID_HAB_JET2],
CombSE.Cbs_Nombre																			AS	[NOM_HAB_JET2]
--RASE.RAS_Codigo																				AS	[ID_REG_JET2],
--RASE.RAS_Nombre																				AS	[NOM_REG_JET2]

FROM 
									Tbl_SistemaExterno							SE
	LEFT JOIN						Tbl_AlojamientoSistemaExterno				ASE			ON	ASE.Id_SEx = @IDSEX
	LEFT JOIN						Tbl_AlojaSupplierPushMapeoHotel				ASPMH		ON	ASPMH.Id_Ase = ASE.Id_ASE
	LEFT JOIN						Tbl_ContratoSistemaExterno					CSE			ON	CSE.Id_SEx = @IDSEX 
	LEFT JOIN						Tbl_AlojaSupplierPushMapeoContrato			ASPMC		ON	ASPMC.Id_Cos = CSE.Id_CoS
	LEFT JOIN						Tbl_CombinacionSistemaExterno				CombSE		ON	CombSE.Id_SEx = @IDSEX 
	LEFT JOIN						Tbl_AlojaSupplierPushMapeoHabitacion		ASPMHab		ON	ASPMHab.Id_Cbs = CombSE.Id_Cbs
	LEFT JOIN						Tbl_RegimenAloSistemaExterno				RASE		ON	RASE.Id_SEx = @IDSEX 
	LEFT JOIN						Tbl_RegNRas									RNR			ON	RNR.Id_RAS = RASE.Id_RAS
	LEFT JOIN						Tbl_IdiNReg									INR			ON	INR.Id_Reg = RNR.Id_Reg AND INR.id_Idi = 'ES'
	INNER JOIN						@VILLAS										V			ON	V.AlE_Cod = ASPMH.SPM_CodHotel
WHERE 
	1 = 1
	--AND ASPMH.SPM_CodHotel IN (340999,336259)
	--AND ASE.ASE_Nombre LIKE '%amarillas%'
	--AND CombSE.Cbs_Codigo NOT IN ('9853|19669')
	--AND ASPMHab.SPM_CodHabitacion IS NULL

	------------------- VISTA GLOBAL -------------------
	AND SE.Id_SEx = @IDSEX
	AND RASE.RAS_Codigo = @REG
	AND ASE.ASE_Codigo = LEFT(CombSE.Cbs_Codigo, LEN(CombSE.Cbs_Codigo)-CHARINDEX('|',REVERSE(CombSE.Cbs_Codigo))) 
	AND ASPMC.SPM_RatePlanCode = ASPMH.SPM_CodHotel

	------------------- VISTA AVT -------------------
	--AND ASPMH.SPM_CodHotel =  @AVTCODHOT
	--AND ASPMC.SPM_RatePlanCode = ASPMH.SPM_CodHotel
	--AND ASPMHab.SPM_CodHabitacion  IS NOT NULL
	--AND LEFT(CombSE.Cbs_Codigo, LEN(CombSE.Cbs_Codigo)-CHARINDEX('|',REVERSE(CombSE.Cbs_Codigo))) = ASE.ASE_Codigo

	-------------------
	--AND ASE.ASE_Codigo = @ALOJET2
	--AND CSE.CoS_Codigo = @CONTJET2
	--AND CombSE.Cbs_Codigo = CONCAT(@ALOJET2,'|',@HABJET2)


--------------------------------- MAPEOS -----------------------------------------------------------------
------ Mapeo Hotel
	--SELECT 
	--	* 
	--FROM 
	--				Tbl_AlojaSupplierPushMapeoHotel	ASPMH
	--	LEFT JOIN	Tbl_AlojamientoSistemaExterno	ASE ON ASE.Id_ASE = ASPMH.Id_Ase
	--WHERE 
	--	1 = 1
	--	AND ASE.Id_SEx = 57
	--	AND ASPMH.SPM_CodProv = 'AVT'
	--	AND ASPMH.SPM_CodHotel = @AVTCODHOT
	--	--AND ASE.ASE_Codigo = @ALOJET2

------ Mapeo Contrato
	--SELECT
	--	*
	--FROM	
	--				Tbl_AlojaSupplierPushMapeoContrato	ASPMC
	--	LEFT JOIN	Tbl_ContratoSistemaExterno			CSE		ON CSE.Id_CoS = ASPMC.Id_Cos
	--WHERE 
	--	1 = 1
	--	AND CSE.Id_SEx = 57
	--	AND ASPMC.SPM_CodProv = 'AVT'
	--	AND ASPMC.SPM_CodHotel = @AVTCODHOT
	--	--AND CSE.CoS_Codigo = @CONTJET2

---- Mapeo Habitación
	--SELECT
	--	*
	--FROM	
	--				Tbl_AlojaSupplierPushMapeoHabitacion	ASPMH
	--	LEFT JOIN	Tbl_CombinacionSistemaExterno			CSE		ON CSE.Id_Cbs = ASPMH.Id_Cbs
	--WHERE 
	--	1 = 1
	--	AND CSE.Id_SEx = 57
	--	AND ASPMH.SPM_CodProv = 'AVT'
	--	AND ASPMH.SPM_CodHotel = 495632--@AVTCODHOT
		--AND LEFT(CSE.Cbs_Codigo, LEN(CSE.Cbs_Codigo)-CHARINDEX('|',REVERSE(CSE.Cbs_Codigo))) = @ALOJET2
		--AND RIGHT(CSE.Cbs_Codigo, LEN(CSE.Cbs_Codigo)-CHARINDEX('|',CSE.Cbs_Codigo)) = @HABJET2


--------------------------------- FORZAR MAPEOS -----------------------------------------------------------------
------ Forzar Mapeo Contrato
	--INSERT INTO [dbo].[Tbl_AlojaSupplierPushMapeoContrato] 
	--			([SPM_CodProv],[SPM_CodHotel],[SPM_RatePlanCode],[Id_Cos])
	--     VALUES ('AVT',337816,337816,14950)

------ Forzar Mapeo Habitacion
	--INSERT INTO [dbo].[Tbl_AlojaSupplierPushMapeoHabitacion]
	--			([SPM_CodProv],[SPM_CodHotel],[SPM_CodHabitacion],[Id_Cbs])
	--     VALUES	('AVT',495632,'GEN',47732)
