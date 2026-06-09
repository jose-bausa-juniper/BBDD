SELECT
    W.id_BDD            AS [BBDD],
    W.id_web            AS [WEB],
	GS.Grs_Nombre		AS [GRUPO SERVIDOR],
    'web'               AS [APP],
    B.bak_entorno       AS [ENTORNO],
    B.bak_fichero       AS [FICHERO],
    B.Feccre            AS [FECHA],
    B.bak_dlls          AS [DLLS],
    B.bck_id_proceso    AS [PROCESO],
    B.bak_operacion     AS [OPERACION],
    U.U_nom             AS [USUARIO],
    B.bak_comentario    AS [COMENTARIO]
    ,TC.tco_fin          AS [FECHA_FIN_COMPILACION],
    CASE
        WHEN TC.tco_fin IS NOT NULL 
            THEN 
            CONCAT  (
                    'F.', 
                    RIGHT(YEAR(TC.tco_fin), 2),
                    '.',
                    RIGHT('00' + CAST(MONTH(TC.tco_fin) AS VARCHAR), 2),
                    RIGHT('00' + CAST(DAY(TC.tco_fin) AS VARCHAR), 2),
                    '.' ,
                    RIGHT('00' + CAST(DATEPART(HOUR, TC.tco_fin) AS VARCHAR), 2)
                    ) 
            ELSE NULL
        END AS [DLLS_FRONT]
FROM 
                BD_BookingEngine.dbo.Tbl_Web                W
    INNER JOIN  BD_BookingEngine.dbo.Tbl_Backups            B   ON B.Id_web = W.id_WEB
    INNER JOIN  agencias.dbo.usuari                         U   ON U.id_Usuari = B.Id_usuario
    LEFT JOIN	bd_mantenimiento.dbo.Tbl_GrupoServidores	GS	ON GS.Id_grs = W.Id_Grs
    LEFT JOIN  bd_mantenimiento.dbo.Tbl_TareasProcesos     TP  ON TP.id_Proceso = B.bck_id_proceso AND TP.tco_params LIKE 'c:\programas\JuniperCompilador\JuniperCompilador.exe|%'
    LEFT JOIN   bd_mantenimiento.dbo.Tbl_TareasCola         TC  ON TC.id_tarpro = TP.id_TarPro 
WHERE 
    1 = 1
    AND B.bak_entorno IN ('WWW', 'PRE')
ORDER BY
    WEB DESC,
    FECHA DESC