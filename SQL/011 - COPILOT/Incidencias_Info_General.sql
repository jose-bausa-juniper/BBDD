DECLARE @CLIENTE INT = 18224;
DECLARE @USUARIO VARCHAR(50) = 'Jose Bausá';
DECLARE @INCIDENCIA INT = 1108881;

SELECT
	aj.A_nom														AS [CLIENTE],
	i.I_BacklogPriority												AS [BACKLOG PRIORITY],
    i.id_incidencia													AS [ID INCIDENCIA],
    agencias.dbo.converthtml(i.I_asumpte)							AS [TITULO],
    ti.TI_Etiqueta_Es												AS [TIPO INCIDENCIA],
    CASE i.I_estat 
        WHEN 'N' THEN 'Nueva'
        WHEN 'E' THEN 'En curso'
        WHEN 'C' THEN 'Cerrada'
        WHEN '5' THEN 'Pend Proveedor'
        WHEN '4' THEN 'Pend Juniper'
        WHEN '3' THEN 'Pend Cliente' 
        ELSE i.I_estat
    END																AS [ESTADO],
    i.I_data														AS [FECHA CREACION INCIDENCIA],
    gru.Gru_nombre													AS [EQUIPO ASIGNADO],
	ua.U_nom														AS [USUARIO ASIGNADO],
	ur.U_nom														AS [RESPONSABLE ASIGNADO],
    CASE 
		WHEN I_porContrato = 1 AND I_porMantenimiento = 0 THEN 'Por contrato'
        WHEN I_porContrato = 1 AND I_porMantenimiento = 1 THEN 'Por mantenimiento'
        WHEN i.IncPresupuestoAceptado = 1 THEN 'Por bolsa de horas' 
        ELSE 'NO' 
	END																AS [PRESUPUESTO ACEPTADO],
	i.i_fechaenviopresupuesto                                       AS [FECHA ENVIO PRESUPUESTO],
    i.I_fechaAceptacionPresupuesto                                  AS [FECHA ACEPTACION PRESUPUESTO],
    i.I_fechaInicioPrevista                                         AS [FECHA INICIO PREVISTA],
    i.I_fechaPactadaCliente                                         AS [FECHA COMPROMETIDA CLIENTE],
    i.I_urldocumentotrabajo                                         AS [DOCUMENTO UNICO]
FROM 
                agencias.dbo.incidencia i
    INNER JOIN  agencias.dbo.AGENCIA aj           ON aj.A_Codi = i.A_codi
    INNER JOIN  agencias.dbo.USUARI ua            ON ua.Id_usuari = i.Id_usuari
    INNER JOIN  agencias.dbo.USUARI ur            ON ur.Id_usuari = i.I_responsableTicket
    INNER JOIN  agencias.dbo.TIPO_INCIDENCIA ti   ON ti.TI_id = i.I_tipus AND ti.TI_Activo = 1
    LEFT  JOIN  agencias.dbo.GRUPO_USUARIOS gru   ON ua.id_gru = gru.id_gru
WHERE 1 = 1
	AND i.a_codi = @CLIENTE
	AND i.I_tipus NOT IN(32,35,37,38)
	AND i.I_estat IN ('E', 'N')
	AND ((ua.U_nom = @USUARIO) OR (ur.U_nom = @USUARIO))
    --AND i.Id_incidencia = @INCIDENCIA