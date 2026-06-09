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

--FRONT: Incidencia asociada a la solicitud %PR% pasada a %PROYECTO% ->  %GIT%/%RAMA% .<br\>Compilado, pendiente de despliegue.
--BookingEngine/JuniperTools/Product Tools: Incidencia asociada a la solicitud %PR% pasada a %PROYECTO% -> %GIT%/%RAMA% en version: %VERSION%<br\>Compilado, pendiente de despliegue.