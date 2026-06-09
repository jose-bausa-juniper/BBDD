SELECT FSe_Clave,FSV_Valor FROM BD_Nincoming.dbo.Tbl_FrontSettingsValores 
WHERE (FSe_Clave ='$checkoutFlowo_oauth-client_secret' OR FSe_Clave ='$checkoutFlowo_oauth-client_id') 
AND Id_FSV IN (4509,4507)
