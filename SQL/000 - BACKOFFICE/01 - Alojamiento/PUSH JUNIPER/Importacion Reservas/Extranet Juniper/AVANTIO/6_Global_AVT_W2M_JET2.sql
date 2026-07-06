WITH 

RESERVAS_JET2_AVT AS(
    SELECT 
        DISTINCT
        DRe_codigoExt               AS FULL_LOC_JET2,
        DRe_IdAlo                   AS ID_VILLA
    FROM 
        BD_Nincoming_HIS.dbo.Tbl_DescargaReserva
    WHERE 
        DRe_CodigoSE = 57
        AND DRe_IdAlo LIKE '%AVT|%'
        AND FecCre >= '2026-06-14'
),

RESERVAS_JET2_AVT_VILLAS AS (
	SELECT
		RESERVAS_JET2_AVT.*,
		AlE_Nombre AS VILLA
	FROM 
        RESERVAS_JET2_AVT
		LEFT JOIN BD_Nincoming.dbo.vwQlik_JP_Externos ON CONCAT('AVT|',AlE_Cod) = RESERVAS_JET2_AVT.ID_VILLA
	WHERE
		1 = 1 
		AND AlE_Prov = 'AVT'
),

ULTIMA_DESCARGA_RESERVAS_JET2_AVT AS(
    SELECT 
        DISTINCT
        RESERVAS_JET2_AVT_VILLAS.*,
        MAX(Feccre)                 AS FECHA_ULTIMA_DESCARGA,
        MAX(DRe_IdHDRRet)           AS ULTIMA_DESCARGA
    FROM 
                RESERVAS_JET2_AVT_VILLAS
    LEFT JOIN   BD_Nincoming_HIS.dbo.Tbl_DescargaReserva DR ON DR.DRe_CodigoSE = 57 AND DR.DRe_codigoExt = RESERVAS_JET2_AVT_VILLAS.FULL_LOC_JET2
    GROUP BY
        RESERVAS_JET2_AVT_VILLAS.FULL_LOC_JET2,
        RESERVAS_JET2_AVT_VILLAS.ID_VILLA,
        RESERVAS_JET2_AVT_VILLAS.VILLA
),

DESGLOSE_FULL_LOC_JET2 AS (
    SELECT 
        *,
        FirstTilde  = CHARINDEX('~', FULL_LOC_JET2),
        SecondTilde = CHARINDEX('~', FULL_LOC_JET2, CHARINDEX('~', FULL_LOC_JET2) + 1)
    FROM 
        ULTIMA_DESCARGA_RESERVAS_JET2_AVT
),

DESCARGA_DESGLOSADA AS (
    SELECT 
        FULL_LOC_JET2,
        LOC_JET2 = LEFT(FULL_LOC_JET2, FirstTilde - 1),
        Id_LRE_JET2 = CAST(SUBSTRING(FULL_LOC_JET2, FirstTilde + 1, SecondTilde - FirstTilde - 1) AS BIGINT),
        Ref_Age_JET2 = SUBSTRING(FULL_LOC_JET2, SecondTilde + 1, LEN(FULL_LOC_JET2) - SecondTilde),
        ID_VILLA,
        VILLA,
        FECHA_ULTIMA_DESCARGA,
        ULTIMA_DESCARGA
    FROM 
        DESGLOSE_FULL_LOC_JET2
),

