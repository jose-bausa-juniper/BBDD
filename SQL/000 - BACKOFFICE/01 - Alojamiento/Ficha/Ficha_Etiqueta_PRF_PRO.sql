WITH ETIQUETAS AS (
	SELECT 
		EAU.id_EAU		AS [Id_Etiqueta], 
		EAU.EAU_Orden	AS [Orden],
		INE.IEI_Desc	AS [Etiqueta]
	FROM 
					Tbl_EtiquetaAlojaUnicoCliente	EAU		
		LEFT JOIN	Tbl_IdiNEtiqueta				INE		ON (EAU.id_EAU = INE.id_EAU AND INE.id_Idi = 'es')
	WHERE
		INE.IEI_Desc LIKE '%DyG%'
),
PRF_PRO AS (
	SELECT 
		atar.Id_TAR,
		atari.TAI_Nombre,
		ataro.Id_TAO, 
		ataro.TAO_Orden, 
		ataroi.TOI_Nombre
	FROM 
					Tbl_AlojamientoTipoAdicionalReserva					atar
		INNER JOIN	Tbl_AlojamientoTipoAdicionalReservaIdioma			atari	ON atar.Id_TAR = atari.id_TAR
		INNER JOIN	Tbl_AlojamientoTipoAdicionalReservaOpcion			ataro	ON ataro.Id_TAR = atar.Id_TAR
		INNER JOIN	Tbl_AlojamientoTipoAdicionalReservaOpcionIdioma		ataroi	ON ataroi.Id_TAO = ataro.Id_TAO
	WHERE 
		1=1
		AND atar.Id_TAR = 8
	GROUP BY
		atar.Id_TAR,
		atari.TAI_Nombre,
		ataro.Id_TAO, 
		ataro.TAO_Orden, 
		ataroi.TOI_Nombre
),
FICHAS_PROPIO AS (
	SELECT
		A.Id_Alo, JP.ALU_JPCode, PP.Id_TAR, PP.TAI_Nombre, ANT.Id_TAO, PP.TOI_Nombre
	FROM
					Tbl_Alojamiento		A
		LEFT JOIN	vwQlik_JP_Externos	JP	ON JP.AlE_Cod = A.Id_Alo AND JP.AlE_Prov = 'J107'
		LEFT JOIN	Tbl_AloNTAO			ANT	ON ANT.Id_Alo = A.Id_Alo AND ANT.Id_TAO IN (SELECT Id_TAO FROM PRF_PRO)
		LEFT JOIN	PRF_PRO				PP	ON PP.Id_TAO = ANT.Id_TAO
	WHERE
		A.Alo_borrado = 0
	GROUP BY
		A.Id_Alo, JP.ALU_JPCode, PP.Id_TAR, PP.TAI_Nombre, ANT.Id_TAO, PP.TOI_Nombre
),
ETIQUETAS_JP AS (
	SELECT 
		E.Id_Etiqueta	AS [Id_Etiqueta],
		E.Orden			AS [Orden],
		E.Etiqueta		AS [Etiqueta],
		AUC.AUC_JPCode	AS [JP]
	FROM 
					Tbl_AlojamientoUnicoCliente		AUC
		LEFT JOIN	Tbl_AucNEau						ANE		ON ANE.id_AUC = AUC.id_AUC
		LEFT JOIN	ETIQUETAS						E		ON E.Id_Etiqueta = ANE.id_EAU
	WHERE 
		1 = 1
	GROUP BY 
		E.Id_Etiqueta,
		E.Orden,
		E.Etiqueta,
		AUC.AUC_JPCode
),
RESULTADO AS (
	SELECT 
		FP.ALU_JPCode, FP.Id_Alo, FP.Id_TAR, FP.TAI_Nombre, FP.Id_TAO, FP.TOI_Nombre, EJP.Id_Etiqueta, EJP.Etiqueta, EJP.Orden
	FROM
					FICHAS_PROPIO	FP
		LEFT JOIN	ETIQUETAS_JP	EJP	ON EJP.JP = FP.ALU_JPCode
	GROUP BY
		FP.ALU_JPCode, FP.Id_Alo, FP.Id_TAR, FP.TAI_Nombre, FP.Id_TAO, FP.TOI_Nombre, EJP.Id_Etiqueta, EJP.Etiqueta, EJP.Orden
)

SELECT * FROM RESULTADO WHERE Etiqueta IS NOT NULL
