USE  BD_Nincoming
-------------------------------------------------------------
SELECT
	* 
FROM
	Tbl_IntegradorWS 
WHERE
	1 = 1
	AND Int_Nombre like '%siteminder%'
	--AND Id_Int = 347
-------------------------------------------------------------
SELECT
	Id_UsE
FROM
	Tbl_UsuarioExtranet
WHERE 
	1 = 1
	AND Id_Int = 111
-------------------------------------------------------------
SELECT 
	DISTINCT(UNA.Id_Alo),
	INA.IAl_Nombre,
	P.Pro_Nombre
FROM 
				Tbl_UsENAlo				UNA
	INNER JOIN	Tbl_IDiNAlo				INA	ON UNA.Id_Alo = INA.id_Alo AND INA.Id_Idi = 'es' AND INA.IAl_Act = 1
	INNER JOIN	Tbl_ReservaAlojamiento	RA	ON RA.Id_Alo = INA.id_Alo AND RA.Feccre > '2023-12-01 00:00:00'
	INNER JOIN	Tbl_Alojamiento			A	ON RA.Id_Alo = A.Id_Alo
	INNER JOIN	Tbl_Proveedor			P	ON P.Id_Pro = A.Id_Pro
WHERE 
	1 = 1
	AND UNA.Id_UsE IN	(
						SELECT 
							Id_UsE 
						FROM 
							Tbl_UsuarioExtranet 
						WHERE 
							Id_Int = 111
						)