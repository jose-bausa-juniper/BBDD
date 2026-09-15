
WITH RECUENTO_DE_COLAS AS (
            SELECT '01' AS [Queue], DATEADD(MINUTE,(DATEDIFF(MINUTE, 0, FecCre) / 15) * 15,0) AS [Time Slot], SPQ_Status, SPQ_DataType, COUNT(Id_SPQ) AS [Count] FROM Tbl_AlojaSupplierPushQueue_01 WITH (NOLOCK) GROUP BY DATEADD(MINUTE,(DATEDIFF(MINUTE, 0, FecCre) / 15) * 15,0), SPQ_Status, SPQ_DataType
UNION ALL   SELECT '02' AS [Queue], DATEADD(MINUTE,(DATEDIFF(MINUTE, 0, FecCre) / 15) * 15,0) AS [Time Slot], SPQ_Status, SPQ_DataType, COUNT(Id_SPQ) AS [Count] FROM Tbl_AlojaSupplierPushQueue_02 WITH (NOLOCK) GROUP BY DATEADD(MINUTE,(DATEDIFF(MINUTE, 0, FecCre) / 15) * 15,0), SPQ_Status, SPQ_DataType
UNION ALL   SELECT '03' AS [Queue], DATEADD(MINUTE,(DATEDIFF(MINUTE, 0, FecCre) / 15) * 15,0) AS [Time Slot], SPQ_Status, SPQ_DataType, COUNT(Id_SPQ) AS [Count] FROM Tbl_AlojaSupplierPushQueue_03 WITH (NOLOCK) GROUP BY DATEADD(MINUTE,(DATEDIFF(MINUTE, 0, FecCre) / 15) * 15,0), SPQ_Status, SPQ_DataType
UNION ALL   SELECT '04' AS [Queue], DATEADD(MINUTE,(DATEDIFF(MINUTE, 0, FecCre) / 15) * 15,0) AS [Time Slot], SPQ_Status, SPQ_DataType, COUNT(Id_SPQ) AS [Count] FROM Tbl_AlojaSupplierPushQueue_04 WITH (NOLOCK) GROUP BY DATEADD(MINUTE,(DATEDIFF(MINUTE, 0, FecCre) / 15) * 15,0), SPQ_Status, SPQ_DataType
UNION ALL   SELECT '05' AS [Queue], DATEADD(MINUTE,(DATEDIFF(MINUTE, 0, FecCre) / 15) * 15,0) AS [Time Slot], SPQ_Status, SPQ_DataType, COUNT(Id_SPQ) AS [Count] FROM Tbl_AlojaSupplierPushQueue_05 WITH (NOLOCK) GROUP BY DATEADD(MINUTE,(DATEDIFF(MINUTE, 0, FecCre) / 15) * 15,0), SPQ_Status, SPQ_DataType
UNION ALL   SELECT '06' AS [Queue], DATEADD(MINUTE,(DATEDIFF(MINUTE, 0, FecCre) / 15) * 15,0) AS [Time Slot], SPQ_Status, SPQ_DataType, COUNT(Id_SPQ) AS [Count] FROM Tbl_AlojaSupplierPushQueue_06 WITH (NOLOCK) GROUP BY DATEADD(MINUTE,(DATEDIFF(MINUTE, 0, FecCre) / 15) * 15,0), SPQ_Status, SPQ_DataType
UNION ALL   SELECT '07' AS [Queue], DATEADD(MINUTE,(DATEDIFF(MINUTE, 0, FecCre) / 15) * 15,0) AS [Time Slot], SPQ_Status, SPQ_DataType, COUNT(Id_SPQ) AS [Count] FROM Tbl_AlojaSupplierPushQueue_07 WITH (NOLOCK) GROUP BY DATEADD(MINUTE,(DATEDIFF(MINUTE, 0, FecCre) / 15) * 15,0), SPQ_Status, SPQ_DataType
UNION ALL   SELECT '08' AS [Queue], DATEADD(MINUTE,(DATEDIFF(MINUTE, 0, FecCre) / 15) * 15,0) AS [Time Slot], SPQ_Status, SPQ_DataType, COUNT(Id_SPQ) AS [Count] FROM Tbl_AlojaSupplierPushQueue_08 WITH (NOLOCK) GROUP BY DATEADD(MINUTE,(DATEDIFF(MINUTE, 0, FecCre) / 15) * 15,0), SPQ_Status, SPQ_DataType
UNION ALL   SELECT '09' AS [Queue], DATEADD(MINUTE,(DATEDIFF(MINUTE, 0, FecCre) / 15) * 15,0) AS [Time Slot], SPQ_Status, SPQ_DataType, COUNT(Id_SPQ) AS [Count] FROM Tbl_AlojaSupplierPushQueue_09 WITH (NOLOCK) GROUP BY DATEADD(MINUTE,(DATEDIFF(MINUTE, 0, FecCre) / 15) * 15,0), SPQ_Status, SPQ_DataType
UNION ALL   SELECT '10' AS [Queue], DATEADD(MINUTE,(DATEDIFF(MINUTE, 0, FecCre) / 15) * 15,0) AS [Time Slot], SPQ_Status, SPQ_DataType, COUNT(Id_SPQ) AS [Count] FROM Tbl_AlojaSupplierPushQueue_10 WITH (NOLOCK) GROUP BY DATEADD(MINUTE,(DATEDIFF(MINUTE, 0, FecCre) / 15) * 15,0), SPQ_Status, SPQ_DataType
)
SELECT
    [Queue],
    CASE SPQ_Status
        WHEN 0 THEN 'Pending'
        WHEN 1 THEN 'Processing'
        WHEN 2 THEN 'Done'
        WHEN 3 THEN 'Error'
        ELSE 'Desconocido (' + CAST(SPQ_Status AS varchar(10)) + ')'
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
    [Time Slot],
    [Count]
FROM RECUENTO_DE_COLAS