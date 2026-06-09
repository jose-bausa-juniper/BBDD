USE BD_Nincoming


SELECT 

R.Res_Localizador,
LR.Lre_BeneficioPagoDirecto,
LR.lre_PrecioMarkupAgenteSobreBeneficio,
R.Res_PrecioCoste,
R.Res_PrecioCosteFinal,
R.Res_PrecioComision,
R.Res_PrecioFinal,
R.Res_PrecioTotal,
RAE.RAE_AplicarMarkupSobreNeto,
RAE.RAE_PrecioCosteOriginal,
RAE.RAE_cambioPrecio,
RAE.RAE_ComisionProv,
RAE.RAE_GuardarComision

FROM Tbl_Reserva R
INNER JOIN Tbl_LineaReserva LR ON LR.id_Res = R.id_Res
INNER JOIN Tbl_ReservaAlojamientoExterno RAE ON RAE.Id_LRe = LR.Id_LRe
--INNER JOIN Tbl_LineaReservaExtendido LRE ON LRE.Id_LRe = LR.Id_LRe
INNER JOIN Tbl_ReservaExtendida RE ON RE.Id_Res = R.Id_Res

WHERE Res_Localizador IN ('LHKH4S','54LFVR')





SELECT Fecmod,* FROM Tbl_Zona WHERE ID_Zon = 47735