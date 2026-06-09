SELECT
R.Res_Localizador,
LR.id_Lre,
P.Pro_Email,
LR.LRe_PrecioCoste,
P.Pro_Nombre,
LR.Id_Pro,
R.Res_Notas
FROM Tbl_Reserva R LEFT JOIN Tbl_LineaReserva LR ON LR.id_Res = R.Id_Res LEFT JOIN Tbl_Proveedor P ON P.Id_Pro = LR.Id_Pro
WHERE 
R.Id_Res = 29919887
--LR.LRe_TipoDesglosado = 'J455' AND LR.LRe_Cancelada = 0 AND LR.LRe_finiViaje > GETDATE()


--locata - línea - mail - coste - prov nombre (no es necesario pero estará) - prov id - notas