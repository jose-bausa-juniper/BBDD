USE BD_Nincoming
SELECT 
A.Id_Adm					AS Id_Adm,
AE.Adm_PermisoAlojaImpuestos

FROM 
			Tbl_Administrador			A
INNER JOIN	Tbl_AdministradorExtendido	AE ON A.Id_Adm = AE.Id_Adm

WHERE 
	1 = 1
	AND A.Adm_Activo = 1

