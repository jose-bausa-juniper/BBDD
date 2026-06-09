select a.Id_Adm, Adm_Login, Adm_Nombre, Adm_EmailSeguridad from Tbl_Administrador  a LEFT JOIN Tbl_AdministradorExtendido ae on a.id_adm = ae.id_adm where Adm_Activo = 1 and Adm_EmailSeguridad ='noreply@w2m.com'

select Id_Adm from Tbl_AdministradorExtendido where Id_Adm in (select a.Id_Adm from Tbl_Administrador  a LEFT JOIN Tbl_AdministradorExtendido AE on a.id_adm = ae.id_adm where Adm_Activo = 1 and ae.Adm_EmailSeguridad is null)


Update Tbl_AdministradorExtendido

Set Adm_EmailSeguridad = 'noreply@w2m.com' 

where Id_Adm in (select a.Id_Adm from Tbl_Administrador  a LEFT JOIN Tbl_AdministradorExtendido AE on a.id_adm = ae.id_adm where Adm_Activo = 1 and ae.Adm_EmailSeguridad is null)

