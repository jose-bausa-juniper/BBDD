USE BD_TestSuppliers;

------ Agencia y Agente ------
SELECT
	C.Id_Cli,
	CA.Id_CAg,
	CA.CAg_Nombre,
	*
FROM 
				Tbl_Cliente					C
	INNER JOIN	Tbl_ClienteAgente			CA ON CA.Id_Cli = C.Id_Cli	
WHERE 
	1 = 1
	AND C.Cli_Mail LIKE '%jose.bausa@ejuniper.com%'
	AND C.Id_Cli = 917

------ Alojamiento y Contratos ------


------ Extranet y Usuario ------

SELECT
	UE.Id_UsE,
	UE.UsE_Login,
	UEA.Id_Alo,
	IA.IAl_Nombre,
	CCA.*
	--UE.*,
	--A.*
FROM
				Tbl_UsuarioExtranet			UE
	INNER JOIN	Tbl_UsENAlo					UEA	ON UEA.Id_UsE = UE.Id_UsE
	INNER JOIN	Tbl_Alojamiento				A	ON A.Id_Alo = UEA.Id_Alo
	INNER JOIN	Tbl_IDiNAlo					IA	ON IA.Id_Alo = A.Id_Alo
	INNER JOIN	Tbl_ContratoCompraAloja		CCA	ON CCA.Id_Alo = A.Id_Alo
	--INNER JOIN	tbl_ContratoAloja			CA	ON CA.
WHERE
	1 = 1
	AND UE.Id_UsE = 38
	AND IA.Id_Idi = 'ES'
	AND A.Id_Alo = 350