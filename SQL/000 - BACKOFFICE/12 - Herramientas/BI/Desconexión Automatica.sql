WITH PRODUCTALO AS (
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
),
REGLAS AS (
SELECT
	DISTINCT
	[Modulo]													AS [Mod],
	[Nombre Modulo]												AS [Nombre_Modulo],
	DAC.Id_Dag													AS [Id_Regla],
	DAC.Dag_Nombre												AS [Nombre_Regla],
	DAC.Dag_SmartBE												AS [SmartBE],
	CASE DAC.Dag_Transaccion 
		WHEN '1'	THEN 'Disponibilidad'
		WHEN '2'	THEN 'Reserva'
		WHEN '17'	THEN 'PoliticasCancelacion'
		ELSE CAST(DAC.Dag_Transaccion AS VARCHAR (MAX))
	END															AS [Transacción],
	DAC.Dag_Activo												AS [Regla_Activa],
	--DAC.Dag_Borrado												AS [Regla_Borrada],
	DAN.Id_Dan													AS [Id_Notificacion],
	DAN.Dan_Activo												AS [Notificación_Activa],
	DAN.Id_Men													AS [Id_Mensaje_Regla],
	DAN.Dan_MailEmisor											AS [Notificación_Emisor],
    STRING_AGG(DAND.Dad_MailDestino, ';')						AS [Notificación_Destino],
	M.Id_Men													AS [Id_Mensaje],
	M.Men_Descripcion											AS [Descripcion_Mensaje],
	M.Men_Texto_ES												AS [Mensaje Texto]
FROM
				PRODUCTALO												PA
	LEFT JOIN	Tbl_DesconexionAutomaticaConfiguracion					DAC		ON DAC.Dag_Proveedor = PA.[Modulo]
	--LEFT JOIN	Tbl_DesconexionAutomaticaError							DAE		ON DAE.Id_Dag = DAC.Id_Dag
	LEFT JOIN	Tbl_DesconexionAutomaticaNotificacion					DAN		ON DAN.Id_Dag = DAC.Id_Dag
	LEFT JOIN	Tbl_Mensaje												M		ON M.Id_Men = DAN.Id_Men
	LEFT JOIN	Tbl_DesconexionAutomaticaNotificacionDestinatario		DAND	ON DAND.id_Dan = DAN.id_Dan
WHERE
	1 = 1
	AND DAC.Dag_Borrado = 0
	--AND DAC.Id_Dag IS NULL
	--AND [Modulo] IS NOT NULL
	--AND ((DAC.Dag_Borrado = 0 AND DAC.Dag_Activo = 1) OR (DAC.Dag_Borrado IS NULL AND DAC.Dag_Activo IS NULL))
	--AND DAN.Dan_Activo = 1
	--AND DAC.Dag_SmartBE = 1
GROUP BY
    [Modulo],
    [Nombre Modulo],
    DAC.Id_Dag,
    DAC.Dag_Nombre,
    DAC.Dag_SmartBE,
    DAC.Dag_Transaccion,
    DAC.Dag_Activo,
	DAC.Dag_Borrado,
	DAN.Id_Dan,
    DAN.Dan_Activo,
    DAN.Id_Men,
    DAN.Dan_MailEmisor,
    M.Id_Men,
	M.Men_Descripcion,
    M.Men_Texto_ES
)

SELECT * FROM REGLAS
WHERE 1 = 1--Regla_Activa = 1
AND Nombre_Modulo LIKE '%derb%'
ORDER BY
Nombre_Modulo