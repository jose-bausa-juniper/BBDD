SET NOCOUNT ON;

DECLARE @IdSex   INT         = 57;
DECLARE @Prov    VARCHAR(10) = 'AVT';
DECLARE @NseTipo VARCHAR(30) = 'CONTRATO';

IF OBJECT_ID('tempdb..#Villas') IS NOT NULL DROP TABLE #Villas;
IF OBJECT_ID('tempdb..#LastExport') IS NOT NULL DROP TABLE #LastExport;
IF OBJECT_ID('tempdb..#TiposError') IS NOT NULL DROP TABLE #TiposError;


/* ============================================================
   1. Villas AVT
   Fuente:
   - BD_Nincoming.dbo.vwQlik_JP_Externos
   - Campos: AlE_Cod, AlE_Nombre, AlE_Prov
   ============================================================ */

SELECT
    CAST(V.AlE_Cod AS VARCHAR(50)) AS AVT,
    V.AlE_Nombre                   AS NOM
INTO #Villas
FROM BD_Nincoming.dbo.vwQlik_JP_Externos V
WHERE V.AlE_Prov = @Prov;

CREATE CLUSTERED INDEX IX_TMP_Villas_AVT
ON #Villas (AVT);


/* ============================================================
   2. Última exportación por hotel AVT
   Fuente:
   - BD_Nincoming_HIS.dbo.Tbl_ExportacionSistemaExterno
   - BD_Nincoming.dbo.Tbl_AlojaSupplierPushElemento

   Mejora:
   - Filtramos por Id_Sex y proveedor antes de llegar al XML.
   - Evitamos traer exportaciones antiguas.
   ============================================================ */

SELECT
    MAX(ESE.Id_Ese)     AS Id_Ese,
    SPE.SPE_CodHotel    AS AVT
INTO #LastExport
FROM BD_Nincoming_HIS.dbo.Tbl_ExportacionSistemaExterno ESE
INNER JOIN BD_Nincoming.dbo.Tbl_AlojaSupplierPushElemento SPE
    ON SPE.Id_SPE = ESE.Id_SPE
INNER JOIN #Villas V
    ON V.AVT = CAST(SPE.SPE_CodHotel AS VARCHAR(50))
WHERE
    ESE.Id_Sex = @IdSex
GROUP BY
    SPE.SPE_CodHotel;

CREATE CLUSTERED INDEX IX_TMP_LastExport_IdEse
ON #LastExport (Id_Ese);

CREATE NONCLUSTERED INDEX IX_TMP_LastExport_AVT
ON #LastExport (AVT);


/* ============================================================
   3. Agregamos los tipos de error por exportación
   Fuente:
   - BD_Nincoming_HIS.dbo.Tbl_ExportacionSistemaExternoErrores

   Mejora:
   - STRING_AGG se hace solo sobre los Id_Ese finales.
   - Evitamos que ESEE multiplique filas en la consulta principal.
   ============================================================ */

SELECT
    ESEE.Id_Ese,
    STRING_AGG(
        CASE ESEE.Eee_Tipo
            WHEN 0 THEN 'OK'
            WHEN 1 THEN 'WARNING'
            WHEN 2 THEN 'ERR'
            WHEN 3 THEN 'WRATE'
            WHEN 4 THEN 'WCONTRACT'
            WHEN 5 THEN 'WROOM'
            WHEN 6 THEN 'WOFFER'
            WHEN 7 THEN 'ERATE'
            WHEN 8 THEN 'EOFFER'
            WHEN 9 THEN 'EMAPP'
            ELSE CONCAT('UNKNOWN_', ESEE.Eee_Tipo)
        END,
        ', '
    ) AS [ESEE.Eee_Tipo]
INTO #TiposError
FROM BD_Nincoming_HIS.dbo.Tbl_ExportacionSistemaExternoErrores ESEE
INNER JOIN #LastExport LE
    ON LE.Id_Ese = ESEE.Id_Ese
GROUP BY
    ESEE.Id_Ese;

CREATE CLUSTERED INDEX IX_TMP_TiposError_IdEse
ON #TiposError (Id_Ese);


/* ============================================================
   4. Consulta final
   Fuentes:
   - #LastExport
   - #Villas
   - BD_Nincoming_HIS.dbo.Tbl_ExportacionSistemaExterno
   - BD_Nincoming.dbo.Tbl_AlojaSupplierPushElemento
   - BD_Nincoming_HIS.dbo.Tbl_NotificacionSistemaExterno

   Mejora principal:
   - DECOMPRESS + XML solo se ejecuta sobre las últimas exportaciones.
   - Se descomprime una sola vez por fila.
   - Ya no agrupamos por NSE.NSE_BinXmlErrores.
   ============================================================ */

SELECT 
*
--[V.AVT],
--[V.NOM],
--[NSE.AVISOS],
--[NSE.ERRORES]

FROM
(
    SELECT
        TE.[ESEE.Eee_Tipo]                                                AS [ESEE.Eee_Tipo],
        ESE.Ese_fecha                                                     AS [ESE.Ese_fecha],
        ESE.Ese_Error                                                     AS [ESE.Ese_Error],
        V.AVT                                                            AS [V.AVT],
        V.NOM                                                            AS [V.NOM],
        SPE.SPE_UltimaModificacion                                       AS [SPE.SPE_UltimaModificacion],
        SPE.SPE_GeneracionTarifario                                      AS [SPE.SPE_GeneracionTarifario],
        XMLDATA.XmlErrores.value('(/ErroresXML/ejecucion/errores)[1]',
                                 'varchar(max)')                         AS [NSE.ERRORES],
        XMLDATA.XmlErrores.value('(/ErroresXML/ejecucion/avisos)[1]',
                                 'varchar(max)')                         AS [NSE.AVISOS]
    FROM #LastExport LE
    INNER JOIN BD_Nincoming_HIS.dbo.Tbl_ExportacionSistemaExterno ESE
        ON ESE.Id_Ese = LE.Id_Ese
    INNER JOIN BD_Nincoming.dbo.Tbl_AlojaSupplierPushElemento SPE
        ON SPE.Id_SPE = ESE.Id_SPE
    INNER JOIN #Villas V
        ON V.AVT = CAST(SPE.SPE_CodHotel AS VARCHAR(50))
    LEFT JOIN #TiposError TE
        ON TE.Id_Ese = ESE.Id_Ese
    INNER JOIN BD_Nincoming_HIS.dbo.Tbl_NotificacionSistemaExterno NSE
        ON NSE.NSE_IdDreIdEse = ESE.Id_Ese
       AND NSE.NSE_Tipo = @NseTipo
    OUTER APPLY
    (
        SELECT
            CAST(DECOMPRESS(NSE.NSE_BinXmlErrores) AS XML) AS XmlErrores
    ) XMLDATA
    WHERE
        ESE.Id_Sex = @IdSex
) Q
WHERE
    1 = 1
ORDER BY
    Q.[V.NOM],
    Q.[ESE.Ese_fecha] DESC
OPTION (RECOMPILE);