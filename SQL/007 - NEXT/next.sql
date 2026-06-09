USE BD_Nincoming;

DECLARE
@fechahoy DATETIME = GETDATE(),
@fechaprimerareserva DATETIME = '2024-01-18',
@fechaayer DATETIME = GETDATE()-365


SELECT
--LR.LRe_Tipo																	AS [Tipo Producto],
R.id_Res,
--R.Res_Localizador															AS [Localizador],
COUNT(LR.Id_LRe)																AS [Agencia]
--C.id_Cli,
--C.Cli_tipoPago,
--CONCAT(R.Res_Nombre,' ',R.Res_Apellidos)									AS [Titular],
--LR.Id_LRe																	AS [Linea Reserva],
--R.Res_Fecha																	AS [Fecha Reserva],
--DATEDIFF (DAY, R.Res_FechaInicioViaje , R.Res_FechaFinViaje + 1)			AS [Nº Noches],
--R.Res_FechaInicioViaje														AS [Fecha Inicio],
--R.Res_FechaFinViaje															AS [Fecha Fin],
--R.Res_Estado																AS [Estado Reserva],
--LR.LRe_Cancelada															AS [Linea Cancelada],
--R.Res_FechaCancelacion														AS [Fecha Cancelcación],
--LR.LRe_CupoAsignado															AS [Cupo],
--R.Res_PrecioCosteFinal														AS [Coste],
--LR.LRe_MonedaCoste															AS [Moneda Coste]

FROM 
							Tbl_Reserva						R
	FULL JOIN				Tbl_LineaReserva				LR	ON LR.Id_Res = R.Id_Res
	INNER JOIN				Tbl_Cliente						C	ON C.Id_Cli = R.Id_Age
	   
WHERE
		1=1
		AND R.Res_Fecha >= @fechaayer
		AND R.Res_Estado = 'Ini'
		AND R.Id_Ifz = 'XML'
		AND R.Id_Can = 'WPRO'

GROUP BY
	R.Id_Res

HAVING

COUNT(LR.Id_LRe) = 0
