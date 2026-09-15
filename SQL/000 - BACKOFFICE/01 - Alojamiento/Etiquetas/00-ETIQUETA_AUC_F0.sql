SELECT 
	INE.IEI_Desc	AS [Etiqueta],
	EAU.id_EAU		AS [Id_Etiqueta]
FROM 
				Tbl_EtiquetaAlojaUnicoCliente	EAU		
	LEFT JOIN	Tbl_IdiNEtiqueta				INE		ON (EAU.id_EAU = INE.id_EAU AND INE.id_Idi = 'es')
ORDER BY
	EAU.EAU_Orden