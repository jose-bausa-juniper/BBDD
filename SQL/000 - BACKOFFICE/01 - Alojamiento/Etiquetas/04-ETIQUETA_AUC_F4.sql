SELECT MAX(Id_ANE) FROM Tbl_AucNEau 
SELECT * FROM Tbl_AucNEau WHERE id_AUC = 16946
SELECT * FROM Tbl_AucNCan WHERE Id_Ane IN (SELECT Id_Ane FROM Tbl_AucNEau WHERE id_AUC = 16946)

--=CONCAT("INSERT INTO Tbl_AucNEau (Id_ANE, id_AUC, id_EAU, ANE_FecIni, ANE_FecFin, ANE_TipoFecha, UsrCre, FecCre, UsrMod, FecMod) VALUES(";[@[Id_ANE]];", ";[@[ID_AUC]];", ";[@[ID_EAU]];", '0001-01-01', '0001-01-01', 0, 2609, GETDATE(), 2609, GETDATE())")
--=CONCAT("INSERT INTO Tbl_AucNCan (Id_Ane, Id_Can, UsrCre, FecCre, UsrMod, FecMod) VALUES(";[@[Id_ANE]];", 'WPRO', 2609,GETDATE(),2609,GETDATE())")