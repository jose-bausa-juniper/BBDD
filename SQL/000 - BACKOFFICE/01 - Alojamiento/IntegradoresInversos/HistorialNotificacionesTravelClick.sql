------------------------------------------------------------
-- DECLARACIÓN Y RELLENO DEL @XMLS
------------------------------------------------------------
DECLARE @XMLS TABLE (
    Id_Res int,
    Id_Lre int,
    id_int int,
    lre_preciocoste money,
    LRe_MonedaCoste nvarchar(10),
    Nre_Request XML,
    Nre_Response XML,
    Nre_ResponseErrors XML,
    Nre_InternalErrors XML
);

INSERT INTO @XMLS
SELECT 
    NR.Id_Res,
    NR.Id_Lre,
    NR.Id_int,
    LR.lre_preciocoste,
    LR.LRe_MonedaCoste,
    CAST(DECOMPRESS(Nre_Request) AS XML)         AS Nre_Request,
    CAST(DECOMPRESS(Nre_Response) AS XML)        AS Nre_Response,
    CAST(DECOMPRESS(Nre_ResponseErrors) AS XML)  AS Nre_ResponseErrors,
    CAST(DECOMPRESS(Nre_InternalErrors) AS XML)  AS Nre_InternalErrors
FROM Tbl_NotificacionReservas NR
LEFT JOIN Tbl_LineaReserva LR ON LR.Id_LRe = NR.Id_Lre
WHERE NR.id_int = 347
  AND NR.FecCre BETWEEN '2026-02-20 00:00:00.000' AND '2026-02-26 00:00:00.000'
  --AND id_res = 28322237;


------------------------------------------------------------
-- SELECT FINAL: RQ + RS (con BasicPropertyInfo)
------------------------------------------------------------
;WITH XMLNAMESPACES ('http://www.opentravel.org/OTA/2003/05' AS ns)
SELECT  
    DISTINCT
    x.Id_Res,
    x.Id_Lre,
    x.id_int,
    x.lre_preciocoste,
    x.LRe_MonedaCoste,
    -------------------------------------------------------
    -- REQUEST (RQ)
    -------------------------------------------------------
    rq.value('@Version',     'VARCHAR(50)')           AS RQ_Version,
    rq.value('@TimeStamp',   'DATETIMEOFFSET')        AS RQ_TimeStamp,
    rq.value('(ns:HotelReservations/ns:HotelReservation/@ResStatus)[1]', 'VARCHAR(50)') AS RQ_ResStatus,

    -- BasicPropertyInfo
    bp.value('@HotelCode',    'VARCHAR(50)')          AS RQ_HotelCode,

    -- Total
    tl.value('@AmountAfterTax','MONEY')             AS RQ_AmountAfterTax,
    tl.value('@CurrencyCode','nvarchar(10)')          AS RQ_CurrencyCode,



    -------------------------------------------------------
    -- RESPONSE (RS)
    -------------------------------------------------------
    er.value('@Type',         'INT')                  AS RS_Err_Type,
    er.value('@Code',         'INT')                  AS RS_Err_Code,
    er.value('@ShortText',    'VARCHAR(200)')         AS RS_Err_ShortText,
    er.value('text()[1]',     'VARCHAR(500)')         AS RS_Err_Message

FROM @XMLS AS x

-- RQ root
CROSS APPLY x.Nre_Request.nodes('/ns:OTA_HotelResNotifRQ') AS rq(rq)

-- RQ BasicPropertyInfo
OUTER APPLY x.Nre_Request.nodes(
        '/ns:OTA_HotelResNotifRQ
         /ns:HotelReservations
         /ns:HotelReservation
         /ns:RoomStays
         /ns:RoomStay
         /ns:BasicPropertyInfo'
     ) AS b(bp)
-- RQ Total 
OUTER APPLY x.Nre_Request.nodes(
        '/ns:OTA_HotelResNotifRQ
         /ns:HotelReservations
         /ns:HotelReservation
         /ns:RoomStays
         /ns:RoomStay
         /ns:Total'
     ) AS t(tl)
-- RS errores
OUTER APPLY x.Nre_Response.nodes(
        '/ns:OTA_HotelResNotifRS/ns:Errors/ns:Error'
     ) AS e(er)
     
     
WHERE  
1 = 1
--AND rq.value('(ns:HotelReservations/ns:HotelReservation/@ResStatus)[1]', 'VARCHAR(50)') = 'modify'
--AND er.value('@ShortText',    'VARCHAR(200)') = 'Hotel ID does not exist'
--AND er.value('@ShortText',    'VARCHAR(200)') = 'Service Unavailable - Please try again later'   
--AND bp.value('@HotelCode',    'VARCHAR(50)') LIKE '%|%'
--AND bp.value('@HotelCode',    'VARCHAR(50)') LIKE 'JP%'

ORDER BY 
RQ_TimeStamp DESC
;