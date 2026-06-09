------------------------------------------------------------
-- DECLARACIÓN Y RELLENO DEL @XMLS
------------------------------------------------------------
DECLARE @XMLS TABLE (
    Id_Res int,
    Id_Lre int,
    Id_int int,
    lre_preciocoste money,
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
    CAST(DECOMPRESS(Nre_Request) AS XML)         AS Nre_Request,
    CAST(DECOMPRESS(Nre_Response) AS XML)        AS Nre_Response,
    CAST(DECOMPRESS(Nre_ResponseErrors) AS XML)  AS Nre_ResponseErrors,
    CAST(DECOMPRESS(Nre_InternalErrors) AS XML)  AS Nre_InternalErrors
FROM Tbl_NotificacionReservas NR
LEFT JOIN Tbl_LineaReserva LR ON LR.Id_LRe = NR.Id_Lre
WHERE NR.id_int = 458
  AND NR.FecCre BETWEEN '2025-11-01 00:00:00.000' AND '2026-02-25 00:00:00.000'
  --AND id_res = 28322237;

------------------------------------------------------------
-- SELECT FINAL: GetBookingIdRQ + GetBookingIdRS
------------------------------------------------------------
SELECT
    x.Id_Res,
    x.Id_Lre,
    x.id_int,
    x.lre_preciocoste,

    ----------------------------------------------------------
    -- RQ: todos los nodos directos como columnas
    ----------------------------------------------------------
    rq.value('verb[1]',             'varchar(50)')     AS RQ_verb,
    rq.value('ota_property_id[1]',  'varchar(100)')    AS RQ_ota_property_id,
    rq.value('mya_property_id[1]',  'varchar(100)')    AS RQ_mya_property_id,
    rq.value('booking_id[1]',       'varchar(100)')    AS RQ_booking_id,
    rq.value('version[1]',          'varchar(50)')     AS RQ_version,

    ----------------------------------------------------------
    -- RS: nodos directos
    ----------------------------------------------------------
    rs_root.value('success[1]',           'varchar(10)')     AS RS_success,
    rs_root.value('booking_id[1]',        'varchar(100)')    AS RS_booking_id,
    rs_root.value('ota_property_id[1]',   'varchar(100)')    AS RS_ota_property_id,

    ----------------------------------------------------------
    -- RS.Booking: nodos internos
    ----------------------------------------------------------
    rs_booking.value('OrderId[1]',        'varchar(100)')    AS RS_OrderId,
    rs_booking.value('OrderDate[1]',      'varchar(50)')     AS RS_OrderDate,
    rs_booking.value('OrderTime[1]',      'varchar(50)')     AS RS_OrderTime,
    rs_booking.value('IsCancellation[1]', 'varchar(10)')     AS RS_IsCancellation,
    rs_booking.value('IsModification[1]', 'varchar(10)')     AS RS_IsModification,
    rs_booking.value('TotalPrice[1]',     'money')           AS TotalPrice

FROM @XMLS AS x

----------------------------------------------------------
-- RQ root
----------------------------------------------------------
CROSS APPLY x.Nre_Request.nodes('/GetBookingIdRQ') AS rq(rq)

----------------------------------------------------------
-- RS root
----------------------------------------------------------
OUTER APPLY x.Nre_Response.nodes('/GetBookingIdRS') AS rs(rs_root)

----------------------------------------------------------
-- RS.Booking (subnodo)
----------------------------------------------------------
OUTER APPLY x.Nre_Response.nodes('/GetBookingIdRS/Booking') AS rsb(rs_booking)

ORDER BY x.Id_Res DESC;