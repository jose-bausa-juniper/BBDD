USE BD_Nincoming

SELECT 
	CONCAT('CFG-',cpp.Id_PSP)										AS [CFG],
	CASE cpp.PSP_Tipo
		WHEN 26 THEN 'W2MGTW'
		WHEN 28 THEN 'W2MDCT'
		ELSE CONVERT(VARCHAR(MAX),cpp.PSP_Tipo)
	END																AS [Tipo de pasarela de pago],
	cpp.PSP_CanalDefecto											AS [Canal por defecto], 
	cpp.PSP_Activo													AS [Activo], 
	aqb.Id_AQB														AS [ID Cuenta Bancaria],
	aqb.AQB_TipoCuenta,
	aqb.AQB_Name													AS [Cuenta Bancaria],
	cpp.PSP_Sistema													AS [Nombre],
	cpp.PSP_MonedaDefecto											AS [Moneda por defecto],
	cpp.PSP_IDSYS													AS [DS_MERCHANT_CURRENCY],
	cpp.PSP_IDCLISYS												AS [DS_MERCHANT_MERCHANTCODE], 
	cpp.PSP_LOGIN													AS [DS_MERCHANT_TERMINAL],
	cpp.PSP_PASSWD													AS [Contrase�a], 
	cpp.PSP_URL														AS [Url], 
	cpp.PSP_URLMan													AS [Url mantenimiento], 
	cpp.PSP_URLAuth													AS [Url autenticaci�n],
	cpp.PSP_DevolucionParcial										AS [Devoluci�n parcial], 
	cpp.PSP_IntegracionPuntos										AS [Integraci�n de puntos], 
	cpp.PSP_MonedasPermitidas										AS [Monedas Permitidas],
	cpp.PSP_CancelErr												AS [Cancelar reserva en error de pago], 
	cpp.PSP_CancelMail												AS [Mensaje automatico al cancelar]

FROM 
				Tbl_ConfiguracionPasarelasDePago	cpp
INNER JOIN		Tbl_AccountsQB						aqb ON aqb.id_AQB=cpp.id_AQB

WHERE 
	1 = 1
	AND	cpp.PSP_Activo = 1
	--AND cpp.PSP_Tipo = 26

ORDER BY
	cpp.Id_PSP

