USE BD_Nincoming

SELECT  
	A.id_Adm,
	A.adm_nombre,
	A.adm_activo,
	A.adm_eliminado,
	A.fecha_ultimo_login,
	A.Adm_FechaCaducidad,
	A.adm_login,
	AE.Adm_EmailSeguridad,
	CASE 
		WHEN ULE.ULE_SistemaExterno IS NULL THEN 'UserPassword'
		WHEN ULE.ULE_SistemaExterno =  '0'	THEN 'Unknown'
		WHEN ULE.ULE_SistemaExterno =  '1'	THEN 'Google'
		WHEN ULE.ULE_SistemaExterno =  '2'	THEN 'Facebook'
		WHEN ULE.ULE_SistemaExterno =  '3'	THEN 'CVC'
		WHEN ULE.ULE_SistemaExterno =  '4'	THEN 'SSOSAMLGoogle'
		WHEN ULE.ULE_SistemaExterno =  '5'	THEN 'OAuth2Google'
		WHEN ULE.ULE_SistemaExterno =  '6'	THEN 'OAuth2Keycloak'
		WHEN ULE.ULE_SistemaExterno =  '7'	THEN 'OAuth2Azure'
		ELSE CAST(ULE.ULE_SistemaExterno AS VARCHAR(MAX))
	END							AS tipoLogin
FROM 
				Tbl_Administrador			A
	LEFT JOIN   Tbl_AdministradorExtendido	AE  ON  A.id_adm  = Ae.Id_Adm
	LEFT JOIN   Tbl_UsuarioLoginExterno		ULE ON	A.id_Adm = ule.ULE_IdUsuario
WHERE 
	1 = 1
	AND (A.Adm_FechaCaducidad < GETDATE() OR A.Adm_FechaCaducidad IS NULL)
	--AND	ULE.ULE_SistemaExterno IS NULL
	AND	ULE.ULE_SistemaExterno = 7
	--AND A.Id_Adm IN (2555,3757,2558)


