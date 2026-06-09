USE BD_Nincoming
SELECT 
	C.Id_Cli								AS [ID],
	C.Cli_Nombre							AS [NOMBRE],
	GA.GRA_Nombre							AS [GRUPO_AGENCIA],
	M.Mer_Nombre							AS [MERCADO],
	C.Cli_TipoPago							AS [PAGO],
	C.Cli_DenegarReservaCreditoGastos		AS [CREDITO_DENEGAR_GASTOS],
	C.cli_PrepagoReservaEntranEnGastos		AS [PREPAGO_PERMITIR_GASTOS],
	CC.CCl_PrepagoQUOenWS					AS [PREPAGO_GASTOS_EN_QUO],
	C.Cli_limiteCredito						AS [LIMITE_CREDITO],
	C.Cli_LimiteFacturado					AS [LIMITE_FACTURACION],
	CC.CCl_DenegarPagoTPVReservaConGastos	AS [DENEGAR_PAGO_TPV_GASTOS],
	CC.CCl_MonedasOperacionCliente			AS [MONEDA],
	P.pai_Nombre							AS [PAIS]
FROM 
				Tbl_Cliente					C
	INNER JOIN	Tbl_ClienteConfiguracion	CC	ON C.Id_Cli = CC.Id_Cli
	INNER JOIN	Tbl_GrupoAgencia			GA	ON GA.Id_GRA = C.Id_GRA
	INNER JOIN	Tbl_Mercado					M	ON M.Id_Mer = GA.Id_Mer
	INNER JOIN	Tbl_Paises					P	ON P.id_pai = C.id_pai
WHERE 
	1=1
	AND C.Cli_Activa = 1
	AND C.Cli_TipoPago = 'B'
	AND C.cli_PrepagoReservaEntranEnGastos = 1
	AND CC.CCl_PrepagoQUOenWS = 0
