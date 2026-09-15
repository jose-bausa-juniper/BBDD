WITH NOT_DONE_COLAS AS (
            SELECT '01' AS [Queue],Id_SPQ,SPQ_Status,SPQ_DataType,FecCre FROM Tbl_AlojaSupplierPushQueue_01 WITH (NOLOCK) WHERE SPQ_Status <> 2 
UNION ALL   SELECT '02' AS [Queue],Id_SPQ,SPQ_Status,SPQ_DataType,FecCre FROM Tbl_AlojaSupplierPushQueue_02 WITH (NOLOCK) WHERE SPQ_Status <> 2 
UNION ALL   SELECT '03' AS [Queue],Id_SPQ,SPQ_Status,SPQ_DataType,FecCre FROM Tbl_AlojaSupplierPushQueue_03 WITH (NOLOCK) WHERE SPQ_Status <> 2 
UNION ALL   SELECT '04' AS [Queue],Id_SPQ,SPQ_Status,SPQ_DataType,FecCre FROM Tbl_AlojaSupplierPushQueue_04 WITH (NOLOCK) WHERE SPQ_Status <> 2 
UNION ALL   SELECT '05' AS [Queue],Id_SPQ,SPQ_Status,SPQ_DataType,FecCre FROM Tbl_AlojaSupplierPushQueue_05 WITH (NOLOCK) WHERE SPQ_Status <> 2 
UNION ALL   SELECT '06' AS [Queue],Id_SPQ,SPQ_Status,SPQ_DataType,FecCre FROM Tbl_AlojaSupplierPushQueue_06 WITH (NOLOCK) WHERE SPQ_Status <> 2 
UNION ALL   SELECT '07' AS [Queue],Id_SPQ,SPQ_Status,SPQ_DataType,FecCre FROM Tbl_AlojaSupplierPushQueue_07 WITH (NOLOCK) WHERE SPQ_Status <> 2 
UNION ALL   SELECT '08' AS [Queue],Id_SPQ,SPQ_Status,SPQ_DataType,FecCre FROM Tbl_AlojaSupplierPushQueue_08 WITH (NOLOCK) WHERE SPQ_Status <> 2 
UNION ALL   SELECT '09' AS [Queue],Id_SPQ,SPQ_Status,SPQ_DataType,FecCre FROM Tbl_AlojaSupplierPushQueue_09 WITH (NOLOCK) WHERE SPQ_Status <> 2 
UNION ALL   SELECT '10' AS [Queue],Id_SPQ,SPQ_Status,SPQ_DataType,FecCre FROM Tbl_AlojaSupplierPushQueue_10 WITH (NOLOCK) WHERE SPQ_Status <> 2 
)
SELECT 
    [Queue],
    Id_SPQ,
    CASE SPQ_Status
        WHEN 0 THEN 'Pending'
        WHEN 1 THEN 'Processing'
        WHEN 2 THEN 'Done'
        WHEN 3 THEN 'Error'
    END AS [Estado],
    CASE SPQ_DataType
        WHEN 0 THEN 'Allotments'
        WHEN 1 THEN 'Rates'
        WHEN 2 THEN 'Restrictions'
        WHEN 3 THEN 'Supplements'
        WHEN 4 THEN 'Cancellations'
        WHEN 5 THEN 'DeleteARI'
        ELSE 'Desconocido (' + CAST(SPQ_DataType AS varchar(10)) + ')'
    END AS [DataType],
    FecCre
FROM NOT_DONE_COLAS


