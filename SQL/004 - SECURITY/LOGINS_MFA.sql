--SELECT
--    Par_Codigo,
--    Par_Valor
--FROM 
--    Tbl_Parametro
--WHERE 
--    Par_Codigo LIKE 'Seguridad%'
--    AND (Par_Codigo LIKE 'Seguridad/MultiFactor%' OR Par_Codigo LIKE '%MFA%')
--    AND (Par_Codigo = 'Seguridad/MultiFactorLoginAdmin'
--        OR Par_Codigo = 'Seguridad/MultiFactorTOTPLoginAdmin'
--        OR Par_Codigo = 'Seguridad/DiasMFALoginAdmin');

WITH CONFIG_ADM_MFA AS (
    SELECT
        Par_Codigo,
        Par_Valor
    FROM 
        Tbl_Parametro
    WHERE 
        Par_Codigo LIKE 'Seguridad%'
        AND (Par_Codigo LIKE 'Seguridad/MultiFactor%' OR Par_Codigo LIKE '%MFA%')
        AND (Par_Codigo = 'Seguridad/MultiFactorLoginAdmin'
            OR Par_Codigo = 'Seguridad/MultiFactorTOTPLoginAdmin'
            OR Par_Codigo = 'Seguridad/DiasMFALoginAdmin')
),

USUARIOS_ADMIN_MFA_JUNIPER AS (
    SELECT
        A.Id_Adm,
        A.Adm_Nombre,
        A.Adm_Login,
        A.Adm_Activo,
        CASE
        WHEN AE.Adm_LoginMFACorreo = 1 THEN 'MAIL'
        WHEN AE.Adm_LoginMFATotp = 1 THEN 'APP'
        ELSE 'UNKNOWN'
        END AS TIPO_MFA
    FROM
				    Tbl_Administrador			A
	    INNER JOIN	Tbl_AdministradorExtendido	AE	ON AE.Id_Adm = A.Id_Adm 
	    LEFT  JOIN	Tbl_UsuarioLoginExterno		ULE ON ULE.ULE_IdUsuario = A.Id_Adm 
    WHERE
	    1 = 1
        AND A.Adm_Activo = 1
        AND ULE.Id_ULE IS NULL
        AND (AE.Adm_LoginMFACorreo = 1 OR AE.Adm_LoginMFATotp = 1)
),

LOGINS_HIS AS (
    SELECT
        LL.Log_aplicativo,
        LL.id_log,
        LL.Log_Usuario,
        [Log_DirIP] =    convert(varchar(max), convert(BIGINT,LL.Log_DirIP/256/256/256) % 256) + '.' + 
                         convert(varchar(max),convert(BIGINT,LL.Log_DirIP/256/256) % 256) + '.' + 
                         convert(varchar(max),convert(BIGINT,LL.Log_DirIP/256) % 256) + '.' + 
                         convert(varchar(max),convert(BIGINT,LL.Log_DirIP) % 256),
        LL.Log_Tipo,
        LL.Log_IdUsuario,
        LL.Feccre AS [Login.Feccre],
        LL.Log_SesionCerrada,
        LL.Log_SessionID,
        LL.Log_EstadoValidacion,
        LL.Log_CodigoNavegador
    FROM
				    BD_HIS.BD_Nincoming.Tbl_LogLogins				LL      ------- CAMBIAR POR LA BD_CLI CORRESPONDIENTE
    WHERE
	    1 = 1
	    AND LL.Log_Tipo = 'Adm'
	    AND (LL.Log_Usuario <> '___firma___')
	    AND LL.Feccre BETWEEN (GETDATE()-15) AND (GETDATE()-7)
),

LOGINS_BDCLI AS (
    SELECT
        LL.Log_aplicativo,
        LL.id_log,
        LL.Log_Usuario,
        [Log_DirIP] =    convert(varchar(max), convert(BIGINT,LL.Log_DirIP/256/256/256) % 256) + '.' + 
                         convert(varchar(max),convert(BIGINT,LL.Log_DirIP/256/256) % 256) + '.' + 
                         convert(varchar(max),convert(BIGINT,LL.Log_DirIP/256) % 256) + '.' + 
                         convert(varchar(max),convert(BIGINT,LL.Log_DirIP) % 256),
        LL.Log_Tipo,
        LL.Log_IdUsuario,
        LL.Feccre AS [Login.Feccre],
        LL.Log_SesionCerrada,
        LL.Log_SessionID,
        LL.Log_EstadoValidacion,
        LL.Log_CodigoNavegador
    FROM
        			Tbl_LogLogins				    LL
    WHERE
	    1 = 1
	    AND LL.Log_Tipo = 'Adm'
	    AND (LL.Log_Usuario <> '___firma___')
        AND LL.Feccre BETWEEN (GETDATE()-7) AND (GETDATE())
),

