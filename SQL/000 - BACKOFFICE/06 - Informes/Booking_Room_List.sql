SELECT
	C.Id_Cli					AS ID_CLI,		
	C.Cli_Nombre				AS CLI_NOMBRE,
	R.id_Res					AS ID_RES,
	R.Res_Localizador			AS LOC,
	R.Res_ReferenciaAgencia		AS REF_AGE,
	LR.Id_LRe					AS ID_LRE,
	RA.Id_Alo					AS ID_ALO,
	RA.Id_Reg					AS ID_REG,
	RE.Reg_Abreviatura			AS AV_REG,
	INR.IRe_Nombre				AS REG,
	RMG.ID_THA					AS ID_THA,	
	RMG.RHA_Nombre				AS THA
FROM
			Tbl_Cliente						C 
INNER JOIN	TBL_Reserva						R		ON R.id_Age = C.id_Cli
INNER JOIN	Tbl_LineaReserva				LR		ON LR.id_res = R.id_Res
LEFT JOIN	Tbl_ReservaAlojamiento			RA		ON (RA.Id_Res = R.id_res AND RA.Id_LRe = LR.Id_LRe)
LEFT JOIN	Tbl_IDiNAlo						INA		ON (INA.Id_Alo = RA.Id_Alo AND INA.Id_Idi = 'EN')
LEFT JOIN	Tbl_Regimen						RE		ON RE.Id_Reg = RA.Id_Reg
LEFT JOIN	Tbl_IdiNReg						INR		ON (INR.Id_Reg = RA.Id_Reg AND INR.Id_Idi = 'EN')				
LEFT JOIN	Tbl_ReservaModalidadGenerica	RMG		ON RMG.ID_LRE = LR.Id_LRe
WHERE
	1 = 1
	AND C.Id_Cli IN (17607,78438,13590,80433,80436,84976)
	AND R.Res_FechaInicioViaje BETWEEN '2026-06-04' AND '2027-12-31'