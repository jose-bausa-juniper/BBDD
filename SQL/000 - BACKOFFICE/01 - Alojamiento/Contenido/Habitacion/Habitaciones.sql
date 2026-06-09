USE BD_Nincoming

SELECT
	A.Id_Alo,
	INA.IAl_Nombre,
	TH.Id_THa,
	ANT.id_Ant,
	INANT.IAN_Nombre,
	ANT.Id_Ant_Relacionada,
	ANT.Id_THa_Master
FROM
				BD_Nincoming.dbo.Tbl_Alojamiento		A
	INNER JOIN	BD_Nincoming.dbo.Tbl_IDiNAlo			INA		ON INA.Id_Alo = A.Id_Alo
	INNER JOIN	BD_Nincoming.dbo.Tbl_AloNTHa			ANT		ON ANT.Id_Alo = A.Id_Alo
	INNER JOIN	BD_Nincoming.dbo.Tbl_TipoHabitacion		TH		ON TH.Id_THa = ANT.Id_THa
	INNER JOIN	BD_Nincoming.dbo.Tbl_IDiNANT			INANT	ON INANT.Id_Ant = ANT.id_Ant
WHERE 
	1 = 1
	--AND A.Id_Alo = 20373
	AND A.Alo_borrado = 0
	AND INA.Id_Idi = 'ES'
	AND ANT.ANT_Eliminada = 0
	AND ANT.Ant_Activa = 1
	AND INANT.Id_Idi = 'ES'
ORDER BY
	TH.Id_THa,
	A.Id_Alo