DECLARE @CLIENTE VARCHAR(50) = 'W2M (World 2 Meet)';
DECLARE @IDCLIENTE INT = 18224;
DECLARE @USUARIO VARCHAR(50) = 'Jose Bausá';
DECLARE @GRUPO VARCHAR(50) = 'PM Project Management';
DECLARE @EQUIPO VARCHAR(50) = 'PM W2M';
DECLARE @INCIDENCIAS TABLE (ID INT); INSERT INTO @INCIDENCIAS (ID) VALUES 
(1105281),
(1106112),
(1106803),
(1110191),
(1110596),
(1110845),
(1111366),
(1111727),
(1111730);

WITH INCIDENCIAS AS (
    SELECT
	    aj.A_nom														            AS [CLIENTE],
	    i.I_BacklogPriority												            AS [BACKLOG PRIORITY],
        i.id_incidencia													            AS [ID INCIDENCIA],
        TRY_CAST('<x>' + i.I_asumpte + '</x>' AS XML).value('.', 'NVARCHAR(MAX)')   AS [TITULO],
        ti.TI_Etiqueta_Es												            AS [TIPO INCIDENCIA],
        CASE i.I_estat 
            WHEN 'N' THEN 'Nueva'
            WHEN 'E' THEN 'En curso'
            WHEN 'C' THEN 'Cerrada'
            WHEN '5' THEN 'Pend Proveedor'
            WHEN '4' THEN 'Pend Juniper'
            WHEN '3' THEN 'Pend Cliente' 
            ELSE i.I_estat
        END																            AS [ESTADO],
        i.i_bold                                                                    AS [PDTE RS],
        agencias.dbo.converthtml(i.I_nomClient)                                     AS [CREADOR INCIDENCIA],
        CAST(i.I_data AS DATE)											            AS [FECHA CREACION INCIDENCIA],
        gru.Gru_nombre													            AS [GRUPO ASIGNADO],
        ea.Eqp_Nombre                                                               AS [EQUIPO ASIGNADO],
        er.Eqp_Nombre                                                               AS [EQUIPO RESPONSABLE],
	    ua.U_nom														            AS [USUARIO ASIGNADO],
	    ur.U_nom														            AS [RESPONSABLE ASIGNADO],
        CASE 
		    WHEN I_porContrato = 1 AND I_porMantenimiento = 0 THEN 'Por contrato'
            WHEN I_porContrato = 1 AND I_porMantenimiento = 1 THEN 'Por mantenimiento'
            WHEN i.IncPresupuestoAceptado = 1 THEN 'Por bolsa de horas' 
            ELSE 'NO' 
	    END																            AS [PRESUPUESTO ACEPTADO],
	    CAST(i.i_fechaenviopresupuesto AS DATE)                                     AS [FECHA ENVIO PRESUPUESTO],
        CAST(i.I_fechaAceptacionPresupuesto AS DATE)                                AS [FECHA ACEPTACION PRESUPUESTO],
        CAST(i.I_fechaInicioPrevista AS DATE)                                       AS [FECHA INICIO PREVISTA],
        CAST(i.I_fechaPactadaCliente AS DATE)                                       AS [FECHA COMPROMETIDA CLIENTE],
        CAST(i.i_FechaEntregaPM AS DATE)                                            AS [FECHA ENTREGA ESTABLE],
        i.I_urldocumentotrabajo                                                     AS [DOCUMENTO UNICO]
    FROM 
                    agencias.dbo.incidencia i
        LEFT JOIN  agencias.dbo.AGENCIA aj           ON aj.A_Codi = i.A_codi
        LEFT JOIN  agencias.dbo.USUARI ua            ON ua.Id_usuari = i.Id_usuari
        LEFT JOIN  agencias.dbo.USUARI ur            ON ur.Id_usuari = i.I_responsableTicket
        LEFT JOIN  agencias.dbo.TIPO_INCIDENCIA ti   ON ti.TI_id = i.I_tipus AND ti.TI_Activo = 1
        LEFT  JOIN  agencias.dbo.GRUPO_USUARIOS gru   ON ua.id_gru = gru.id_gru
        LEFT  JOIN  agencias.dbo.Tbl_Equipo     ea     ON ua.id_eqp = ea.Id_Eqp
        LEFT  JOIN  agencias.dbo.Tbl_Equipo     er     ON ur.id_eqp = er.Id_Eqp

    WHERE
        i.A_codi = @IDCLIENTE
        AND aj.A_nom = @CLIENTE
        AND i.I_estat <> 'C'
),

