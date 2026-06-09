SELECT
--INTEGRADOR
IWS.Id_Int,
IWS.Int_Nombre,
--USUARIO EXTRANET
UE.Id_Int,
UE.Id_UsE,
UE.UsE_Nombre,
UE.UsE_Activo,
UE.UsE_AccesoReservasIntranet,
--ALOJAMIENTO USUARIO EXTRANET
UNA.Id_UsE,
UNA.Id_Alo,
--RESERVA ALOJAMIENTO
RA.Id_Alo,
RA.Id_LRe,
RA.Id_Res,
RA.RAl_FechaEntrada,
RA.RAl_FechaSalida,
--CONTRATO
CCA.Id_CCo,
CCA.CCo_Nombre,
CCA.CCo_Extranet,
CCA.CCo_Activo,
--LINEA RESERVA
LR.LRe_CupoAsignado,
LR.LRe_ConfirmarSinCupo,
LR.LRe_FechaCreacion,
--RESERVA
R.Id_Res,
R.Res_localizador,
R.Res_Estado,
R.Res_Fecha
FROM
			Tbl_IntegradorWS			IWS
INNER JOIN	Tbl_UsuarioExtranet			UE		ON UE.Id_Int = IWS.Id_Int
INNER JOIN	Tbl_UsENAlo					UNA		ON UNA.Id_UsE = UE.Id_UsE
INNER JOIN	Tbl_ReservaAlojamiento		RA		ON RA.Id_Alo = UNA.Id_Alo
INNER JOIN	Tbl_ContratoCompraAloja		CCA		ON CCA.Id_CCo = RA.Id_CCo
INNER JOIN	Tbl_LineaReserva			LR		ON LR.Id_LRe = RA.Id_LRe
INNER JOIN	Tbl_Reserva					R		ON R.Id_Res = LR.Id_Res
WHERE
	1=1
	--AND IWS.Id_Int = 84
	--AND IWS.Id_Int = 347
	AND IWS.Id_Int = 101



