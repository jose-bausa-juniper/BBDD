USE BD_Nincoming;

WITH INTEGRADORES_CONFIGURADOS AS(

SELECT 
    --iws.Int_IdIntegradorUnico       AS [IntUnico],
    iws.int_nombre                  AS [Nombre Integrador],
    iws.Id_Int                      AS [IntW2M],
    iws.int_activo                  AS [Integrador Activo],
    iws.Int_ChannelManagerExtranet  AS [Channel Manager],
    ISNULL(c.AgenciasConectadas, 0) AS [Agencias Conectadas],
    ISNULL(aws.UsuariosAdminWS, 0)  AS [Usuarios Adm WS Conectados],
    ISNULL(u.UsuariosExtranet, 0)   AS [Usuario Extranet Conectados]

FROM Tbl_IntegradorWS iws

-- Agencias (ya agregadas)
LEFT JOIN (
    SELECT 
        id_int,
        COUNT(*) AS AgenciasConectadas
    FROM Tbl_Cliente
    GROUP BY id_int
) c ON c.id_int = iws.Id_Int

-- Usuarios (ya agregados)
LEFT JOIN (
    SELECT 
        Id_Int,
        COUNT(*) AS UsuariosExtranet
    FROM Tbl_UsuarioExtranet
    GROUP BY Id_Int
) u ON u.Id_Int = iws.Id_Int

-- AdminWS (ya agregados)
LEFT JOIN (
    SELECT 
        Id_Int,
        COUNT(*) AS UsuariosAdminWS
    FROM Tbl_AdministradorWS
    GROUP BY Id_Int
) aws ON aws.Id_Int = iws.Id_Int

)

SELECT
    *
FROM
    INTEGRADORES_CONFIGURADOS
WHERE 
    1 = 1
    --AND [Integrador Activo] = 1
    --AND [Agencias Conectadas] <> 0
    --AND [Usuario Extranet Conectados] <> 0
    --AND [Usuarios Adm WS Conectados] = 1
    --AND [Channel Manager] = 1
    AND [Nombre Integrador] <> 'ZZ - Deactivated'
