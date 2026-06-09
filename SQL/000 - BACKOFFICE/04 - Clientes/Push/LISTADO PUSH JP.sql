--LISTADO PUSH V2--
USE BD_Nincoming

SELECT 
CCWSR.Id_Cws,
C.Id_Cli AS Id_Cli,
C.Fecmod,
C.Cli_Nombre AS Cliente,
C.Cli_Activa AS Cli_Activa,
IWS.Int_Nombre AS Integrador,
CCR.Cli_WSRates AS Push_Activo,
CCR.Cli_WSRatesTipo AS Tipo_Push,
CCR.Cli_WSRatesCompresionFicheros AS Compresion,
CCR.Cli_WSRatesCarpetaUnica AS Carpeta_Unica,
CCR.Cli_WSRatesMaxCupo AS "MaxCupo",
CCR.Cli_WSRatesContratoCompraEnFichero AS CCo_En_Fichero,
CASE
    WHEN CCWSR.cws_tipo = 0 THEN 'FULL'
    WHEN CCWSR.cws_tipo = 1 THEN 'DELTA'
END AS Tipo,
CCWSR.Cws_hora AS Hora,
CCWSR.Cws_dias AS Dias
--CCRNIE.Id_Idi AS Idioma

FROM Tbl_Cliente C 
INNER JOIN Tbl_ClienteConfigRates CCR ON C.Id_Cli = CCR.Id_Cli
FULL JOIN Tbl_ClienteConfigRatesNIdiomasExportacion CCRNIE ON CCR.id_Ccr = CCRNIE.id_Ccr
FULL JOIN Tbl_ClienteConfWSRates CCWSR ON CCR.Id_Cli = CCWSR.Id_Cli
LEFT JOIN Tbl_IntegradorWS IWS ON C.id_int = IWS.id_int

WHERE 1=1
--AND C.Cli_Activa = 0
AND CCR.Cli_WSRates = 1
--AND IWS.Int_Nombre = 'TUI Group'
--AND c.Id_Cli = 16664

GROUP BY
CCWSR.Id_Cws,
C.Id_Cli,
C.Fecmod,

C.Cli_Nombre,
C.Cli_Activa,
IWS.Int_Nombre,
CCR.Cli_WSRates,
CCR.Cli_WSRatesTipo,
CCR.Cli_WSRatesCompresionFicheros,
CCR.Cli_WSRatesCarpetaUnica,
CCR.Cli_WSRatesMaxCupo,
CCR.Cli_WSRatesContratoCompraEnFichero,
CCWSR.cws_tipo,
CCWSR.Cws_hora,
CCWSR.Cws_dias

ORDER BY CCWSR.Cws_hora ASC


