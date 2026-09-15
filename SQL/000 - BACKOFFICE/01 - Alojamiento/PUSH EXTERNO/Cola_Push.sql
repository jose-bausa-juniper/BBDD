/*
    public enum QueueRecordStatus
    {
        Pending,
        Processing,
        Done,
        Error
    }
    CASE SPQ_Status
        WHEN 0 THEN 'Pending'
        WHEN 1 THEN 'Processing'
        WHEN 3 THEN 'Error'
    END AS [Estado]
*/
Select COUNT(*) from Tbl_AlojaSupplierPushQueue_01 where SPQ_Status <> 2
Select COUNT(*) from Tbl_AlojaSupplierPushQueue_02 where SPQ_Status <> 2
Select COUNT(*) from Tbl_AlojaSupplierPushQueue_03 where SPQ_Status <> 2
Select COUNT(*) from Tbl_AlojaSupplierPushQueue_04 where SPQ_Status <> 2
Select COUNT(*) from Tbl_AlojaSupplierPushQueue_05 where SPQ_Status <> 2
Select COUNT(*) from Tbl_AlojaSupplierPushQueue_06 where SPQ_Status <> 2
Select COUNT(*) from Tbl_AlojaSupplierPushQueue_07 where SPQ_Status <> 2
Select COUNT(*) from Tbl_AlojaSupplierPushQueue_08 where SPQ_Status <> 2
Select COUNT(*) from Tbl_AlojaSupplierPushQueue_09 where SPQ_Status <> 2
Select COUNT(*) from Tbl_AlojaSupplierPushQueue_10 where SPQ_Status <> 2
Select MAX(Feccre),COUNT(*) from Tbl_AlojaSupplierPushQueue_11 where SPQ_Status <> 2
Select MAX(Feccre),COUNT(*) from Tbl_AlojaSupplierPushQueue_12 where SPQ_Status <> 2
Select MAX(Feccre),COUNT(*) from Tbl_AlojaSupplierPushQueue_13 where SPQ_Status <> 2
Select MAX(Feccre),COUNT(*) from Tbl_AlojaSupplierPushQueue_14 where SPQ_Status <> 2
Select MAX(Feccre),COUNT(*) from Tbl_AlojaSupplierPushQueue_15 where SPQ_Status <> 2