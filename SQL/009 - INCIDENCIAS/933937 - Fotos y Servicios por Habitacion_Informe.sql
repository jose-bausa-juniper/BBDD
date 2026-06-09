USE BD_Nincoming;

--	Imagenes por Hotel (262263 Imagenes de Alojamiento)
----------------------------------------------
SELECT 
	a.Id_alo		AS [ID_Alojamiento],
	ina.IAl_Nombre	AS [Nombre Alojamiento],
	a.Alo_DirFoto	AS [Alo_DirFoto],
	ia.ImA_Ruta		AS [Imagen]
FROM 
				Tbl_ImagenesAlojamiento		ia
	INNER JOIN	Tbl_Alojamiento				a		ON ia.Id_alo=a.Id_Alo
	INNER JOIN	Tbl_IDiNAlo					ina		ON a.Id_Alo = ina.Id_Alo AND ina.Id_Idi = 'ES'
ORDER BY
	a.Id_Alo

--	Servicios de Habitación por Hotel (344631 Servicios de Alojamiento)
----------------------------------------------
SELECT 
	a.Id_alo		AS [ID_Alojamiento],
	ina.IAl_Nombre	AS [Nombre Alojamiento],
	ans.Id_Ser		AS [ID_Servicio],
	ins.ISe_Nombre	AS [Servicio]
FROM 
				Tbl_Alojamiento			a
	INNER JOIN	Tbl_IDiNAlo				ina	ON a.Id_Alo = ina.Id_Alo AND ina.Id_Idi = 'ES'
	INNER JOIN	Tbl_AloNSer				ans	ON a.Id_Alo = ans.Id_Alo
	INNER JOIN	Tbl_Servicio			s	ON ans.Id_Ser = s.Id_Ser AND s.Ser_Tipo = 'H'
	INNER JOIN	Tbl_IDiNser				ins	ON ins.Id_Ser = ans.Id_Ser AND ins.Id_Idi = 'ES'
ORDER BY
	a.Id_Alo

--	Imagenes por habitación (39 Habitaciones - 67 Imagenes de Habitación)
----------------------------------------------
SELECT 
    A.Id_Alo,
	INA.IAl_Nombre		AS [Nombre Alojamiento],
	ANH.Id_Tha			AS [ID Tipo Habitación],
	INH.ITH_Nombre		AS [Nombre Tipo Habitación],
	value				AS [Imagen_de_Habitacion]
FROM 
                Tbl_AloNTHa				ANH		CROSS APPLY STRING_SPLIT (ANH.ANT_Fotos, '?')
    INNER JOIN  Tbl_Alojamiento			A		ON ANH.Id_Alo = A.Id_Alo
	INNER JOIN	Tbl_IDiNAlo				INA		ON INA.Id_Alo = A.Id_Alo AND INA.Id_Idi = 'ES'
	INNER JOIN	Tbl_IdiNTHa				INH		ON ANH.id_tha = INH.Id_THa AND INH.Id_Idi = 'ES'
ORDER BY
	a.Id_Alo,
	ANH.Id_Tha

--	Servicios por habitación (54261 Habitaciones - 657607 Servicios de Habitación)
----------------------------------------------
SELECT
	A.Id_Alo			AS [ID Alojamiento],
	INA.IAl_Nombre		AS [Nombre Alojamiento],
	ASH.Id_Tha			AS [ID Tipo Habitación],
	INTh.ITH_Nombre		AS [Nombre Tipo Habitación],
	INS.ISe_Nombre		AS [Servicios_de_Habitacion]
FROM 
				Tbl_Alojamiento			A
	INNER JOIN	Tbl_AloNSerTha			ASH		ON ASH.Id_Alo = A.Id_Alo
	INNER JOIN	Tbl_Servicio			S		ON S.Id_Ser = ASH.Id_Ser 
	INNER JOIN	Tbl_IDiNAlo				INA		ON INA.Id_Alo = A.Id_Alo AND INA.Id_Idi = 'ES'
	INNER JOIN	Tbl_IDiNser				INS		ON INS.Id_Ser = S.Id_Ser AND INS.Id_Idi = 'ES'
	INNER JOIN	Tbl_IdiNTHa				INTh	ON INTh.Id_THa = ASH.Id_Tha AND INTh.Id_Idi = 'ES'
WHERE 1 = 1
	AND INA.IAl_Act = 1
	AND a.Alo_borrado = 0
ORDER BY 
	A.Id_Alo,
	ASH.Id_Tha