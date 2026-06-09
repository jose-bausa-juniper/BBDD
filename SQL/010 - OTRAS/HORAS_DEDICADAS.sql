DECLARE
	@CLIENTE INT = 18224

SELECT
	I.Id_incidencia													AS [ID INCIDENCIA],
	TI.TI_Etiqueta_ES												AS [TIPO INCIDENCIA],
	dbo.converthtml(I.I_asumpte)									AS [ASUNTO],
    TIC.Tii_Nombre													AS [TIPO INCIDENCIA CLIENTE],
	dbo.converthtml(H.HOR_concepto)									AS [CONCEPTO HORA],
	H.HOR_PM														AS [HORA PM],
	CONVERT(DATE, H.HOR_fecha, 103)									AS [FECHA REPORT],
	CONVERT(DATE, H.FecCre, 103)									AS [FECHA IMPUTACION],
	U.U_nom															AS [USUARIO],
	GRU.GrU_Nombre													AS [GRUPO USUARIO],
	E.Eqp_Nombre													AS [EQUIPO USUARIO],	
	H.HOR_usuario													AS [ID USUARIO],
	H.HOR_horas														AS [CONTABILIZADAS],
	H.HOR_horas_no_cont												AS [NO CONT]

FROM
				INCIDENCIA					I
	INNER JOIN	HORAS						H	ON H.HOR_id_incidencia = I.Id_incidencia
    LEFT JOIN	Tbl_TiposIncidenciaCliente	TIC	ON TIC.Id_Tii = I.I_TipoIncidenciaCliente
    INNER JOIN	TIPO_INCIDENCIA				TI	ON TI.TI_id = I.I_tipus AND TI_Activo = 1
	INNER JOIN	USUARI						U	ON U.Id_usuari = H.HOR_usuario
    LEFT JOIN	GRUPO_USUARIOS				GRU	ON U.Id_GrU = GRU.Id_GrU
	LEFT JOIN	Tbl_Equipo					E	ON E.Id_Eqp = U.id_eqp
WHERE 
	1 = 1
	AND I.A_codi = @CLIENTE
	AND H.HOR_fecha > '2024'
	AND U.Id_usuari <> 10000