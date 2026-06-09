USE BD_Nincoming

-- SELECT * FROM Tbl_ParametroIntegracion WHERE Pai_Prov = 'C249' AND Pai_Codigo = 'permitirDistribucionesDiferentes'
-- SELECT * FROM Tbl_ParametroIntegracionAudit WHERE Pai_Prov = 'C249' AND Pai_Codigo = 'permitirDistribucionesDiferentes'
-- SELECT * FROM Tbl_ParametroIntegracionConfiguracion WHERE Id_Pai = 4632
-- SELECT * FROM Tbl_ParametroIntegracionConfiguracionAudit WHERE Id_Pai = 4632

-- Select * from Tbl_AuditUser where Id_Aus=27634



-- Select Id_Pai from Tbl_ParametroIntegracion WHERE Pai_Codigo = 'UsarCredencialesReserva'
-- SELECT * FROM Tbl_ParametroIntegracionConfiguracion WHERE Id_Pai IN (Select Id_Pai from Tbl_ParametroIntegracion WHERE Pai_Codigo = 'UsarCredencialesReserva')




SELECT * FROM Tbl_ParametroIntegracionCredencial WHERE CRE_Prov = 'RKT'