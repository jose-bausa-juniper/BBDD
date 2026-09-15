--CONFIG AWS

SELECT Id_SuP, SuP_Nombre,SuP_Login, 'Redistribucion_W2M_26**' SuP_Password, Id_Cli, Id_Aws FROM Tbl_AlojaSupplierPushConfig WHERE id_SUP = 7

SELECT Id_Cli, Cli_Nombre, Cli_Login, Cli_Password FROM Tbl_Cliente WHERE Id_Cli = 917

SELECT Id_Aws,Aws_Nombre,Aws_Login, 'WS_Push_External_Dm_**26' AS Aws_Password,Aws_PermitirAccesoWS FROM Tbl_AdministradorWS WHERE id_aws = 31


--CONFIG SUPPLIER PUSH
SELECT Id_SuP, SuP_Nombre, SuP_Login, SuP_Password, Id_Cli, Id_Aws FROM Tbl_AlojaSupplierPushConfig WHERE id_SUP = 7

-- CONFIG SUPPLIER PUSH HOTELS
SELECT * FROM Tbl_AlojaSupplierPushConfigHotels WHERE id_SUP = 7
SELECT * FROM Tbl_AlojaSupplierPushElemento WHERE Id_SuP = 7 AND SPE_CodHotel = 'AVT|260921'