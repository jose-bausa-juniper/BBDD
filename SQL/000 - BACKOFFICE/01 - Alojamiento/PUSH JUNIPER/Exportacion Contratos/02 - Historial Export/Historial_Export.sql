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

[ESEE.Eee_Tipo]
	0	OK
	1	WARNING
	2	ERR
	3	WRATE
	4	WCONTRACT
	5	WROOM
	6	WOFFER
	7	ERATE
	8	EOFFER
	9	EMAPP
*/
USE BD_Nincoming

DECLARE @IDSEX INT; SET @IDSEX = 57;
DECLARE @PROV varchar(10); SET @PROV = 'AVT';
DECLARE @SMPHOT INT; SET @SMPHOT = 337816
DECLARE @SMPREG INT; SET @SMPREG = 3;
DECLARE @VILLAS TABLE (AVT INT,NOM VARCHAR(MAX));
DECLARE @LASTEXPORT TABLE (ESE INT,AVT NVARCHAR(MAX));
DECLARE @TEST TABLE (ERRTYPE VARCHAR(MAX),ERR BIT, AVT_COD INT,AVT_NOM VARCHAR(MAX));

INSERT INTO @VILLAS 
	SELECT
		AlE_Cod,
		AlE_Nombre
	FROM
		BD_Nincoming.dbo.vwQlik_JP_Externos	V		
	WHERE 
		V.AlE_Prov = @PROV

INSERT INTO @LASTEXPORT 
	SELECT 
		MAX(ESE.Id_Ese),
		ASPE.SPE_CodHotel
	FROM 
						BD_Nincoming_HIS.dbo.Tbl_ExportacionSistemaExterno	ESE
		INNER JOIN		BD_Nincoming.dbo.Tbl_AlojaSupplierPushElemento		ASPE ON ASPE.Id_SPE = ESE.Id_SPE
	WHERE 
		1 = 1
		AND Id_Sex = @IDSEX
	GROUP BY
		ASPE.SPE_CodHotel

--INSERT INTO @TEST
SELECT 
    STRING_AGG(	CASE ESEE.Eee_Tipo	
					WHEN 0 THEN 'OK'
					WHEN 1 THEN 'WARNING'
					WHEN 2 THEN 'ERR'
					WHEN 3 THEN 'WRATE'
					WHEN 4 THEN 'WCONTRACT'
					WHEN 5 THEN 'WROOM'
					WHEN 6 THEN 'WOFFER'
					WHEN 7 THEN 'ERATE'
					WHEN 8 THEN 'EOFFER'
					WHEN 9 THEN 'EMAPP'
				END, ', ')																						AS [ESEE.Eee_Tipo],
		--ESE.Id_Ese																									AS [ESE.Id_Ese],
		--ESE.Id_Sex																									AS [ESE.Id_Sex],
		--ESE.Id_Alo																									AS [ESE.Id_Alo],
		--ESE.Id_Con																									AS [ESE.Id_Con],
		--ESE.Id_Cli																									AS [ESE.Id_Cli],
	ESE.Ese_fecha																								AS [ESE.Ese_fecha],
		--ESE.Ese_Actualizado																							AS [ESE.Ese_Actualizado],
		--ESE.Id_CCo																									AS [ESE.Id_CCo],
		--ESE.Ese_FechaIni																								AS [ESE.Ese_FechaIni],
	ESE.Ese_Error																								AS [ESE.Ese_Error],
		--ESE.Id_SPE																									AS [ESE.Id_SPE],
		--ESEE.Id_Eee																									AS [ESEE.Id_Eee],
		--ESEE.Id_Ese																									AS [ESEE.Id_Ese],
		--SPE.Id_SPE																									AS [SPE.Id_SPE],
	V.AVT																										AS [V.AVT],
	V.NOM																										AS [V.NOM],
	SPE.SPE_UltimaModificacion																					AS [SPE.SPE_UltimaModificacion],
	SPE.SPE_GeneracionTarifario																					AS [SPE.SPE_GeneracionTarifario],
		--SPE.SPE_BinTarifario																							AS [SPE.SPE_BinTarifario],
		--CAST(DECOMPRESS (SPE.SPE_BinTarifario)AS XML)																	AS [SPE.TARIFARIO],
		--NSE.id_NSE																									AS [NSE.id_NSE],
		--NSE.NSE_CodigoSE																								AS [NSE.NSE_CodigoSE],
		--NSE.NSE_Tipo																									AS [NSE.NSE_Tipo],
		--NSE.NSE_IdDreIdEse																							AS [NSE.NSE_IdDreIdEse],
		--NSE.NSE_BinXmlErrores																							AS [NSE.NSE_BinXmlErrores],
		--CAST(DECOMPRESS (NSE.NSE_BinXmlErrores)AS XML)																AS [NSE.XMLERRORES],
	CAST(DECOMPRESS (NSE.NSE_BinXmlErrores)AS XML).value('(/ErroresXML/ejecucion/errores)[1]','varchar(max)')	AS [NSE.ERRORES],
	CAST(DECOMPRESS (NSE.NSE_BinXmlErrores)AS XML).value('(/ErroresXML/ejecucion/avisos)[1]','varchar(max)')	AS [NSE.AVISOS]

FROM 
					BD_Nincoming_HIS.dbo.Tbl_ExportacionSistemaExterno			ESE	
		LEFT JOIN	BD_Nincoming_HIS.dbo.Tbl_ExportacionSistemaExternoErrores	ESEE	ON	ESEE.Id_Ese = ESE.Id_Ese
		LEFT JOIN	BD_Nincoming_HIS.dbo.Tbl_NotificacionSistemaExterno			NSE		ON	NSE.NSE_IdDreIdEse = ESE.Id_Ese
		LEFT JOIN	BD_Nincoming.dbo.Tbl_AlojaSupplierPushElemento				SPE		ON	SPE.Id_SPE = ESE.Id_SPE
		LEFT JOIN	@VILLAS														V		ON	CAST(V.AVT AS VARCHAR(MAX)) = SPE.SPE_CodHotel
WHERE
	1 = 1
	AND NSE.NSE_Tipo = 'CONTRATO'
	AND ESE.Id_Sex = @IDSEX
	AND V.AVT IN (SELECT AVT FROM @VILLAS)
		--AND ESE.Ese_fecha > GETDATE()-1
	AND ESE.Id_Ese IN (SELECT ESE FROM @LASTEXPORT)
	--AND ESEE.Eee_Tipo <> 0 -- EXPORT OK
GROUP BY
	ESE.Ese_fecha,
	ESE.Ese_Error,
	V.AVT,
	V.NOM,
	SPE.SPE_UltimaModificacion,
	SPE.SPE_GeneracionTarifario,
	SPE.SPE_BinTarifario,
	NSE.NSE_BinXmlErrores
--HAVING COUNT(ESEE.Eee_Tipo) > 1
ORDER BY
	V.AVT DESC