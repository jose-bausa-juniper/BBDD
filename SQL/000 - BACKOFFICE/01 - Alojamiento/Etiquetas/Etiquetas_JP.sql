-- JPs Con etiqueta
USE BD_Nincoming
SELECT 
	aucne.id_EAU			AS Id_Etiqueta,
	eau.EAU_Orden			AS Orden,
	ine.id_Idi				AS Idioma,
	ine.IEI_Desc			AS Etiqueta,
	auc.AUC_JPCode			AS JPs
FROM			Tbl_AlojamientoUnicoCliente		auc
	INNER JOIN	Tbl_AucNEau						aucne	ON auc.id_AUC = aucne.id_AUC
	INNER JOIN	Tbl_EtiquetaAlojaUnicoCliente	eau		ON aucne.id_EAU = eau.id_EAU
	INNER JOIN	Tbl_IdiNEtiqueta				ine		ON aucne.id_EAU = ine.id_EAU
WHERE 
	1 = 1
	AND ine.id_Idi = 'es'
	AND auc.AUC_JPCode IN ('JP03469P', 'JP044493', 'JP054657', 'JP056203', 'JP056474', 'JP06367Q', 'JP063705', 'JP063707', 'JP06488Z', 'JP06543C', 'JP06753T', 'JP06987J', 'JP07335D', 'JP07681M', 'JP08431H', 'JP095518', 'JP102077', 'JP10335N', 'JP114262', 'JP116384', 'JP145715', 'JP201599', 'JP202028', 'JP203828', 'JP250987', 'JP308331', 'JP328911', 'JP33547V', 'JP33556L', 'JP35973J', 'JP36005W', 'JP390076', 'JP635838', 'JP744279', 'JP745398', 'JP771061', 'JP785479', 'JP843487', 'JP848578')
GROUP BY 
	aucne.id_EAU,
	eau.EAU_Orden,
	ine.id_Idi,
	ine.IEI_Desc,
	auc.AUC_JPCode
ORDER BY Orden

--------------Recuento--------------
USE BD_Nincoming
SELECT 
	aucne.id_EAU			AS Id_Etiqueta,
	eau.EAU_Orden			AS Orden,
	ine.id_Idi				AS Idioma,
	ine.IEI_Desc			AS Etiqueta,
	COUNT (auc.AUC_JPCode)	AS JPs
FROM			Tbl_AlojamientoUnicoCliente		auc
	INNER JOIN	Tbl_AucNEau						aucne	ON auc.id_AUC = aucne.id_AUC
	INNER JOIN	Tbl_EtiquetaAlojaUnicoCliente	eau		ON aucne.id_EAU = eau.id_EAU
	INNER JOIN	Tbl_IdiNEtiqueta				ine		ON aucne.id_EAU = ine.id_EAU
WHERE 
	1 = 1
	AND ine.id_Idi = 'es'
GROUP BY 
	aucne.id_EAU,
	eau.EAU_Orden,
	ine.id_Idi,
	ine.IEI_Desc
ORDER BY Orden











