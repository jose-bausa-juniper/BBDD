--SELECT * FROM vwQlik_JP_Externos WHERE AlE_Prov = 'BOK' AND AlE_Cod IN ('1011737','10010')


SELECT ID_PAE FROM Tbl_PlantillaAlojamientoExterno WHERE PAE_Prov = 'BOK'
SELECT ID_PAE FROM Tbl_PlantillaAlojamientoExterno WHERE PAE_Prov = 'EXR'
SELECT ID_PAE FROM Tbl_PlantillaAlojamientoExterno WHERE PAE_Prov = 'HB2'

SELECT COUNT(*) FROM vwQlik_JP_Externos WHERE AlE_Prov = 'BOK'
SELECT COUNT(*) FROM vwQlik_JP_Externos WHERE AlE_Prov = 'EXR'
SELECT COUNT(*) FROM vwQlik_JP_Externos WHERE AlE_Prov = 'HB2'

SELECT PAEH.PEH_CodigoHotel, JPE.ALU_JPCode 
FROM Tbl_PlantillaAlojamientoExternoHoteles  PAEH
LEFT JOIN vwQlik_JP_Externos JPE ON (JPE.AlE_Prov = 'PABR' AND PAEH.PEH_CodigoHotel = JPE.AlE_Cod)
WHERE 
1 = 1
AND Id_PAE IN (SELECT ID_PAE FROM Tbl_PlantillaAlojamientoExterno WHERE PAE_Prov = 'PABR')
--AND JPE.ALU_JPCode IS NULL

-- 9508 FICHAS EN PLANTILLA
-- 4748 FICHAS MAPEADA
-- 4760 FICHAS DESMAPEADA


SELECT PAEH.PEH_CodigoHotel, JPE.ALU_JPCode 
FROM Tbl_PlantillaAlojamientoExternoHoteles  PAEH
LEFT JOIN vwQlik_JP_Externos JPE ON (JPE.AlE_Prov = 'HB2' AND PAEH.PEH_CodigoHotel = JPE.AlE_Cod)
WHERE 
1 = 1
AND Id_PAE IN (SELECT ID_PAE FROM Tbl_PlantillaAlojamientoExterno WHERE PAE_Prov = 'HB2')
AND JPE.ALU_JPCode IS NOT NULL

-- 9508 FICHAS EN PLANTILLA
-- 4748 FICHAS MAPEADA
-- 4760 FICHAS DESMAPEADA


SELECT PAEH.PEH_CodigoHotel, JPE.ALU_JPCode 
FROM Tbl_PlantillaAlojamientoExternoHoteles  PAEH
LEFT JOIN vwQlik_JP_Externos JPE ON (JPE.AlE_Prov = 'EXR' AND PAEH.PEH_CodigoHotel = JPE.AlE_Cod)
WHERE 
1 = 1
AND Id_PAE IN (SELECT ID_PAE FROM Tbl_PlantillaAlojamientoExterno WHERE PAE_Prov = 'EXR')
AND JPE.ALU_JPCode IS NULL

-- 9508 FICHAS EN PLANTILLA
-- 4748 FICHAS MAPEADA
-- 4760 FICHAS DESMAPEADA