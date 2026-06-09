USE BD_Nincoming
SELECT
	CASE
		WHEN tpd.id_TPD IS NULL THEN tp.TPr_Tipo
		ELSE tpd.id_TPD
	END 														AS [Modulo],
	CASE
		WHEN tpd.TPD_Nombre IS NULL THEN tp.TPr_Nombre
		ELSE tpd.TPD_Nombre
	END 														AS [Nombre Modulo],
	tp.TPr_Tipo 												AS [Tipo Producto],
	tpd.id_TPD 													AS [Tipo Producto Desglosado],
	tp.TPr_ModuleType 											AS [Tipo Modulo],
	tpd.TPD_ModuleType 											AS [Tipo Modulo Desglosado],
	CASE
		WHEN tpd.TPD_Nombre IS NULL THEN tp.Feccre
		ELSE tpd.Feccre
	END 														AS [Feccre]

FROM 
	Tbl_TipoProducto tp
	FULL JOIN Tbl_TipoProductoDesglosado	tpd			ON	tp.TPr_Tipo=tpd.TPr_Tipo
WHERE 
	1 = 1
	AND (tp.TPr_Visible = 1  OR tp.TPr_Visible IS NULL)
	AND (tpd.TPd_Visible = 1 OR tpd.TPd_Visible IS NULL)
	AND (tp.TPr_Tipo NOT IN ('A','AGN','ASu','J','JHF','JPD','M','P','RGN','SGN','SGO','TGN'))
