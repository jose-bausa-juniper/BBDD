select 
	top 1000 
		r.id_res as idReserva,
		r.res_localizador as LocalizadorJUN,
		lr.id_lre as IDLineaReserva,
		res_Estado as EstadoReserva,
		r.res_fecha as FecReserva, 
		lr.LRe_FechaCreacion as FecReservaLINEA,
		LRe_finiViaje,
		LRe_Tipo,
		lre_tipodesglosado,
		RAE_AlojaID,
		RAE_AlojaNombre,
		RAE_FechaEntrada,
		RAE_FechaSalida,
		lre_cancelada,
		LRe_CupoAsignado
from  
				tbl_reserva									r
	left join	tbl_lineareserva	    					lr	on r.id_res = lr.id_res
	left join	Tbl_ReservaAlojamientoExterno				rae on rae.Id_LRe = lr.id_lre

where 1 = 1
	 and lr.lre_tipodesglosado = 'PHMZ'
	 and RAE_FechaEntrada is null
	 --AND R.Res_Localizador IN ('39PZSG','5PFZV9')

order by 
	FecReservaLINEA DESC,
	r.Id_Res,
	lr.Id_LRe


