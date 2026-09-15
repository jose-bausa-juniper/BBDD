--CONFIG AWS

SELECT Id_SuP, SuP_Nombre, SuP_Login, 'AvantioB2C123*' AS SuP_Password, Id_Cli, Id_Aws FROM Tbl_AlojaSupplierPushConfig WHERE id_SUP = 8

SELECT Id_Cli, Cli_Nombre, Cli_Login, 'JuniperPmTest**26' AS Cli_Password FROM Tbl_Cliente WHERE Id_Cli = 74939

SELECT Id_Aws,Aws_Nombre,Aws_Login,'WS_Push_External_Dm_26**' AS Aws_Password,Aws_PermitirAccesoWS FROM Tbl_AdministradorWS WHERE id_aws = 32

--CONFIG AVT
SELECT Id_CRE, CRE_Prov, CRE_Nombre FROM Tbl_ParametroIntegracionCredencial WHERE Id_CRE = 1056
SELECT Id_CRE,CPR_Clave,CPR_Valor FROM Tbl_ParametroIntegracionCredencialPropiedad WHERE Id_CRE = 1056 AND CPR_Clave IN ('SupplierPush Login','SupplierPush Password')
--SELECT * FROM Tbl_ParametroIntegracionCredencialPropiedadAudit WHERE Id_CRE = 1056 -- AvantioB2C / AvantioB2C123*

--CONFIG SUPPLIER PUSH
SELECT Id_SuP, SuP_Nombre, SuP_Login, 'AvantioB2C123*' AS SuP_Password, Id_Cli, Id_Aws FROM Tbl_AlojaSupplierPushConfig WHERE id_SUP = 8
SELECT * FROM Tbl_AlojaSupplierPushElemento WHERE Id_SuP = 8 AND SPE_CodHotel = '260921'
SELECT * FROM Tbl_AlojaSupplierPushCupo WHERE Id_SPE IN (SELECT Id_SPE FROM Tbl_AlojaSupplierPushElemento WHERE Id_SuP = 8 AND SPE_CodHotel = '260921')





-- CONFIG SUPPLIER PUSH REDISTRIBUTION
SELECT * FROM Tbl_AlojaSupplierPushConfigRedistribution WHERE id_SUP = 8
SELECT * FROM Tbl_AlojaSupplierPushConfigRedistributionHotels WHERE Id_SCR IN (SELECT Id_SCR FROM Tbl_AlojaSupplierPushConfigRedistribution WHERE id_SUP = 8)