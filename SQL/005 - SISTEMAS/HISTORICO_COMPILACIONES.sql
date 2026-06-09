WITH 
TodasIncidencias AS (
    SELECT
         Id_incidencia,agencias.dbo.converthtml(I_asumpte) AS I_asumpte, A_codi
    FROM
        agencias.dbo.INCIDENCIAS
),
Cliente AS (
    SELECT
         A.A_codi, A.A_nom, BD.Id_BDD, BD.BDD_Nombre
    FROM
        agencias.dbo.AGENCIA A
        INNER JOIN BD_BookingEngine.dbo.Tbl_BaseDatos BD ON BD.A_Codi = A.A_codi
),
TodasIncidencias_Cliente AS (
    SELECT
         C.A_nom, C.Id_BDD, TI.Id_incidencia, TI.I_asumpte
    FROM
                    Cliente             C
        INNER JOIN  TodasIncidencias    TI ON TI.A_codi = C.A_codi
),
Todas_Incidencias_Con_Compilacion_De_PR AS (
    SELECT
        [INCIDENCIA]        = Id_incidencia,
        [FECRE]             = FecCre,
        [PR]                = CASE 
                                WHEN PATINDEX('%PR%', CAST(IU_descripcio AS VARCHAR(MAX))) > 0 
                                    AND PATINDEX('% pasada a%', CAST(IU_descripcio AS VARCHAR(MAX))) > PATINDEX('%PR%', CAST(IU_descripcio AS VARCHAR(MAX))) 
                                THEN SUBSTRING(CAST(IU_descripcio AS VARCHAR(MAX)),
                                    PATINDEX('%PR%', CAST(IU_descripcio AS VARCHAR(MAX))) + 2,
                                    PATINDEX('% pasada a%', CAST(IU_descripcio AS VARCHAR(MAX))) - PATINDEX('%PR%', CAST(IU_descripcio AS VARCHAR(MAX))) - 2)
                                ELSE NULL
                            END,
        [PROYECTO]          = CASE 
                                WHEN PATINDEX('%pasada a %', CAST(IU_descripcio AS VARCHAR(MAX))) > 0 
                                    AND PATINDEX('% ->%', CAST(IU_descripcio AS VARCHAR(MAX))) > PATINDEX('%pasada a %', CAST(IU_descripcio AS VARCHAR(MAX))) 
                                THEN SUBSTRING(CAST(IU_descripcio AS VARCHAR(MAX)),
                                    PATINDEX('%pasada a %', CAST(IU_descripcio AS VARCHAR(MAX))) + 9,
                                    PATINDEX('% ->%', CAST(IU_descripcio AS VARCHAR(MAX))) - PATINDEX('%pasada a %', CAST(IU_descripcio AS VARCHAR(MAX))) - 9)
                                ELSE NULL
                            END,
        [GIT]               = CASE 
                                WHEN PATINDEX('%-> %', CAST(IU_descripcio AS VARCHAR(MAX))) > 0 
                                    AND PATINDEX('%/%', CAST(IU_descripcio AS VARCHAR(MAX))) > PATINDEX('%-> %', CAST(IU_descripcio AS VARCHAR(MAX))) 
                                THEN SUBSTRING(CAST(IU_descripcio AS VARCHAR(MAX)),
                                    PATINDEX('%-> %', CAST(IU_descripcio AS VARCHAR(MAX))) + 3,
                                    PATINDEX('%/%', CAST(IU_descripcio AS VARCHAR(MAX))) - PATINDEX('%-> %', CAST(IU_descripcio AS VARCHAR(MAX))) - 3)
                                ELSE NULL
                            END,
        [RAMA]              = CASE
                                WHEN CAST(IU_descripcio AS VARCHAR(MAX)) LIKE '%FRONT%' 
                                    AND PATINDEX('%/%', CAST(IU_descripcio AS VARCHAR(MAX))) > 0 
                                    AND PATINDEX('%.<br%', CAST(IU_descripcio AS VARCHAR(MAX))) > PATINDEX('%/%', CAST(IU_descripcio AS VARCHAR(MAX))) 
                                THEN SUBSTRING(CAST(IU_descripcio AS VARCHAR(MAX)),
                                    PATINDEX('%/%', CAST(IU_descripcio AS VARCHAR(MAX))) + 1,
                                    PATINDEX('%.<br%', CAST(IU_descripcio AS VARCHAR(MAX))) - PATINDEX('%/%', CAST(IU_descripcio AS VARCHAR(MAX))) - 1)
                                WHEN CAST(IU_descripcio AS VARCHAR(MAX)) LIKE '%BookingEngine%' 
                                    OR CAST(IU_descripcio AS VARCHAR(MAX)) LIKE '%JuniperTools%' 
                                    OR CAST(IU_descripcio AS VARCHAR(MAX)) LIKE '%ProductMapping%' 
                                    AND PATINDEX('%/%', CAST(IU_descripcio AS VARCHAR(MAX))) > 0 
                                    AND PATINDEX('% en version:%', CAST(IU_descripcio AS VARCHAR(MAX))) > PATINDEX('%/%', CAST(IU_descripcio AS VARCHAR(MAX))) 
                                THEN SUBSTRING(CAST(IU_descripcio AS VARCHAR(MAX)),
                                    PATINDEX('%/%', CAST(IU_descripcio AS VARCHAR(MAX))) + 1,
                                    PATINDEX('% en version:%', CAST(IU_descripcio AS VARCHAR(MAX))) - PATINDEX('%/%', CAST(IU_descripcio AS VARCHAR(MAX))) - 1)
                                ELSE NULL
                            END,
        [VERSIONCOMPILADA]  = CASE 
                                WHEN PATINDEX('%en version:%', CAST(IU_descripcio AS VARCHAR(MAX))) > 0 
                                    AND PATINDEX('%.<%', CAST(IU_descripcio AS VARCHAR(MAX))) > PATINDEX('%en version:%', CAST(IU_descripcio AS VARCHAR(MAX))) 
                                THEN SUBSTRING(CAST(IU_descripcio AS VARCHAR(MAX)),
                                    PATINDEX('%en version:%', CAST(IU_descripcio AS VARCHAR(MAX))) + 12,
                                    PATINDEX('%.<%', CAST(IU_descripcio AS VARCHAR(MAX))) - PATINDEX('%en version:%', CAST(IU_descripcio AS VARCHAR(MAX))) - 12)
                                ELSE NULL
                            END
    FROM 
        agencias.dbo.INCIDENCIAINTERNA
    WHERE 
        1 = 1
        AND Id_usuari = 23
        AND (IU_descripcio LIKE'%PR%' AND IU_descripcio LIKE'%Compilado%' AND IU_descripcio LIKE'%->%')
),
Ajuste_Version_Front_Tools AS (
    SELECT
        [INCIDENCIA],
        [PR],
        [PROYECTO],
        [GIT],
        [RAMA],
        CASE 
            WHEN [VERSIONCOMPILADA] IS NULL
            THEN CONCAT(
                    'F.', 
                    RIGHT(YEAR([FECRE]), 2),
                    '.',
                    RIGHT('00' + CAST(MONTH([FECRE]) AS VARCHAR), 2),
                    RIGHT('00' + CAST(DAY([FECRE]) AS VARCHAR), 2),
                    '.' ,
                    RIGHT('00' + CAST(DATEPART(HOUR, [FECRE]) AS VARCHAR), 2)
                    )
            WHEN PROYECTO = 'JuniperTools'
            THEN CONCAT(
                    'J.', 
                    RIGHT(YEAR([FECRE]), 2),
                    '.',
                    RIGHT('00' + CAST(MONTH([FECRE]) AS VARCHAR), 2),
                    RIGHT('00' + CAST(DAY([FECRE]) AS VARCHAR), 2),
                    '.' ,
                    RIGHT('00' + CAST(DATEPART(HOUR, [FECRE]) AS VARCHAR), 2)
                    )
            WHEN PROYECTO = 'Product Tools'
            THEN CONCAT(
                    'P.', 
                    RIGHT(YEAR([FECRE]), 2),
                    '.',
                    RIGHT('00' + CAST(MONTH([FECRE]) AS VARCHAR), 2),
                    RIGHT('00' + CAST(DAY([FECRE]) AS VARCHAR), 2),
                    '.' ,
                    RIGHT('00' + CAST(DATEPART(HOUR, [FECRE]) AS VARCHAR), 2)
                    )
            ELSE [VERSIONCOMPILADA]
        END AS [VERSIONCOMPILADA],
        [FECRE]
    FROM
        Todas_Incidencias_Con_Compilacion_De_PR
),
DLL_PR_Compilados AS (
    SELECT
        [INCIDENCIA]          AS [INCIDENCIA],  
        [PR]                  AS [PR],
        [PROYECTO]            AS [PROYECTO],
        [GIT]                 AS [GIT],
        [RAMA]                AS [RAMA],
        [VERSIONCOMPILADA]    AS [VERSIONCOMPILADA],
        MAX([FECRE])          AS [FECRE]
    FROM Ajuste_Version_Front_Tools
    GROUP BY
    [INCIDENCIA],[PR],[PROYECTO],[GIT],[RAMA],[VERSIONCOMPILADA]
), IncidenciaCommit AS (
SELECT
    ICO_PoolRequestID,
    ICO_branch,
    id_incidencia,
    ICO_EstadoCompilacion,
    ICO_Repository,
    ICO_Project,
    ICO_CloseDate
FROM
    agencias.dbo.Tbl_IncidenciaCommit
WHERE
    ICO_EstadoCompilacion IN (2,4)
)