COMENTARIOS AS (
    SELECT 
        i2.Id_incidencia                            AS [ID_INCIDENCIA],
        i2.FecCre                                   AS [FECHA COMENTARIO],
        'Inicial'                                   AS [TIPO COMENTARIO],
        i2.I_descripcio                             AS [COMENTARIO],
        10000                                       AS [USUARIO COMENTARIO],
        agencias.dbo.converthtml(i2.I_nomClient)    AS [NOMBRE USUARIO COMENTARIO]

    FROM agencias.dbo.INCIDENCIA i2

    UNION ALL

    SELECT 
        iu.Id_incidencia,
        iu.feccre,
        'Externo',
        iu.IU_descripcio,
        iu.Id_usuari,
        iu.IU_nomUsuari
    FROM agencias.dbo.INCIDENCIAUSUARI iu WHERE iu.IU_comentarioManual = 1

    UNION ALL

    SELECT 
        ii.Id_incidencia,
        ii.feccre,
        'Interno',
        ii.IU_descripcio,
        ii.Id_usuari,
        'Nombre Usuario Comentario'
    FROM agencias.dbo.INCIDENCIAINTERNA ii WHERE ii.IU_comentarioManual = 1
),

BASE AS (
    SELECT
        INC.*,
        C.[TIPO COMENTARIO]                         AS [TIPO COMENTARIO],
        C.[FECHA COMENTARIO]                        AS [FECHA COMENTARIO],
        agencias.dbo.converthtml(C.COMENTARIO)      AS [COMENTARIO],
        CASE  
            WHEN u.Id_usuari = 10000 AND C.[NOMBRE USUARIO COMENTARIO] IS NULL
            THEN U.U_Nom
            WHEN u.Id_usuari = 10000 AND C.[NOMBRE USUARIO COMENTARIO] IS NOT NULL
            THEN C.[NOMBRE USUARIO COMENTARIO]
            ELSE U.U_Nom                                     
        END                                         AS [USUARIO COMENTARIO]
    FROM INCIDENCIAS INC
    LEFT JOIN COMENTARIOS C ON C.Id_incidencia = INC.[ID INCIDENCIA]
    LEFT JOIN agencias.dbo.USUARI U ON U.Id_usuari = C.[USUARIO COMENTARIO]
),

