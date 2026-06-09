SELECT
	R.Res_Localizador,
	RSG.id_Res,
	RSG.Id_Lre,
	RSG.RSG_TipoProducto,
	RSG.RSG_TipoServicio,
	--RSG.Rsg_binproducto,
	R.Res_Fecha,
	RSG.RSG_FechaVueloSalida,
	LR.LRe_finiViaje,
	R.Res_Estado
	--RSG.Rsg_origen,
	--ZO.Zon_Nombre_ES,
	--RSG.Rsg_destino,
	--ZD.Zon_Nombre_ES,
	--LR.lre_horasalida
FROM 
				Tbl_ReservaServicioGenerico		RSG  
	INNER JOIN	TBL_LineaReserva				LR	ON RSG.FecCre > '05/04/2025 0:00:00'  AND RSG.Id_lre = LR.Id_LRE AND  (LR.LRe_CupoAsignado = 1 OR LR.LRe_ConfirmarSinCupo = 1)  
	INNER JOIN	Tbl_reserva						R	ON R.Id_Res = LR.id_res
	INNER JOIN	Tbl_Zona						ZO	ON ZO.id_Zon = RSG.Rsg_origen
	INNER JOIN	Tbl_Zona						ZD	ON ZD.id_Zon = RSG.Rsg_destino

WHERE 
RSG.RSG_FechaVueloSalida is not null 
AND RSG.RSG_TipoServicio = 'Transfer'
AND DATEDIFF(D, LR.LRe_finiViaje, RSG.RSG_FechaVueloSalida) >= 1 
--AND R.Res_Localizador IN  ('BBZJ85','6C13FN')
ORDER BY
R.Res_Fecha	DESC