SELECT 
    TIC.A_nom,
    TIC.Id_BDD,
    INCIDENCIA,
    TIC.I_asumpte,
    IC.id_incidencia,
    PR,
    ICO_PoolRequestID,
    PROYECTO,
    ICO_Project,
    GIT,
    ICO_Repository,
    RAMA,
    ICO_branch,
    VERSIONCOMPILADA,
    CONCAT('20',SUBSTRING(VERSIONCOMPILADA, CHARINDEX('.', VERSIONCOMPILADA) + 1, 2),
            '-',
            SUBSTRING(VERSIONCOMPILADA, CHARINDEX('.', VERSIONCOMPILADA, CHARINDEX('.', VERSIONCOMPILADA) + 1) + 1, 2),
            '-',
            SUBSTRING(VERSIONCOMPILADA, CHARINDEX('.', VERSIONCOMPILADA, CHARINDEX('.', VERSIONCOMPILADA) + 1) + 3, 2),
            ' ',
            SUBSTRING(VERSIONCOMPILADA, LEN(VERSIONCOMPILADA) - 1, 2),':00:00.000') AS FECHA_COMPILACION,
    ICO_EstadoCompilacion,
    FECRE,
    ICO_CloseDate
FROM 
                DLL_PR_Compilados
    LEFT JOIN   IncidenciaCommit          IC      ON PR = IC.ICO_PoolRequestID AND INCIDENCIA = IC.id_incidencia
    INNER JOIN   TodasIncidencias_Cliente TIC     ON TIC.Id_incidencia = IC.id_incidencia
WHERE
    IC.id_incidencia <> 0
    AND ICO_PoolRequestID IS NOT NULL
    AND INCIDENCIA = 1047862
ORDER BY
    [FECRE] DESC