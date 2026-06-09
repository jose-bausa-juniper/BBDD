USE BD_Nincoming

DECLARE @ONEPROV AS varchar(10); SET @ONEPROV = 'DY22';
DECLARE @PERMITIRNRF AS varchar(10); SET @PERMITIRNRF = 'false';

DECLARE @PROV TABLE (PROV VARCHAR(4));
DECLARE @PROV_CONFIG_NRF TABLE (PROV VARCHAR(4),PI VARCHAR(4), CODIGO VARCHAR(25), PI_CONFIG INT, PI_VALOR VARCHAR(10));

----------------- PROVEEDORES -----------------
INSERT INTO @PROV
SELECT
	CASE
		WHEN tpd.id_TPD IS NULL THEN tp.TPr_Tipo
		ELSE tpd.id_TPD
	END 														AS [Modulo]
FROM 
	Tbl_TipoProducto tp
	FULL JOIN Tbl_TipoProductoDesglosado	tpd			ON	tp.TPr_Tipo=tpd.TPr_Tipo
WHERE 
	1 = 1
	AND (tp.TPr_Visible = 1  OR tp.TPr_Visible IS NULL)
	AND (tpd.TPd_Visible = 1 OR tpd.TPd_Visible IS NULL)
ORDER BY
	[Modulo]

----------------- CONFIGURACION NRF PROVEEDORES -----------------
INSERT INTO @PROV_CONFIG_NRF
SELECT 
	P.PROV			AS [PROV],
	PI.Id_Pai		AS [Id_Pai],
	PI.Pai_Codigo	AS [Pai_Codigo],
	PIC.Id_Cpi		AS [Id_Cpi],
	PIC.Pic_Valor	AS [Pic_Valor]
FROM 										
				@PROV									P
	LEFT JOIN	Tbl_ParametroIntegracion				PI	ON PI.Pai_Prov = P.PROV	 AND PI.Pai_Codigo = 'PermitirTarifasNRF'
	LEFT JOIN	Tbl_ParametroIntegracionConfiguracion	PIC ON PIC.Id_Pai = PI.Id_Pai
ORDER BY
	[PROV]

SELECT
	PCNRF.PROV											AS [PROV],
	PCNRF.CODIGO										AS [PARAMETRO],
	PCNRF.PI_VALOR										AS [PI_VALOR],
	CASE
		WHEN M.Mer_Nombre IS NULL THEN '- Todos -'
		ELSE M.Mer_Nombre
	END													AS [MERCADO],
	CASE
		WHEN GA.GRA_Nombre IS NULL THEN '- Todos -'
		ELSE GA.GRA_Nombre
	END													AS [GRUPO AGENCIA],
	CASE 
		WHEN C.Cli_Nombre IS NULL THEN '- Todos -'
		ELSE C.Cli_Nombre
	END													AS [CLIENTE],

-- Miramos Extendida CAE.CAE_denegar si es NULL miramos la Normal CA.CAc_Denegar
	CASE
		WHEN CAE.CAE_denegar IS NULL 
		THEN 
			CASE CA.CAc_Denegar
				WHEN 0 THEN 'PERMITIDO'
				WHEN 1 THEN	'DENEGADO'
			END
		ELSE 
			CASE CAE.CAE_denegar
				WHEN 0 THEN 'PERMITIDO'
				WHEN 1 THEN	'DENEGADO'
			END
	END 												AS [ACCESO],
	C.Id_Cli
FROM
				@PROV_CONFIG_NRF			PCNRF
	LEFT JOIN	Tbl_ControlAcceso			CA		ON CA.CAc_Codigo = PCNRF.PI_CONFIG AND CA.CAc_Tipo ='conPI'
	LEFT JOIN	Tbl_ControlAccesoExtendido	CAE		ON CAE.Id_CAc = CA.Id_CAc
	LEFT JOIN	Tbl_Cliente					C		ON C.Id_Cli = CA.Id_Cli
	LEFT JOIN	Tbl_GrupoAgencia			GA		ON GA.Id_GRA = C.Id_Gra 
	LEFT JOIN	Tbl_Mercado					M		ON M.Id_Mer = GA.Id_Mer
WHERE 
	1 = 1
	AND PCNRF.PROV = @ONEPROV
	AND (PCNRF.PI_VALOR = @PERMITIRNRF OR PCNRF.PI_VALOR IS NULL)
GROUP BY
	PCNRF.[PROV],
	PCNRF.[PI],
	PCNRF.[CODIGO],
	PCNRF.[PI_CONFIG],
	PCNRF.[PI_VALOR],
	C.[Cli_Nombre],
	C.id_cli,
	GA.[GRA_Nombre],
	M.[Mer_Nombre],
	CA.[CAc_Denegar],
	CAE.[CAE_denegar]
ORDER BY
	[ACCESO] DESC,
	[MERCADO] DESC,
	[GRUPO AGENCIA],
	[CLIENTE]

