--SELECT * FROM Tbl_TipoContrato
--SELECT * FROM Tbl_TipoContratoOpcion
--SELECT * FROM Tbl_ConNTCO WHERE Id_TCO = 5
--SELECT * FROM Tbl_ContratoAloja WHERE Id_Con IN (SELECT Id_Con FROM Tbl_ConNTCO WHERE Id_TCO = 5)
--SELECT * FROM Tbl_ContratoCompraAloja WHERE Id_CCo IN (SELECT Id_CCo FROM Tbl_ContratoAloja WHERE Id_Con IN (SELECT Id_Con FROM Tbl_ConNTCO WHERE Id_TCO = 5))
USE BD_Nincoming;

SELECT 
	CCA.id_alo								AS	[ID Alojamiento],
	cca.id_cco								AS	[ID Contrato Compra],
	cco_nombre								AS	[Nombre Contrato Compra]
FROM 
				Tbl_ContratoCompraAloja		CCA
	INNER JOIN	Tbl_ContratoAloja			CA		ON	CA.Id_CCo = CCA.Id_CCo
	INNER JOIN	Tbl_ConNTCO					CNTCO	ON	CNTCO.Id_Con = CA.Id_Con
	INNER JOIN	Tbl_TipoContratoOpcion		TCO		ON	TCO.Id_TCO = CNTCO.Id_TCO
	INNER JOIN	Tbl_TipoContrato			TC		ON	TC.Id_TiC = TC.Id_TiC
WHERE
	1=1
	AND TC.TiC_Nombre = 'Best Deal'
	AND TCO.TCO_Nombre = 'Especial Azul Marino'
	AND CCA.cco_Activo = 1
	--AND CCA.Id_Alo = 32001
GROUP BY
	TC.TiC_Nombre,
	TC.TiC_AplicarCompra,
	TC.TiC_AplicarExtranet,
	TC.TiC_AplicaWeb,
	TCO.TCO_Nombre,
	CCA.id_alo,
	cca.id_cco,
	cco_nombre