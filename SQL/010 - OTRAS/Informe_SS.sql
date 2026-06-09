/*tbl_EnvioAlojaCliente*/
SELECT DISTINCT(Eac_Tipo) FROM tbl_EnvioAlojaCliente

SELECT MIN(Feccre),COUNT(*) FROM tbl_EnvioAlojaCliente ORDER BY 1 DESC

/*Tbl_HistorialEnvios*/
SELECT DISTINCT (HEv_Tipo) FROM Tbl_HistorialEnvios
SELECT COUNT(*) FROM Tbl_HistorialEnvios ORDER BY 1 DESC
 
/*Tbl_HistorialEnvios*/
SELECT COUNT(*) FROM Tbl_StopSales ORDER BY 1 DESC

--DELEGACIONES DE JUNIPER PM TEST
SELECT 
	D.Id_Del,
	D.Del_nombre,
	C.Id_Cli,
	C.Cli_Nombre,
	CND.*
FROM 
				Tbl_Cliente		C
	INNER JOIN	TBl_CliNdel		CND ON CND.Id_Cli = C.id_Cli
	INNER JOIN	Tbl_Delegacion	D	ON D.Id_Del = CND.Id_Del
WHERE 
	1 = 1
	AND C.Cli_Activa = 1
	AND CND.Id_Cli IS NULL


/*obtenerClientesStopSales*/
SELECT 
	cli.Cli_Activa,cli.Id_Cli, cli.Cli_Nombre, cnd.CND_mailDelegacion, cnd.Id_Del, cnd.CND_contratosPropios,
	cnd.CND_envioStopSales, cnd.CND_SoloDistribuciones, cnd.*
FROM 
				Tbl_Cliente cli 
	INNER JOIN	TBl_CliNdel cnd ON cli.Id_Cli = cnd.Id_Cli 
WHERE
	1 = 1
	AND (cnd.CND_mailDelegacion Is Not NULL) AND cnd.CND_mailDelegacion <>  ''
	AND cnd.CND_envioStopSales = 0
	AND cnd.Id_Del = 1
	--AND cli.Cli_Activa = 1
	--AND cli.Cli_Nombre = 'READ ONLY - ASTRAL HOLIDAYS'
	--AND cli.Id_Cli = 74939 
ORDER BY 
	cli.Cli_Nombre

/*ObtenerStopSalesDelegacion*/
SELECT 
	ss.Id_SSa, ss.SSa_FechaIni, ss.SSa_FechaFin, ss.SSa_BajoPeticion, ss.SSa_AfectaCupoSeguridad, ss.SSa_AfectaCupoGarantizado, ss.SSa_venta,
	ss.Id_Con, dl.Id_Del, dl.Del_tlf, dl.Del_nombre, gp.Id_GRP,  ss.Id_THa, ss.Id_Alo,SSa_GrupoControlAcceso
FROM			Tbl_StopSales		ss
	INNER JOIN	Tbl_Alojamiento		al on ss.Id_Alo = al.Id_Alo 
	INNER JOIN	Tbl_GrupoProducto	gp on gp.Id_GRP = al.Id_GRP
	INNER JOIN	Tbl_Delegacion		dl on dl.Id_Del = gp.id_del
WHERE 
	1 = 1
	--AND dl.Id_Del IN (1,6)
	AND al.Id_Alo = 20373
	AND ss.SSa_FechaFin > GETDATE()

/*obtenerStopSales de un Alojamiento*/
SELECT 
	Id_SSa, Id_Alo, SSa_FechaIni, SSa_FechaFin,
	Id_THa, SSa_BajoPeticion, Id_CCo, SSa_AfectaCupoSeguridad, 
	id_con, SSa_venta, SSa_AfectaBloqueo, ssa_AfectaCupoGarantizado, SSa_AplicarDiaEntrada,SSa_GrupoControlAcceso
FROM 
	Tbl_StopSales 
WHERE 
	1 = 1
	AND Id_Alo=14775


/*obtenerHistorialStopSalesAlo*/

/*obtenerHistorialStopSalesClie*/


SELECT 
COUNT(*)
FROM 
	Tbl_StopSales 
WHERE  SSa_FechaFin > '2024-08-01'


SELECT * FROM Tbl_GrupoProducto WHERE id_del = 1

SELECT * FROM Tbl_Cliente WHERE cli_Nombre like '%NO USAR - SV TOUR%'