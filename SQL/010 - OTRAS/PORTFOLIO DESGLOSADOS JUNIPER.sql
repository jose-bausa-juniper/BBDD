USE BD_BookingEngine;
DECLARE @GPD_COD varchar(10); SET @GPD_COD = 'DYS';

SELECT 
	GPDA.Gpd_Cod,
	Gpd_Nombre,
	AE.NUM
FROM 
				(SELECT Gpd_Cod,Gpd_Prov,Gpd_Nombre	
				FROM Tbl_GrupoProductoDesglosadoAlojamiento
				WHERE Gpd_Prov = @GPD_COD)	GPDA

	LEFT JOIN	(SELECT AlE_Prov, COUNT(Ale_Cod) AS NUM
				FROM Tbl_AlojamientoExterno 
				WHERE 
					1 = 1 
					AND ALU_JPCode IS NULL 
					AND AlE_Prov IN	
								(SELECT Gpd_Cod
								FROM Tbl_GrupoProductoDesglosadoAlojamiento
								WHERE Gpd_Prov = @GPD_COD)
				GROUP BY AlE_Prov)	AE		
	ON AE.AlE_Prov = GPDA.Gpd_Cod