USE agencias;

DECLARE
@idcliente INT = 18224

SELECT
    i.id_incidencia																					AS [ID],
    dbo.converthtml(i.I_asumpte)																	AS [Titulo],
--    i.I_tipus                                                                                       AS [Id_Tipo],
    ti.TI_Etiqueta_Es																				AS [Tipo],
    CASE i.I_estat
        WHEN 'N' THEN 'Pendiente'
        WHEN 'E' THEN 'En curso'
        WHEN 'C' THEN 'Cerrada'
        WHEN '5' THEN 'Pend Proveedor'
        WHEN '4' THEN 'Pend Juniper'
        WHEN '3' THEN 'Pend Cliente'
        ELSE i.I_estat
    END																								AS [Estado],
    i.I_data																						AS [FechaCreacion],
    gur.Gru_nombre																					AS [Grupo Responsable],
    er.Eqp_Nombre																					AS [Equipo Responsable],
	ur.U_nom																						AS [Usuario Responsable],
    gua.Gru_nombre																					AS [Grupo Asignado],
    ea.Eqp_Nombre																					AS [Equipo Asignado],
	ua.U_nom																						AS [Usuario Asignado],

    CASE 
		WHEN I_porContrato = 1 AND I_porMantenimiento = 0 THEN 'Por contrato'
        WHEN I_porContrato = 1 AND I_porMantenimiento = 1 THEN 'Por mantenimiento'
        WHEN i.IncPresupuestoAceptado = 1 THEN 'Por bolsa de horas' 
        ELSE 'NO' 
	END																								AS [PresupuestoAceptado]

FROM				dbo.incidencia				i
    INNER JOIN		TIPO_INCIDENCIA				ti		ON TI.TI_id = i.I_tipus AND TI_Activo = 1
    INNER JOIN		USUARI						ua		ON ua.Id_usuari = i.Id_usuari
    LEFT JOIN		GRUPO_USUARIOS				gua		ON gua.Id_GrU = ua.Id_GrU
    LEFT JOIN		Tbl_Equipo				    ea		ON ea.Id_Eqp = ua.id_eqp
    INNER JOIN		USUARI						ur		ON ur.Id_usuari = i.I_responsableTicket
    LEFT JOIN		GRUPO_USUARIOS				gur		ON gur.id_gru = ur.id_gru
    LEFT JOIN		Tbl_Equipo				    er		ON er.Id_Eqp = ur.id_eqp


WHERE 
    1 = 1
    AND i.a_codi = @idcliente
	--AND i.I_tipus NOT IN(16,24,27,29,32,35,37)    
	AND i.I_tipus = 10
    AND i.I_estat <> 'C'
	AND er.Eqp_Nombre = 'PM W2M'
	AND (er.Eqp_Nombre <> 'PM W2M' OR ur.U_nom IN ('Eduardo Feijóo Pons','Santiago Gomez'))
	--AND ea.Eqp_Nombre = 'PM W2M'
	--AND (ea.Eqp_Nombre <> 'PM W2M' OR ua.U_nom IN ('Eduardo Feijóo Pons','Santiago Gomez'))
	--AND ea.Eqp_Nombre <> 'PM W2M'
    --AND ur.U_nom IN ('Eduardo Feijóo Pons','Santiago Gomez')
    --AND ua.U_nom NOT IN ('Eduardo Feijóo Pons','Santiago Gomez')
GROUP BY 
	i.id_incidencia,
	i.I_asumpte,
	ti.Ti_idGrupo,
	ti.TI_Etiqueta_Es,
	i.I_tipus,
	i.I_estat,
	i.I_data,
    ea.Eqp_Nombre,
	gua.Gru_nombre,
	ua.U_nom,
    er.Eqp_Nombre,
	gur.Gru_nombre,
    ur.U_nom,
    i.I_porContrato,
    i.I_porMantenimiento,
    i.IncPresupuestoAceptado
ORDER BY 
   	ur.U_nom ASC,
   	er.Eqp_Nombre ASC,
   	ua.U_nom ASC



