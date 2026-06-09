USE BD_Newtravelers

SELECT TOP 10 
a.adm_validarActiveDirectory,
* 

FROM Tbl_Administrador a
INNER JOIN Tbl_UsuarioLoginExterno ule ON a.Id_Adm = ule.ULE_IdUsuario

WHERE a.Adm_Activo = 1