FINAL AS(
SELECT
    B.[CLIENTE],
    B.[BACKLOG PRIORITY],
    B.[ID INCIDENCIA],
    B.[TITULO],
    B.[TIPO INCIDENCIA],
    B.[ESTADO],
    B.[PDTE RS],
    B.[CREADOR INCIDENCIA],
    B.[FECHA CREACION INCIDENCIA],
    B.[GRUPO ASIGNADO],
    B.[EQUIPO ASIGNADO],
    B.[USUARIO ASIGNADO],
    B.[RESPONSABLE ASIGNADO],
    B.[EQUIPO RESPONSABLE],
    B.[PRESUPUESTO ACEPTADO],
    B.[FECHA ENVIO PRESUPUESTO],
    B.[FECHA ACEPTACION PRESUPUESTO],
    B.[FECHA INICIO PREVISTA],
    B.[FECHA COMPROMETIDA CLIENTE],
    B.[FECHA ENTREGA ESTABLE],
    B.[DOCUMENTO UNICO],
    -- 🔵 Comentario Inicial
    STRING_AGG(
        CASE   
            WHEN [TIPO COMENTARIO] = 'Inicial' THEN  
                CONCAT(
                    '[Fecha: ', FORMAT([FECHA COMENTARIO],'yyyy-MM-dd HH:mm'), '] ',
                    '[Usuario: ', ISNULL([USUARIO COMENTARIO],'?'), '] ',
                    '[', [COMENTARIO], ']'
                )
        END,
        ' || '
    ) WITHIN GROUP (ORDER BY [FECHA COMENTARIO] ASC) AS [COMENTARIO INICIAL],
    -- 🔵 Comentarios EXTERNOS
    STRING_AGG(
        CASE 
            WHEN [TIPO COMENTARIO] = 'Externo' THEN
                CONCAT(
                        '[Fecha: ', FORMAT([FECHA COMENTARIO],'yyyy-MM-dd HH:mm'), '] ',
                        '[Usuario: ', ISNULL([USUARIO COMENTARIO],'?'), '] ',
                        '[',[COMENTARIO],']'
                    )
        END,
        ' || '
    ) WITHIN GROUP (ORDER BY [FECHA COMENTARIO] ASC) AS [COMENTARIOS EXTERNOS],
    -- 🟠 Comentarios INTERNOS
    STRING_AGG(
        CASE 
            WHEN [TIPO COMENTARIO] = 'Interno' THEN
                CONCAT(
                    '[Fecha: ', FORMAT([FECHA COMENTARIO],'yyyy-MM-dd HH:mm'), '] ',
                    '[Usuario: ', ISNULL([USUARIO COMENTARIO],'?'), '] ',
                    '[',[COMENTARIO],']'
                )
        END,
        ' || '
    ) WITHIN GROUP (ORDER BY [FECHA COMENTARIO] ASC)                            AS [COMENTARIOS INTERNOS],
    CAST(MAX([FECHA COMENTARIO]) AS DATE)                                       AS [FECHA ULTIMO COMENTARIO],
    DATEDIFF(DAY, MAX([FECHA COMENTARIO]), GETDATE())                           AS [DIAS SIN MOVIMIENTO],
    COUNT(CASE WHEN B.[TIPO COMENTARIO] IS NOT NULL THEN 1 END)                 AS [TOTAL COMENTARIOS],
    COUNT(CASE WHEN B.[TIPO COMENTARIO] = 'Inicial' THEN 1 END)                 AS [NUM COMENTARIOS INICIALES],
    COUNT(CASE WHEN B.[TIPO COMENTARIO] = 'Externo' THEN 1 END)                 AS [NUM COMENTARIOS EXTERNOS],
    COUNT(CASE WHEN B.[TIPO COMENTARIO] = 'Interno' THEN 1 END)                 AS [NUM COMENTARIOS INTERNOS]

FROM 
    BASE B
GROUP BY
    B.[CLIENTE],B.[BACKLOG PRIORITY],B.[ID INCIDENCIA],B.[TITULO],B.[TIPO INCIDENCIA],B.[ESTADO],B.[PDTE RS],
    B.[CREADOR INCIDENCIA],B.[FECHA CREACION INCIDENCIA],B.[GRUPO ASIGNADO],B.[EQUIPO ASIGNADO],B.[USUARIO ASIGNADO],B.[RESPONSABLE ASIGNADO],B.[EQUIPO RESPONSABLE],
    B.[PRESUPUESTO ACEPTADO],B.[FECHA ENVIO PRESUPUESTO],B.[FECHA ACEPTACION PRESUPUESTO],
    B.[FECHA INICIO PREVISTA],B.[FECHA COMPROMETIDA CLIENTE],B.[FECHA ENTREGA ESTABLE],B.[DOCUMENTO UNICO]
)

SELECT
    --[CLIENTE], [BACKLOG PRIORITY],
    [ID INCIDENCIA], [TITULO], [TIPO INCIDENCIA], [ESTADO],[PDTE RS],
    [DOCUMENTO UNICO],
    [FECHA COMPROMETIDA CLIENTE], [FECHA ENTREGA ESTABLE],
    [GRUPO ASIGNADO], [EQUIPO ASIGNADO], [USUARIO ASIGNADO], [RESPONSABLE ASIGNADO],[EQUIPO RESPONSABLE],
    [PRESUPUESTO ACEPTADO],
    [CREADOR INCIDENCIA],[FECHA CREACION INCIDENCIA], [FECHA ENVIO PRESUPUESTO], [FECHA ACEPTACION PRESUPUESTO], [FECHA INICIO PREVISTA], [FECHA ULTIMO COMENTARIO], [DIAS SIN MOVIMIENTO]
    ,[TOTAL COMENTARIOS],[NUM COMENTARIOS EXTERNOS],[NUM COMENTARIOS INTERNOS]
    ,[COMENTARIO INICIAL],[COMENTARIOS EXTERNOS], [COMENTARIOS INTERNOS]
