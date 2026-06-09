-- TABLA INTERMEDIA DE ENVIOS
SELECT 
	EAC.*
FROM 
	tbl_EnvioAlojaCliente	EAC
WHERE 
	1 = 1
	--AND EAC.Eac_Enviado = 1
	AND EAC.Eac_Enviado = 0
	--AND EAC.Feccre > '2025'
	--AND EAC.Feccre < '2025'
	--AND (EAC.Id_Tipo = 142907957 AND EAC.Eac_Tipo = 'OF') --> Filtro Concreto
ORDER BY 
	EAC.Feccre DESC

	--EAC.Eac_Tipo,
	--EAC.Id_Del,
	--EAC.Id_Cli,
	--EAC.Feccre DESC


-- TIPOS ENVIO
/*
	OFERTAS			(OD;OF)
	SUPPLEMENTO		(SD;SF)
	RESTRICCION		(RD;RF)
	RELEASE			(LD;LF)

	SELECT 
		DISTINCT(EAC.Eac_Tipo)
	FROM 
		tbl_EnvioAlojaCliente	EAC
*/



--OFERTAS
	--SELECT ASU.FecMod, ASU.UsuMod,ANA.Id_Alo, INA.*, ASU.* FROM Tbl_AlojamientoSuplemento ASU
	--INNER JOIN Tbl_IdiNASu INA ON INA.id_ASU = ASU.Id_ASu AND INA.Id_Idi = 'ES'
	--INNER JOIN Tbl_ASuNAlo ANA ON ANA.Id_ASu = ASU.Id_ASu
	--WHERE ASU.Id_ASu = 142907957

--SUPPLEMENTO
	--SELECT ASU.FecMod, ASU.UsuMod,ANA.Id_Alo, INA.*, ASU.* FROM Tbl_AlojamientoSuplemento ASU
	--INNER JOIN Tbl_IdiNASu INA ON INA.id_ASU = ASU.Id_ASu AND INA.Id_Idi = 'ES'
	--INNER JOIN Tbl_ASuNAlo ANA ON ANA.Id_ASu = ASU.Id_ASu
	--WHERE ASU.Id_ASu = 142907957

--RESTRICCION
	--SELECT ASU.FecMod, ASU.UsuMod,ANA.Id_Alo, INA.*, ASU.* FROM Tbl_AlojamientoSuplemento ASU
	--INNER JOIN Tbl_IdiNASu INA ON INA.id_ASU = ASU.Id_ASu AND INA.Id_Idi = 'ES'
	--INNER JOIN Tbl_ASuNAlo ANA ON ANA.Id_ASu = ASU.Id_ASu
	--WHERE ASU.Id_ASu = 142907957

--RELEASE
	--SELECT ASU.FecMod, ASU.UsuMod,ANA.Id_Alo, INA.*, ASU.* FROM Tbl_AlojamientoSuplemento ASU
	--INNER JOIN Tbl_IdiNASu INA ON INA.id_ASU = ASU.Id_ASu AND INA.Id_Idi = 'ES'
	--INNER JOIN Tbl_ASuNAlo ANA ON ANA.Id_ASu = ASU.Id_ASu
	--WHERE ASU.Id_ASu = 142907957
