/*
SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME LIKE 'Emp_NombreComercial'
SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME IN ('id_EmpresaCompra','id_EmpresaVenta','id_FinancieraCompra','id_FinancieraEmpresaVenta') ORDER BY TABLE_NAME

SELECT * from tbl_Permiso where Per_Nombre like 'chkModificarContratadora'
SELECT * from tbl_RolUsuarioPermiso where Id_Per = 170 and Per_ValorActual = 'true'
SELECT * from tbl_RolUsuario where Id_Rol in (57)

*/

USE BD_Nincoming

SELECT 
--lr.Id_Res,
e.Emp_NombreComercial,
e.Emp_CodigoExportacion,
lra.Id_EmpresaVenta,
COUNT (lra.Id_EmpresaVenta) AS 'Nº L Reserva'
--r.Id_Can,
--r.Res_Fecha

FROM tbl_lineaReservaAccounting lra
INNER JOIN Tbl_LineaReserva lr ON lra.Id_lre = lr.Id_LRe
INNER JOIN Tbl_Reserva r on lr.Id_Res = r.Id_Res
INNER JOIN Tbl_Empresas e on e.Id_Emp = lra.Id_EmpresaVenta

WHERE 1=1
AND r.Res_Fecha > '2023' 
AND r.Id_Can = 'WPRO'

GROUP BY lra.Id_EmpresaVenta, e.Emp_NombreComercial, e.Emp_CodigoExportacion
