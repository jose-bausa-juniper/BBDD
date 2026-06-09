WITH Webs AS (
    SELECT 
        id_BDD, id_Web, Web_SisGranjaServer,
        Id_grs, id_grsext, id_grsextdos, id_grsexttres, web_urlproyectogit
    FROM BD_BookingEngine.dbo.Tbl_Web
),
GrupoServidores AS (
    SELECT Id_grs, Grs_Nombre
    FROM bd_mantenimiento.dbo.Tbl_GrupoServidores
),
ConfigIISEnlaces AS (
    SELECT id_Web, cfe_site, cfe_proyecto
    FROM bd_mantenimiento.dbo.Tbl_configiisenlaces
)
SELECT
    W.id_BDD                                          AS [BBDD],  
    W.id_WEB                                          AS [WEB],
    ISNULL(CIE.cfe_site, W.Web_SisGranjaServer)       AS [SITE],
    GS.Grs_Nombre                                     AS [GRUPO SERVIDOR],
    ISNULL(CIE.cfe_proyecto, 'web')                   AS [APP],
    
    CASE 
        WHEN CHARINDEX('/', REVERSE(web_urlproyectogit)) > 0 
        THEN RIGHT(web_urlproyectogit, CHARINDEX('/', REVERSE(web_urlproyectogit)) - 1)
        ELSE NULL
    END AS [GIT]
FROM Webs W
    LEFT JOIN GrupoServidores GS ON (W.Id_grs = GS.Id_grs 
                                    OR W.id_grsext = GS.Id_grs 
                                    OR W.id_grsextdos = GS.Id_grs 
                                    OR W.id_grsexttres = GS.Id_grs) 
    LEFT JOIN ConfigIISEnlaces CIE ON CIE.id_Web = W.id_Web
WHERE
    1 = 1
GROUP BY
    W.id_BDD,
    W.id_WEB,
    CIE.cfe_site,
    ISNULL(CIE.cfe_site, W.Web_SisGranjaServer),
    GS.Grs_Nombre,
    CIE.cfe_proyecto,
    W.web_urlproyectogit
ORDER BY 
    W.id_WEB
