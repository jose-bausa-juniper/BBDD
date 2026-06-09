---- Ofuscar Password ADM y ROL ----
SELECT
	A.Id_Adm,
	A.Adm_Nombre,
	A.Adm_OfuscarPasswordsClientesHistorial AS [Por Cliente],
	R.Id_Rol,
	RP.Estado AS [Acceso Rol],
	RP.Per_ValorActual,
	P.Per_Nombre
FROM
				Tbl_Administrador			A
	INNER JOIN	Tbl_AdministradorExtendido 	AE 	ON AE.Id_Adm = A.Id_Adm
	FULL JOIN	Tbl_RolUsuario				R	ON R.Id_Rol = A.Id_Rol
	FULL JOIN 	Tbl_RolUsuarioPermiso		RP 	ON ((RP.Id_Rol = R.Id_Rol) AND (RP.Id_Per IS NULL OR RP.Id_Per = 181))
	FULL JOIN 	Tbl_Permiso					P 	ON ((P.Id_Per = RP.Id_Per) AND (P.Id_Per IS NULL OR P.Id_Per = 181))
WHERE
	1 = 1
	AND A.Adm_Activo = 1
ORDER BY
	A.Id_Rol

