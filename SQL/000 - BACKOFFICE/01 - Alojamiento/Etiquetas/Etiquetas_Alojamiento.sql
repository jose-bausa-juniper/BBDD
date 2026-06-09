USE BD_Nincoming

DECLARE @ETIQUETAS TABLE (Id_Etiqueta INT, Orden SMALLINT, Etiqueta NVARCHAR(510));
DECLARE @ETIQUETA_HOTEL_JP TABLE (Id_Etiqueta_JP INT, Orden_JP SMALLINT, Etiqueta_JP NVARCHAR(510), JP_JP CHAR(8));
DECLARE @ETIQUETA_HOTEL_HBE TABLE (Id_Etiqueta_HBE INT, Orden_HBE SMALLINT, Etiqueta_HBE NVARCHAR(510),HBE_HBE INT, JP_HBE CHAR(8));
DECLARE @ETIQUETA_HOTEL TABLE (Origen_Etiqueta NVARCHAR(510), Id_Etiqueta INT, Orden SMALLINT, Etiqueta NVARCHAR(510),HBE INT, JP CHAR(8));

INSERT INTO @ETIQUETAS
SELECT 
	EAU.id_EAU		AS [Id_Etiqueta], 
	EAU.EAU_Orden	AS [Orden],
	INE.IEI_Desc	AS [Etiqueta]
FROM 
				Tbl_EtiquetaAlojaUnicoCliente	EAU		
	LEFT JOIN	Tbl_IdiNEtiqueta				INE		ON (EAU.id_EAU = INE.id_EAU AND INE.id_Idi = 'es')
ORDER BY
	Orden

/*ETIQUETAS POR HOTEL JP*/
INSERT INTO @ETIQUETA_HOTEL_JP
SELECT 
	EAU.id_EAU		AS [Id_Etiqueta],
	EAU.EAU_Orden	AS [Orden],
	INE.IEI_Desc	AS [Etiqueta],
	AUC.AUC_JPCode	AS [JP]
FROM 
				Tbl_AlojamientoUnicoCliente		AUC
	LEFT JOIN	Tbl_AucNEau						ANE		ON ANE.id_AUC = AUC.id_AUC
	LEFT JOIN	Tbl_EtiquetaAlojaUnicoCliente	EAU		ON EAU.id_EAU = ANE.id_EAU
	LEFT JOIN	Tbl_IdiNEtiqueta				INE		ON (EAU.id_EAU = INE.id_EAU AND INE.id_Idi = 'es')
WHERE 
	1 = 1
GROUP BY 
	EAU.id_EAU,
	EAU.EAU_Orden,
	INE.IEI_Desc,
	AUC.AUC_JPCode

/*ETIQUETAS POR HOTEL HBE*/
INSERT INTO @ETIQUETA_HOTEL_HBE
SELECT 
	EAU.id_EAU		AS [Id_Etiqueta], 
	EAU.EAU_Orden	AS [Orden],
	INE.IEI_Desc	AS [Etiqueta],
	A.Id_Alo		AS [HBE],
	AE.ALU_JPCode	AS [JP]
FROM 
				Tbl_Alojamiento					A
	LEFT JOIN	Tbl_EtiquetaAlojaUnicoCliente	EAU		ON EAU.id_EAU = A.id_EAU
	LEFT JOIN	Tbl_IdiNEtiqueta				INE		ON (EAU.id_EAU = INE.id_EAU AND INE.id_Idi = 'es')
	LEFT JOIN	vwQlik_JP_Externos				AE		ON (AE.AlE_Cod = A.Id_Alo AND AE.AlE_Prov = 'J107')
WHERE 
	1 = 1
	AND A.Alo_borrado = 0
GROUP BY 
	EAU.id_EAU,
	EAU.EAU_Orden,
	INE.IEI_Desc,
	A.Id_Alo,
	AE.ALU_JPCode

/*ETIQUETAS POR HOTEL GLOBAL*/
INSERT INTO @ETIQUETA_HOTEL
SELECT 
	CASE
	WHEN EHU.Id_Etiqueta_JP IS NULL		THEN 'HBE'
	WHEN EHU.Id_Etiqueta_JP IS NOT NULL	THEN 'JP'
	ELSE 'SIN ETIQUETA'
	END															AS [ORIGEN ETIQUETA],
	CASE
	WHEN EHU.Id_Etiqueta_JP IS NULL THEN EHP.Id_Etiqueta_HBE
	ELSE EHU.Id_Etiqueta_JP
	END															AS [ID ETIQUETA],
	CASE
	WHEN EHU.Orden_JP IS NULL THEN EHP.Orden_HBE
	ELSE EHU.Orden_JP
	END															AS [ORDEN],
	CASE
	WHEN EHU.Etiqueta_JP IS NULL THEN EHP.Etiqueta_HBE
	ELSE EHU.Etiqueta_JP
	END															AS [ETIQUETA],
	EHP.HBE_HBE												AS [HBE],
	EHU.JP_JP												AS [JP]
FROM
				@ETIQUETA_HOTEL_JP	EHU
	LEFT JOIN	@ETIQUETA_HOTEL_HBE	EHP	ON EHP.JP_HBE = EHU.JP_JP
WHERE
	1 = 1
	AND (EHU.Id_Etiqueta_JP IS NOT NULL OR EHP.Id_Etiqueta_HBE IS NOT NULL)  /*13124 ALGUNA ETIQUETA*/
	--AND (EHU.Id_Etiqueta_JP IS NULL AND EHP.Id_Etiqueta_HBE IS NULL)  /*147537 SIN ETIQUETAS*/
	--AND (EHU.Id_Etiqueta_JP <> EHP.Id_Etiqueta_HBE) /*ETIQUETA DISCREPANTE ENTRE HOTEL JP Y HBE. PREVALECE HOTEL JP*/
ORDER BY
	[ORDEN]

/*
SELECT
	Id_Etiqueta,
	Etiqueta,
	Orden,
	COUNT(*) AS Recuento_Hoteles
FROM
	@ETIQUETA_HOTEL
GROUP BY
	Id_Etiqueta,
	Etiqueta,
	Orden
ORDER BY
	Orden

SELECT
	*
FROM
	@ETIQUETA_HOTEL
ORDER BY
	Orden
*/

SELECT * FROM @ETIQUETAS ORDER BY Orden

SELECT
	Id_Etiqueta_JP,
	Etiqueta_JP,
	Orden_JP,
	COUNT(*) AS Recuento_Hoteles_JP
FROM
	@ETIQUETA_HOTEL_JP
GROUP BY
	Id_Etiqueta_JP,
	Etiqueta_JP,
	Orden_JP
ORDER BY
	Orden_JP

--SELECT * FROM @ETIQUETA_HOTEL_JP WHERE Id_Etiqueta_JP IS NOT NULL ORDER BY Orden_JP



SELECT
	Id_Etiqueta_HBE,
	Etiqueta_HBE,
	Orden_HBE,
	COUNT(*) AS Recuento_Hoteles_HBE
FROM
	@ETIQUETA_HOTEL_HBE
GROUP BY
	Id_Etiqueta_HBE,
	Etiqueta_HBE,
	Orden_HBE
ORDER BY
	Orden_HBE