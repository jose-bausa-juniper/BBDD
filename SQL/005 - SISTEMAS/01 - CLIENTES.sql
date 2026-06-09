SELECT 
	BD.Id_BDD AS BBDD,
	BD.BDD_Empresa AS EMPRESA
FROM 
	BD_BookingEngine.dbo.Tbl_BaseDatos BD
	LEFT JOIN BD_BookingEngine.dbo.Tbl_Web W ON W.id_BDD = BD.Id_BDD
GROUP BY 
	BD.ID_BDD,
	BD.BDD_Empresa