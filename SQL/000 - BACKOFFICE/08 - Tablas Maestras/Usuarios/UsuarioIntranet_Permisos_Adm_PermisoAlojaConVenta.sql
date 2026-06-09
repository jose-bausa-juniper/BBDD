---- Adm_PermisoAlojaConVenta ADM y ROL ----
SELECT
	P.Per_Nombre,
	A.Id_Adm,
	A.Adm_Login,
	R.Id_Rol,
	R.Rol_Nombre,
	CASE AE.Adm_PermisoAlojaConVenta 
		WHEN 0 THEN 'NINGUNO'
		WHEN 1 THEN 'Edición'
		WHEN 2 THEN 'Solo Lectura'
	END AS [Permiso Cliente],
	CASE RP.Per_ValorActual
		WHEN NULL THEN 'NINGUNO'
		WHEN 'false' THEN 'Solo Lectura'
		WHEN 'true'	THEN 'Edicion'
	END AS [Permiso Rol],
	RP.Estado AS [Acceso Rol]
FROM
				Tbl_Administrador			A
	INNER JOIN	Tbl_AdministradorExtendido 	AE 	ON AE.Id_Adm = A.Id_Adm
	FULL JOIN	Tbl_RolUsuario				R	ON R.Id_Rol = A.Id_Rol
	FULL JOIN 	Tbl_RolUsuarioPermiso		RP 	ON ((RP.Id_Rol = R.Id_Rol) AND (RP.Id_Per IS NULL OR RP.Id_Per = 552))
	FULL JOIN 	Tbl_Permiso					P 	ON ((P.Id_Per = RP.Id_Per) AND (P.Id_Per IS NULL OR P.Id_Per = 552))
WHERE
	1 = 1
	AND A.Adm_Activo = 1
	AND A.Id_Rol IS NOT NULL
ORDER BY
	RP.Estado,
	RP.Per_ValorActual,
	AE.Adm_PermisoAlojaConVenta
