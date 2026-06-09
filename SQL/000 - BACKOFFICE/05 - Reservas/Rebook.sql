USE BD_Nincoming
SELECT TOP 100 r.Res_Localizador, lr.Id_LRe, lr.LRE_IdSustituyente
FROM Tbl_LineaReserva lr
INNER JOIN tbl_Reserva r ON r.Id_Res=lr.Id_Res
WHERE r.Id_Res IN (24521942)
ORDER BY r.Res_Localizador, lr.Id_LRe


UPDATE Tbl_LineaReserva set LRE_IdSustituyente = 25761374 WHERE id_lre = 25644107
UPDATE Tbl_LineaReserva set LRE_IdSustituyente = 25871844 WHERE id_lre = 25761374

UPDATE Tbl_LineaReserva set LRE_IdSustituyente = 25567665 WHERE id_lre = 25388877
UPDATE Tbl_LineaReserva set LRE_IdSustituyente = 25584169 WHERE id_lre = 25567665
