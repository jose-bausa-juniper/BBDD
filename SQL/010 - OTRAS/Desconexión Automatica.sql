
DECLARE @PRODUCTALO TABLE (MODULE VARCHAR(4), NOMBRE VARCHAR (MAX));

INSERT INTO @PRODUCTALO
	SELECT
		CASE
			WHEN tpd.id_TPD IS NULL THEN tp.TPr_Tipo
			ELSE tpd.id_TPD
		END 														AS [Modulo],
		CASE
			WHEN tpd.TPD_Nombre IS NULL THEN tp.TPr_Nombre
			ELSE tpd.TPD_Nombre
		END 														AS [Nombre Modulo]
	FROM 
		Tbl_TipoProducto tp
		FULL JOIN Tbl_TipoProductoDesglosado	tpd			ON	tp.TPr_Tipo=tpd.TPr_Tipo
	WHERE 
		1 = 1
		AND (tp.TPr_Visible = 1  OR tp.TPr_Visible IS NULL)
		AND (tpd.TPd_Visible = 1 OR tpd.TPd_Visible IS NULL)
		AND (tp.TPr_Tipo NOT IN ('A','AGN','ASu','J','JHF','JPD','M','P','RGN','SGN','SGO','TGN'))
		AND tp.TPr_ModuleType = 'Alojamiento'

SELECT
	MODULE,
	NOMBRE,
	DAC.Id_Dag		AS [ID_Regla_Desconexión],
	DAC.Dag_Nombre	AS [Nombre_Regla],
	CASE DAC.Dag_Transaccion 
		WHEN '1' THEN 'AVAIL'
		ELSE CAST(DAC.Dag_Transaccion AS VARCHAR (MAX))
	END AS [Transaccion]


FROM
				@PRODUCTALO								PA
	LEFT JOIN	Tbl_DesconexionAutomaticaConfiguracion	DAC	ON DAC.Dag_Proveedor = PA.MODULE
	LEFT JOIN	Tbl_DesconexionAutomaticaError			DAE	ON DAE.Id_Dag = DAC.Id_Dag AND DAE.Dae_TipoError = 429
WHERE
	1 = 1
	AND (DAC.Id_Dag IS NULL OR (DAE.Id_Dag IS NULL AND DAC.Dag_Transaccion = 1))
	AND ((DAC.Dag_Borrado = 0 AND DAC.Dag_Activo = 1) OR (DAC.Dag_Borrado IS NULL AND DAC.Dag_Activo IS NULL))
ORDER BY
	DAC.Id_DAG,
	MODULE