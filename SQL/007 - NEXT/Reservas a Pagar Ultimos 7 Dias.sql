SELECT 
	GA.GRA_Nombre								AS [Grupo Agencia],
	C.Id_Cli									AS [Id Agencia],
	C.Cli_Nombre								AS [Agencia],
------------------------------------------------------------------------------------
	R.Res_Localizador							AS [Localizador Juniper],
	R.Res_ReferenciaAgencia						AS [Referencia Agencia],
	CONCAT(R.Res_Nombre,' ',R.Res_Apellidos)	AS [Titular Reserva],
	R.Res_Fecha									AS [Fecha Reserva],
	R.Res_Caducidad								AS [Fecha Caducidad],
	R.Res_Estado								AS [Estado Reserva],
	R.Res_PrecioFinal							AS [Precio],
	R.Res_FechaInicioViaje						AS [Fecha Check-In],
	R.Res_FechaFinViaje							AS [Fecha Check-Out],
	LR.LRe_FechaConGastos
FROM 
				Tbl_Reserva					R
	INNER JOIN	Tbl_Cliente					C	ON C.Id_Cli = R.Id_Age
	INNER JOIN	Tbl_LineaReserva			LR	ON LR.Id_Res = R.Id_Res
	INNER JOIN	Tbl_LineaReservaExtendido	LRE	ON LRE.Id_LRe = LR.Id_LRe
	INNER JOIN	Tbl_GrupoAgencia			GA	ON GA.Id_GRA = C.Id_GRA
WHERE 
	1 = 1
	AND GA.Id_Mer = 92 -- MERCADO PRO
	AND R.Res_Estado NOT IN ('Ini','PRe','Quo')
	AND R.Res_Caducidad BETWEEN CONVERT (DATE, GETDATE()) AND CONVERT (DATE, GETDATE()+7)
ORDER BY
	[Grupo Agencia],
	[Agencia]

