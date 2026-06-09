USE BD_SuppliersPush

--SELECT AlE_Cod, Ale_Prov
--FROM vwQlik_JP_Externos 
--WHERE 1 =1
--AND AlE_Prov in ('SY33')


SELECT COUNT(*)
FROM Tbl_AlojaSupplierPushElemento 
WHERE Id_SuP = 9
--AND SPE_CodHotel  = '37728'
--AND SPE_RatePlanCode = 'OPUDCG01'
--AND SPE_CodigoHabitacion = 'OF'

SELECT COUNT(*) AS CUPO
FROM Tbl_AlojaSupplierPushCupo
WHERE Id_SPE IN (
                SELECT Id_SPE 
                FROM Tbl_AlojaSupplierPushElemento 
                WHERE Id_SuP = 9
                --AND SPE_CodHotel IN (79260)
                --AND SPE_CodigoHabitacion IN ('FULL')
                ) 


SELECT COUNT(*) AS PRECIO
FROM Tbl_AlojaSupplierPushPrecio 
WHERE Id_SPE IN 
                (
                SELECT Id_SPE 
                FROM Tbl_AlojaSupplierPushElemento 
                WHERE Id_SuP = 9
    --            AND SPE_CodHotel = '79260'
				--AND SPE_RatePlanCode = 'OPUDCG01'
				--AND SPE_CodigoHabitacion = 'OF'
                )


SELECT COUNT(*) AS PRECIO_NIÑO
FROM Tbl_AlojaSupplierPushPrecioNino 
WHERE Id_SPP IN 
                (
                SELECT Id_SPP
                FROM Tbl_AlojaSupplierPushPrecio 
                WHERE Id_SPE IN 
                                (
                                SELECT Id_SPE 
                                FROM Tbl_AlojaSupplierPushElemento 
                                WHERE Id_SuP = 9
                                --AND SPE_CodHotel IN ('8883')
                                --AND SPE_CodigoHabitacion IN ('FULL')
                                )
                )

SELECT COUNT(*) AS RESTRICCIÓN
FROM Tbl_AlojaSupplierPushRestriccion
WHERE Id_SPE IN 
                (
                SELECT Id_SPE 
                FROM Tbl_AlojaSupplierPushElemento 
                WHERE Id_SuP = 9
                --AND SPE_CodHotel IN ('8883')
                --AND SPE_CodigoHabitacion IN ('FULL')
                )

SELECT COUNT(*) AS POLÍTICAS
FROM Tbl_AlojaSupplierPushPoliticaCancelacion 
WHERE Id_SPE IN 
                (
                SELECT Id_SPE 
                FROM Tbl_AlojaSupplierPushElemento 
                WHERE Id_SuP = 9
                --AND SPE_CodHotel IN ('8883')
                --AND SPE_CodigoHabitacion IN ('FULL')
                ) 

SELECT COUNT(*) AS POLÍTICAS_FECHAS 
FROM Tbl_AlojaSupplierPushPoliticaCancelacionFecha
WHERE Id_SPC IN (
				SELECT Id_SPC 
				FROM Tbl_AlojaSupplierPushPoliticaCancelacion 
				WHERE Id_SPE IN 
                                (
                                SELECT Id_SPE 
                                FROM Tbl_AlojaSupplierPushElemento 
                                WHERE Id_SuP = 9
                                --AND SPE_CodHotel IN ('8883')
                                --AND SPE_CodigoHabitacion IN ('FULL')
                                )
                )

SELECT COUNT(*) AS POLÍTICAS_REGLAS 
FROM Tbl_AlojaSupplierPushPoliticaCancelacionRegla
WHERE Id_SPC IN (
				SELECT Id_SPC 
				FROM Tbl_AlojaSupplierPushPoliticaCancelacion 
				WHERE Id_SPE IN 
                                (
                                SELECT Id_SPE 
                                FROM Tbl_AlojaSupplierPushElemento 
                                WHERE Id_SuP = 9
                                --AND SPE_CodHotel IN ('8883')
                                --AND SPE_CodigoHabitacion IN ('FULL')
                                ) 
				)