FROM
    FINAL
WHERE   1 = 1
        /*CUSTOM*/
        --AND NOT ([TIPO INCIDENCIA] = ' 2.a Soporte XML' AND [GRUPO ASIGNADO] <> 'API Support')                                                                    /*EXCLUIMOS XML EN GESTION*/
        --AND NOT (([TITULO] LIKE '%Gestión%' OR [TITULO] LIKE '%genérica%') AND [TIPO INCIDENCIA] IN (' 2. Soporte', '16. Sistemas'))                              /*EXCLUIMOS GESTION*/

        /*XML*/
        --AND NOT ([TIPO INCIDENCIA] = ' 2.a Soporte XML' AND [GRUPO ASIGNADO] = 'API Support')                                                                       /*XML EN CURSO*/
        --AND ([TIPO INCIDENCIA] = ' 2.a Soporte XML' AND [USUARIO ASIGNADO] = 'Integrador API')                                                                    /*XML LIVE*/
        --AND ([TIPO INCIDENCIA] = ' 2.a Soporte XML' AND [USUARIO ASIGNADO] = 'Integrador Pending API')                                                            /*XML PENDING*/
        
        /*BA*/
        --AND NOT ([TIPO INCIDENCIA] = ' 3. Desarrollo' AND ([EQUIPO RESPONSABLE] = 'PMO' OR [EQUIPO ASIGNADO] = 'PMO'))                                              /*BA EN CURSO*/

        /*TIPOS INCIDENCIA*/
        --AND NOT ([TIPO INCIDENCIA] = '19.Hotel Único' AND [GRUPO ASIGNADO] = 'Plan&Mapping')                                                                        /*EXCLUIMOS HU EN GESTION*/
        --AND [TIPO INCIDENCIA] NOT IN('24. Desarrollo (entregado)','23. Error Resuelto','26. Soporte (entregado)','27. Error Resuelto (Atendido como soporte)')      /*EXCLUIMOS LO ENTREGADO*/
	    --AND [TIPO INCIDENCIA] IN ('13. Desarrollo (pend. actualización)', '12. Error (pend. actualización)')                                                      /*PENDIENTE ENTREGA*/
        --AND [TIPO INCIDENCIA] IN (' 2. Soporte')                                                                                                                  /*SOPORTES*/
	    --AND [TIPO INCIDENCIA] IN (' 4. Error')                                                                                                                    /*ERRORES*/

        /*USUARIOS*/
        --AND (([USUARIO ASIGNADO] = @USUARIO) OR ([RESPONSABLE ASIGNADO] = @USUARIO))                                                                             /*USUARIO ASIGNADO O RESPONSABLE*/
        AND (([EQUIPO ASIGNADO] = @EQUIPO) OR ([EQUIPO RESPONSABLE] = @EQUIPO))                                                                                    /*EQUIPO ASIGNADO*/
        --AND [EQUIPO RESPONSABLE] <> @EQUIPO                                                                                                                       /*EQUIPO ASIGNADO*/

        /*RESPUESTA*/
        AND [PDTE RS] = 1                                                                                                                                         /*PENDIENTE RESPUESTA*/

        /*ESTADOS*/
        --AND [ESTADO] IN ('Pend Cliente', 'Pend Proveedor')
        --AND [ESTADO] IN ('Nueva', 'En curso', 'Pend Juniper')
        --AND [EQUIPO RESPONSABLE] NOT IN (@EQUIPO, 'PMO', 'PS Spain','PS Cali')
        
        /*OTRAS*/
        --AND [TIPO INCIDENCIA] = ' 2. Soporte'
        --AND [ID INCIDENCIA] = 1087487
ORDER BY
    --[ID INCIDENCIA] DESC,
    [TIPO INCIDENCIA],
    [RESPONSABLE ASIGNADO]

--FOR JSON PATH, ROOT('INCIDENCIAS');