FULL_LOG AS (
    SELECT * FROM LOGINS_HIS
        UNION ALL
    SELECT * FROM LOGINS_BDCLI
),

ADM_LOGS_LAST_12H AS (
    SELECT
        DISTINCT Log_IdUsuario, Log_CodigoNavegador
    FROM 
        FULL_LOG
    GROUP BY
        Log_IdUsuario,Log_CodigoNavegador
    --HAVING
    --    MAX([Login.Feccre]) > (DATEADD(HOUR, -12, GETDATE()))
),
LOGINS_ADM AS (
    SELECT
        LL.Log_aplicativo,
        LL.id_log,
        LL.Log_Usuario,
        [Log_DirIP],
        LL.Log_Tipo,
        LL.Log_IdUsuario,
        LL.[Login.Feccre],
        LL.Log_SesionCerrada,
        LL.Log_SessionID,
        LL.Log_EstadoValidacion,
        LL.Log_CodigoNavegador,
        CASE LA.LoA_TipoAviso
            WHEN 0	    THEN 'unknown'
            WHEN 1	    THEN 'sessionChangeIP' 
            WHEN 2	    THEN 'sessionChangeCountry' 
            WHEN 11	    THEN 'simultaneousSessions' 
            WHEN 12	    THEN 'simultaneousSessionsSomeCountries' 
            WHEN 21	    THEN 'newLogin'
            WHEN 22	    THEN 'newLoginNewIP' 
            WHEN 23	    THEN 'newLoginNewCountry' 
            WHEN 50	    THEN 'changePasswordAdmin' 
            WHEN 51	    THEN 'changeContactAdmin' 
            WHEN 60	    THEN 'changePasswordClient' 
            WHEN 61	    THEN 'changeContactClient' 
            WHEN 62	    THEN 'changeLoginClient' 
            WHEN 70	    THEN 'changePasswordAgent' 
            WHEN 71	    THEN 'changeContactAgent' 
            WHEN 72	    THEN 'changeLoginAgent' 
            WHEN 80	    THEN 'changePasswordExtranetH' 
            WHEN 90	    THEN 'changePasswordExtranetS' 
            WHEN 100	THEN 'changePasswordExtranetP' 
            WHEN 110	THEN 'loginMFAEmail' 
            WHEN 111	THEN 'incorrectLoginMFA' 
            WHEN 112	THEN 'activateLoginMFATotp' 
            WHEN 113	THEN 'loginMFATotp' 
        END AS LoA_TipoAviso,
        LA.LoA_Nivel,
        LA.LoA_Datos,
        LA.Feccre AS [Aviso.Feccre]
    FROM
        			FULL_LOG				        LL
	    LEFT JOIN	Tbl_LogLoginsAviso			    LA	    ON LA.Id_Log = LL.id_log
),
LOGINS_ADM_MFA AS (
    SELECT
        UAMFAJ.*,
        LA.*
    FROM
                    LOGINS_ADM                  LA
        INNER JOIN  USUARIOS_ADMIN_MFA_JUNIPER  UAMFAJ  ON UAMFAJ.Id_Adm = LA.Log_IdUsuario
        INNER JOIN  ADM_LOGS_LAST_12H           LAST_H  ON LAST_H.Log_IdUsuario = LA.Log_IdUsuario AND LAST_H.Log_CodigoNavegador = LA.Log_CodigoNavegador

)

    --SELECT * FROM LOGINS_HIS ORDER BY [Login.Feccre] DESC

SELECT 
    Log_aplicativo,
--ADMIN
    Id_Adm,
    Adm_Login,
    TIPO_MFA,
--LOGIN
    MAX([Login.Feccre]) AS MAX_LOG,
    Log_EstadoValidacion,
    Log_CodigoNavegador

FROM LOGINS_ADM_MFA

WHERE
  EXISTS (
      SELECT 1
      FROM CONFIG_ADM_MFA
      WHERE Par_Valor = 'True'
  )
GROUP BY
    Log_aplicativo,
    Id_Adm,
    Adm_Login,
    TIPO_MFA,
    Log_EstadoValidacion,
    Log_CodigoNavegador
ORDER BY 
    Id_Adm
