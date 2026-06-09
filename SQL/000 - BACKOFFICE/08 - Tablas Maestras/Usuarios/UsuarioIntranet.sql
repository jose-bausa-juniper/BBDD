------------- No Migrados a AD -------------
SELECT
	COUNT(*) AS [No Migrados a AD]
	--A.Id_Adm,
	--A.Adm_Nombre,
	--AE.Adm_EmailSeguridad,
	--A.Adm_Login
FROM
				Tbl_Administrador			A
	INNER JOIN	Tbl_AdministradorExtendido	AE	ON A.Id_Adm = AE.Id_Adm
	LEFT JOIN	Tbl_UsuarioLoginExterno		ULE	ON ULE.ULE_IdUsuario = A.Id_Adm
WHERE
	1 = 1
	AND A.Adm_Activo = 1
	AND ULE.ULE_IdUsuario IS NULL

------------- Migrados a AD -------------
SELECT
	COUNT(*) AS [Migrados a AD]
	--ULE.ULE_IdUsuario,
	--ULE.ULE_IdUsuarioExterno,
	--A.Adm_Nombre,
	--A.Adm_Login
FROM
				Tbl_Administrador			A
	INNER JOIN	Tbl_AdministradorExtendido	AE	ON A.Id_Adm = AE.Id_Adm
	INNER JOIN	Tbl_UsuarioLoginExterno		ULE	ON ULE.ULE_IdUsuario = A.Id_Adm
WHERE
	1 = 1
	AND A.Adm_Activo = 1

------------- Migrados a AD y han Accedido -------------
SELECT
	COUNT(*) AS [Migrados a AD y Han Accedido]
	--ULE.ULE_IdUsuario,
	--ULE.ULE_IdUsuarioExterno,
	--A.Adm_Nombre,
	--A.Adm_Login
FROM
				Tbl_Administrador			A
	INNER JOIN	Tbl_AdministradorExtendido	AE	ON A.Id_Adm = AE.Id_Adm
	INNER JOIN	Tbl_UsuarioLoginExterno		ULE	ON ULE.ULE_IdUsuario = A.Id_Adm
WHERE
	1 = 1
	AND A.Adm_Activo = 1
	AND ULE.ULE_IdUsuarioExterno <> '*'

------------- Migrados a AD y no han Accedido -------------
SELECT
	COUNT(*) AS [Migrados a AD y No Han Accedido]
	--ULE.ULE_IdUsuario,
	--ULE.ULE_IdUsuarioExterno,
	--A.Adm_Nombre,
	--A.Adm_Login
FROM
				Tbl_Administrador			A
	INNER JOIN	Tbl_AdministradorExtendido	AE	ON A.Id_Adm = AE.Id_Adm
	INNER JOIN	Tbl_UsuarioLoginExterno		ULE	ON ULE.ULE_IdUsuario = A.Id_Adm
WHERE
	1 = 1
	AND A.Adm_Activo = 1
	AND ULE.ULE_IdUsuarioExterno = '*'