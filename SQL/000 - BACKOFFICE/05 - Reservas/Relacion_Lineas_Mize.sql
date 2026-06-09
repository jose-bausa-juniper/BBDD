UPDATE Tbl_LineaReserva SET LRE_IdSustituyente = 29394278 WHERE Id_LRe = 28978891
INSERT INTO Tbl_Historial (id_res, Id_LRe, HIS_Usuario, HIS_fecha, his_texto, feccre) VALUES (23295914, 28978891,'Jun: Jose Bausa',GETDATE(),'Ajustamos relación Linea Rebook, solicitado en ticket 967166', GETDATE())


UPDATE Tbl_LineaReserva SET LRE_IdSustituyente = 29641879 WHERE Id_LRe = 29394278
INSERT INTO Tbl_Historial (id_res, Id_LRe, HIS_Usuario, HIS_fecha, his_texto, feccre) VALUES (23295914, 29394278,'Jun: Jose Bausa',GETDATE(),'Ajustamos relación Linea Rebook, solicitado en ticket 967166', GETDATE())






SELECT R.Id_Res, Res_Localizador, Id_LRe, LRE_IdSustituyente FROM TBL_Reserva R INNER JOIN Tbl_LineaReserva LR ON LR.id_Res = R.id_Res WHERE R.RES_localizador ='DX2J1Q'