TODOS_XMLS AS (
    SELECT
        HDR.id_HDR,
        XMLRS = CAST(REPLACE(
            CAST(CAST(DECOMPRESS(HDR.HDR_ResponseBin) AS XML) AS NVARCHAR(MAX)),
            'xmlns="http://www.juniper.es/webservice/2010/"',
            ''
        ) AS XML)
    FROM 
        BD_Nincoming_HIS.dbo.Tbl_HistorialDescargaReserva HDR
    WHERE 
        1 = 1
        AND HDR.HDR_CodigoSE = 57
        AND id_HDR IN (SELECT ULTIMA_DESCARGA FROM DESCARGA_DESGLOSADA)
),
-----------------------------------------------------------------------------------
-- 🔹 DR + XML
-----------------------------------------------------------------------------------
XML_ULTIMA_DESCARGA AS(
    SELECT
        *
    FROM
                DESCARGA_DESGLOSADA DD
    LEFT JOIN   TODOS_XMLS ON DD.ULTIMA_DESCARGA = TODOS_XMLS.id_HDR
),
-----------------------------------------------------------------------------------
-- 🔹 DR + XML
-----------------------------------------------------------------------------------
DESGLOSE_XML_ULTIMA_DESCARGA AS(
    SELECT
        XUD.FULL_LOC_JET2,
        XUD.LOC_JET2,
        XUD.Id_LRE_JET2,
        XUD.Ref_Age_JET2,
        XUD.ID_VILLA,
        XUD.VILLA,
        XUD.FECHA_ULTIMA_DESCARGA,
        XUD.ULTIMA_DESCARGA,
        --XUD.XMLRS,

        --X.R.value('@Locator','VARCHAR(20)')                                                                                               AS LOC_JET2,
        --X.R.value('(Agency/Agent)[1]', 'VARCHAR(20)')                                                                                     AS Ref_Age_JET2,
        X.R.value('(Data/Status)[1]', 'VARCHAR(10)')                                                                                        AS Estado_Reserva_JET2,
        X.R.value('(Data/ReservationDate)[1]', 'DATETIME')                                                                                  AS ReservationDate_JET2,
        CAST(DATEDIFF(MINUTE, X.R.value('(Data/ReservationDate)[1]', 'DATETIME'), GETDATE()) / 1440 AS VARCHAR) + ' días ' +
   		CAST((DATEDIFF(MINUTE, X.R.value('(Data/ReservationDate)[1]', 'DATETIME'), GETDATE()) % 1440) / 60 AS VARCHAR) + ' horas ' +
   		CAST(DATEDIFF(MINUTE, X.R.value('(Data/ReservationDate)[1]', 'DATETIME'), GETDATE()) % 60 AS VARCHAR) + ' minutos'                  AS DifereceTime_CreationJET2_NOW,
		CAST(DATEDIFF(MINUTE, XUD.FECHA_ULTIMA_DESCARGA, GETDATE()) / 1440 AS VARCHAR) + ' días ' +
   		CAST((DATEDIFF(MINUTE, XUD.FECHA_ULTIMA_DESCARGA, GETDATE()) % 1440) / 60 AS VARCHAR) + ' horas ' +
   		CAST(DATEDIFF(MINUTE, XUD.FECHA_ULTIMA_DESCARGA, GETDATE()) % 60 AS VARCHAR) + ' minutos'				                            AS DifereceTime_LastRead_NOW,
	    X.R.value('(Data/LastModificationDate)[1]', 'DATETIME')			                                                                    AS [LastModificationDate_JET2],
        --X.R.value('(Data/TimeZone)[1]', 'VARCHAR(10)')		                                                                            AS [TimeZone_JET2],

        --SE.S.value('@Id','BIGINT')                                                                                                        AS Id_LRE_JET2,

        SE.S.value('(./Status/text())[1]', 'VARCHAR(10)')                                                                                   AS Estado_Linea_JET2,
        SE.S.value('@Start','DATE')                                                                                                         AS CheckIn,
        SE.S.value('@End','DATE')                                                                                                           AS CheckOut,
        SE.S.value('(Prices/Cost/@Amount)[1]', 'FLOAT')                                                                                     AS Cost_Amount
        --X.R.query('.')                                                                                                                    AS Reservation,
        --SE.S.query('.')                                                                                                                   AS ServiceElement
    FROM    
                XML_ULTIMA_DESCARGA XUD
    OUTER APPLY XUD.XMLRS.nodes('/ReadServiceResponseReadRS/Reservations/Reservation') X(R)
    OUTER APPLY R.nodes('Elements/ServiceElement') SE(S)
    WHERE
        1 = 1
        AND (R.value('@Locator','VARCHAR(20)') = XUD.LOC_JET2 OR R.value('@Locator','VARCHAR(20)') IS NULL)
        AND (SE.S.value('@Id','BIGINT') = XUD.Id_LRE_JET2 OR SE.S.value('@Id','BIGINT') IS NULL)
),

RESERVAS_JET2HOLIDAYSONLINE AS (
    SELECT
        R.Id_Res,
        R.Res_Localizador,
        CONCAT (R.Res_Nombre, R.Res_Apellidos) AS Titular,
        R.Res_ReferenciaAgencia,
        R.Res_Estado,
        LR.Id_LRe,
        LR.LRe_Tipo,
        LR.LRe_CupoAsignado,
        LR.LRe_ExtLocalizador,
        LR.Lre_localizadorExternoCliente,
        LR.LRe_Cancelada
    FROM
                Tbl_Reserva R
    LEFT JOIN   Tbl_LineaReserva LR ON LR.Id_Res = R.Id_Res
    WHERE
        R.Id_Age = 5017
        AND LR.LRe_Tipo = 'AVT'
),

RESERVA_JET2_VS_W2M AS(
    SELECT
        *
    FROM
                DESGLOSE_XML_ULTIMA_DESCARGA DXUD
    LEFT JOIN   RESERVAS_JET2HOLIDAYSONLINE RJET2HO ON RJET2HO.Lre_localizadorExternoCliente = DXUD.FULL_LOC_JET2
)

SELECT
    CASE
        WHEN LOC_JET2 IN ('1WNY3H','HRLMK4','922B9V','NRXKG6')
        THEN 'REVISADAS_PENDIENTES'
        WHEN (Estado_Reserva_JET2 <> 'CN' AND Estado_Linea_JET2 <> 'CN' AND (Res_Estado NOT IN ('Pag','Can','CaC') OR  Id_Res IS NULL))
        THEN 'INCONSISTENCIAS'
        ELSE 'OK'
    END AS ESTADO_IMPORTACION,
    * 
FROM 
    RESERVA_JET2_VS_W2M 
WHERE 
    1 = 1
    --AND Id_Res IS NULL --> SIN LOCALIZADOR JUNIPER
    --AND LRe_ExtLocalizador IS NULL --> SIN LOCALIZADOR AVT
    --AND ReservationDate_JET2 IS NULL --> SIN XML DE DESCARGA
    --AND LOC_JET2 = 'R5YDN5' --> Duplicidad Linea en W2M por Rebook de Mize

    --AND (Estado_Reserva_JET2 <> 'CN' 
    --    AND Estado_Linea_JET2 <> 'CN'
    --    AND (Res_Estado NOT IN ('Pag','Can','CaC') OR  Id_Res IS NULL))

    --OR  (LOC_JET2 IN (
    --                'T7NTWX',
    --                'J3C3P5'
    --                ))
    AND Ref_Age_JET2 = '20982444/S26H'

ORDER BY
    FULL_LOC_JET2 DESC