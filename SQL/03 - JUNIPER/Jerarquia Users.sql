SELECT 
	u.Id_usuari,
	u.U_nom,
	u.UsuIdDepartamento,
	d.D_nombre_ES,
	u.Id_GrU,
	gu.GrU_Nombre,
	u.id_eqp,
	e.Eqp_Nombre
FROM 
				USUARI			u
	LEFT JOIN	DEPARTAMENT		d	ON	d.D_id = u.UsuIdDepartamento
	LEFT JOIN	GRUPO_USUARIOS	gu	ON	gu.Id_GrU = u.Id_GrU
	LEFT JOIN	Tbl_Equipo		e	ON	e.Id_Eqp = u.id_eqp 
WHERE 
	1 = 1
	AND u.U_actiu = 1
	AND u.UsuIdDepartamento NOT IN (39,33,32,31,20,19)
	AND u.Id_GrU NOT IN (61)
	AND u.U_isReal <> 0
ORDER BY
	u.UsuIdDepartamento,
	u.Id_GrU,
	u.id_eqp