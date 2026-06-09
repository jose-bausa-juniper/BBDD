select r.id_res, r.Feccre, r.Id_Ifz, l.LRe_TipoDesglosado from tbl_reserva r, tbl_lineareserva l, tbl_historial h where
r.id_res in (select id_Res from tbl_reserva where  Res_Estado = 'Can' and feccre > '2024-03-25 00:00:00.000') and
l.id_res = r.Id_Res and
l.LRe_TipoDesglosado like 'J%' and
h.Id_Res = r.Id_Res and
h.His_Texto like '%Error confirmando reserva System.NullReferenceException: Object reference not%'
order by l.LRe_TipoDesglosado