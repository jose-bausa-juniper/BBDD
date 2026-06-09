USE BD_Nincoming

SELECT CC.CCl_ComisionExternaVisible, C.Id_GRA FROM TBL_Cliente C INNER JOIN Tbl_ClienteConfiguracion CC ON CC.Id_Cli = C.Id_Cli where C.id_Cli = 65622


SELECT Gra_comisionExternaVisible, * FROM Tbl_GrupoAgencia WHERE Id_GRA = 455