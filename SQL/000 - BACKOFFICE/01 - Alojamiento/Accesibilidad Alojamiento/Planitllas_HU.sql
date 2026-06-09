USE BD_Nincoming
SELECT 
	* 
FROM 
	Tbl_PlantillaDeCliente 
WHERE 
	1 = 1
	--AND (Id_cli = @id_cli AND Id_can = @id_can) or (id_cli = -1 and Id_can = @id_can) or (id_cli = @id_cli and id_can is null) or (id_cli = -1 and Id_can is null)
	AND id_cli = -1