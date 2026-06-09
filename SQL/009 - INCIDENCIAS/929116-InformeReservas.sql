USE BD_Nincoming;

DECLARE
@fechahoy DATETIME = GETDATE(),
@fechaayer DATETIME = GETDATE()-1,
@proveedor VARCHAR(MAX) = 'TTOO - HOTELBEDS'

SELECT
--TOP 100
P.Pro_Nombre,
LR.LRe_Tipo,
R.Res_Localizador,
LR.Id_LRe,
R.Res_Fecha,
DATEDIFF (DAY, R.Res_FechaInicioViaje , R.Res_FechaFinViaje + 1)			AS [Nº Noches],
R.Res_FechaInicioViaje,
R.Res_FechaFinViaje,
CASE
	WHEN RA.Id_Alo IS NULL THEN CONCAT(RAE.RAE_tipoProducto,'|',RAE.RAE_AlojaID)
	WHEN RAE.RAE_AlojaID IS NULL THEN CONCAT('HBE|',RA.Id_Alo)
END AS [Alojamiento],
R.Res_Estado,
LR.LRe_Cancelada,
R.Res_FechaCancelacion,
Z.Zon_Nombre_ES,
LR.LRe_CupoAsignado,
R.Res_PrecioCosteFinal,
LR.LRe_MonedaCoste,
N.pai_Nombre,
LR.LRe_nAdultos,
LR.LRe_nNinos
FROM 
							Tbl_Reserva						R
	INNER JOIN				Tbl_LineaReserva				LR	ON LR.Id_Res = R.Id_Res
	INNER JOIN				Tbl_Proveedor					P	ON P.Id_Pro = LR.Id_Pro
	INNER JOIN				Tbl_Zona						Z	ON Z.Id_Zon = LR.Id_Zon
	INNER JOIN				Tbl_Cliente						C	ON C.Id_Cli = R.Id_Age
	INNER JOIN				Tbl_Paises						N	ON C.id_pai = N.id_pai
	FULL JOIN				Tbl_ReservaAlojamiento			RA	ON RA.Id_LRe = LR.Id_LRe
	FULL JOIN				Tbl_ReservaAlojamientoExterno	RAE ON RAE.Id_LRe = LR.Id_LRe
	   
WHERE
		1=1
		AND P.Pro_Nombre = @proveedor
		AND (R.Res_Fecha > @fechaayer)
		AND (R.Res_Fecha < @fechahoy)
		AND R.Res_Estado IN ('Con','Pag','Can','Cac')
		AND LR.LRe_Tipo NOT IN ('AGN','J','JHF','JPD','SGO','ASu','TGN','RGN','M','P','SGN','J')
		--AND R.Id_Ifz = 'XML'
		--AND R.Id_Can = 'WPRO'