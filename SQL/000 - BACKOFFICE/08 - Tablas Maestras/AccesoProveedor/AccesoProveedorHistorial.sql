USE BD_Nincoming
DECLARE 
	--@DESDE DATETIME = '2025-05-05 08:00:00',
	--@HASTA DATETIME = '2025-05-05 12:50:00';
	--@DESDE DATETIME = GETDATE()-1,
	--@HASTA DATETIME = GETDATE();
	@DESDE DATETIME = '2026-05-03 11:00:00',
	@HASTA DATETIME = GETDATE();

SELECT TOP 1000
	--@DESDE,
	--@HASTA,
	CASE LAAP.Lap_Accion
		WHEN 'NEW'	THEN 'Crear'
		WHEN 'DEL'	THEN 'Borrar'
		WHEN 'ACT'	THEN 'Activar'
		WHEN 'DES'	THEN 'Desactivar'
		WHEN 'MOD'	THEN 'Modificar'
		WHEN 'CLN'	THEN 'Limpiar'
	END																					AS [Accion],
	A.Adm_Nombre																		AS [Usuario],
	LAAP.Lap_fecha																		AS [Fecha y hora],
	--LAAP.Lap_Pro																		AS [Proveedor],
	CASE
		WHEN LAAP.Lap_Pro = 'HBE' THEN 'Alojamiento'
		WHEN TPD.TPD_Nombre IS NULL THEN TP.TPr_Nombre
		ELSE TPD.TPD_Nombre
	END																					AS [Proveedor],
	CAST(LAAP.Lap_XML AS XML).value('(/historial/his/@prm)[1]','varchar(max)')			AS [Accesso Permitido],
	--Z.Id_Zon																			AS [Zona],
	CASE
		WHEN Z.Zon_Nombre_ES IS NULL THEN '--Todos--'
		ELSE Z.Zon_Nombre_ES
	END																					AS [Zona],
	--M.Id_Mer																			AS [ID Mercado],
	CASE 
		WHEN M.Mer_Nombre IS NULL THEN '--Todos--'
		ELSE M.Mer_Nombre
	END																					AS [Mercado],
	--GA.Id_GRA																			AS [ID Grupo Agencia],
	CASE 
		WHEN GA.GRA_Nombre IS NULL THEN '--Todos--'
		ELSE GA.GRA_Nombre
	END																					AS [Grupo Agencia],
	--C.Id_Cli																			AS [ID Cliente],
	CASE 
		WHEN C.Cli_Nombre IS NULL THEN '--Todos--'
		ELSE C.Cli_Nombre
	END																					AS [Cliente],
	--CAN.Id_Can																		AS [Canal],
	CASE 
		WHEN CAN.Id_Can IS NULL THEN '--Todos--'
		ELSE CAN.Id_Can
	END																					AS [Canal],
	--P.id_pai																			AS [Nacionalidad],
	CASE 
		WHEN P.id_pai IS NULL THEN '--Todos--'
		ELSE P.pai_Nombre
	END																					AS [Nacionalidad],
	EA.EAc_Valor																		AS [Etiqueta],
	CAST(LAAP.Lap_XML AS XML).value('(/historial/his/@comentarios)[1]','varchar(max)')  AS [Comentarios]
FROM 
				Tbl_LogAccionesAccesoProveedor	LAAP
	LEFT JOIN	Tbl_Administrador				A		ON A.Id_Adm = LAAP.Id_Adm
	LEFT JOIN	Tbl_TipoProductoDesglosado		TPD		ON TPD.id_TPD = LAAP.Lap_Pro
	LEFT JOIN	Tbl_TipoProducto				TP		ON TP.TPr_Tipo = LAAP.Lap_Pro
	LEFT JOIN	Tbl_Cliente						C		ON C.Id_Cli = CAST(LAAP.Lap_XML AS XML).value('(/historial/his/@cli)[1]','varchar(max)')
	LEFT JOIN	Tbl_GrupoAgencia				GA		ON GA.Id_GRA = CAST(LAAP.Lap_XML AS XML).value('(/historial/his/@gra)[1]','varchar(max)')
	LEFT JOIN	Tbl_Mercado						M		ON M.Id_Mer = CAST(LAAP.Lap_XML AS XML).value('(/historial/his/@mer)[1]','varchar(max)')
	LEFT JOIN	Tbl_CanalVenta					CAN		ON CAN.Id_Can = CAST(LAAP.Lap_XML AS XML).value('(/historial/his/@canal)[1]','varchar(max)')
	LEFT JOIN	Tbl_Paises						P		ON P.id_pai = CAST(LAAP.Lap_XML AS XML).value('(/historial/his/@pais)[1]','varchar(max)')
	LEFT JOIN	Tbl_EtiquetaAcceso				EA		ON EA.EAc_Codigo = CAST(LAAP.Lap_XML AS XML).value('(/historial/his/@etiqueta)[1]','varchar(max)')
	LEFT JOIN	Tbl_Zona						Z		ON Z.Id_Zon = CAST(LAAP.Lap_XML AS XML).value('(/historial/his/@zon)[1]','varchar(max)')
WHERE
	1 = 1
	AND LAAP.Lap_fecha BETWEEN @DESDE AND @HASTA
	AND LAAP.Lap_Pro = 'AVT'
	--AND (
	--		(CAST(LAAP.Lap_XML AS XML).value('(/historial/his/@prm)[1]','varchar(max)') = 'True' AND LAAP.Lap_Accion = 'NEW')
	--	OR	(CAST(LAAP.Lap_XML AS XML).value('(/historial/his/@prm)[1]','varchar(max)') = 'False' AND LAAP.Lap_Accion = 'DEL')
	--	)
	--AND LAAP.Lap_Accion IN ('NEW','ACT')
ORDER BY
	LAAP.Id_Lap DESC