SELECT
	*
FROM
				Tbl_TipoProducto															TP 
	INNER JOIN	Tbl_ParametroIntegracionCredencial											PIC		ON	PIC.CRE_Prov = TP.TPr_Tipo
	INNER JOIN	(SELECT DISTINCT (SPE_CodCliente) FROM Tbl_AlojaSupplierPushElemento)	AS	ASPE	ON	ASPE.SPE_CodCliente = PIC. CRE_ClientId
	--INNER JOIN	Tbl_AlojaSupplierPushConfig													ASPC	ON	ASPC.SPE_CodCliente = PIC. CRE_ClientId
WHERE
	1 = 1
	AND TP.TPr_Tipo = 'AVT'


SELECT TOP 10 * FROM Tbl_AlojaSupplierPushElemento WHERE ID_SUP = 2
SELECT * FROM Tbl_AlojaSupplierPushConfig WHERE ID_SUP = 2