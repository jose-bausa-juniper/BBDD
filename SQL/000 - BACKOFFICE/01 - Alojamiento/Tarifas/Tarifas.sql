USE BD_Nincoming;

SELECT
	--DISTINCT (TAR.Tar_BeneficioRecomendado)			AS [% Recomendado],
	TAR.Tar_BeneficioRecomendado					AS [% Recomendado],
	TAR.Id_Alo										AS [Alojamiento],
	TAR.id_con										AS [Contrato],
	--MAX(TAF.taF_FechaIni)							AS [Ultimo día del periodo],
	CCA.Id_CCo										AS [ID Contrato Compra],
	CCA.CCo_Nombre									AS [Contrato Compra],
	TAR.*,
	TAF.*,
	ATP.*
FROM 
				Tbl_Tarifa				TAR
	INNER JOIN	Tbl_tarifaFecha			TAF ON TAF.id_Tar = TAR.Id_Tar
	INNER JOIN	Tbl_AlojaTarifaPrecio	ATP	ON ATP.Id_Tar = TAR.Id_Tar
	INNER JOIN	Tbl_ContratoAloja		CA	ON CA.Id_Con = TAR.Id_Con
	INNER JOIN	Tbl_ContratoCompraAloja	CCA	ON CCA.Id_CCo = CA.Id_CCo
WHERE
	1 = 1
	AND cca.CCo_PreciosRecomendados = 1
	AND TAF.Taf_FechaFin >= CAST(GETDATE() AS DATE) 
	AND TAR.Id_Alo = 3863
ORDER BY ATP.Id_THa
GROUP BY 
	TAR.Id_Alo
	,TAR.id_con
	,CCA.Id_CCo
	,CCA.CCo_Nombre
	,TAR.Tar_BeneficioRecomendado