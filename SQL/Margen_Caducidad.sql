SELECT * FROM Tbl_Parametro WHERE Par_Codigo LIKE 'Reserva/MargenGastosExtra'							-- MARGEN EXTRA GLOBAL ENTRE POLITICAS DE COSTE Y VENTA
SELECT TOP 1 * FROM Tbl_Parametro WHERE Par_Codigo LIKE '%Reserva/MargenGastosExtraCliente%'			-- MARGEN EXTRA POR CLIENTE ENTRE POLITICAS DE COSTE Y VENTA (¿SOBREESCRIBE A MargenGastosExtra?)
																										--
SELECT * FROM Tbl_Parametro WHERE Par_Codigo LIKE '%Reserva/HorasMargenGastosCancelacion%'				-- MARGEN CADUCIDAD PRODUCTO EXTERNO (MALA NOMENCLATURA)
																										--
SELECT * FROM Tbl_Parametro WHERE Par_Codigo LIKE '%Reserva/MargenCaducidad%'							-- MARGEN CADUCIDAD GLOBAL
																										--
SELECT * FROM Tbl_Parametro WHERE Par_Codigo LIKE '%Reserva/HoraLimiteCaducidad%'						-- HORA LIMITE PARA CADUCIDAD, (PENDIENTE CONFIRMAR FUNCIONAMIENTO)

