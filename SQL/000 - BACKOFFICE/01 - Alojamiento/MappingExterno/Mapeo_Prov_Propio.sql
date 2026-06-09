--USE BD_BookingEngine

SELECT  * FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME LIKE '%PMS_id%'


SELECT DISTINCT (Sch_Prov), COUNT (*) FROM BD_Comun.dbo.Tbl_StaticDataCategoriaHabitacion GROUP BY Sch_Prov ORDER BY Sch_Prov





SELECT * FROM BD_Nincoming.dbo.mape WHERE SdC_Prov = 'AVT' AND Id_idi = 'es' ORDER BY SdC_Codigo


SELECT * FROM TBl_PMDs


Select * from Tbl_TipoAlojamiento


SELECT * FROM Tbl_SistemaExterno WHERE SEx_Cod = 'AVO'