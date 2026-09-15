SELECT
	*
FROM
	BD_Nincoming_HIS.dbo.Tbl_DesconexionAutomaticaBlockedElement_HIS 
WHERE 
	Dbh_Proveedor = 'AVT'
	AND Feccre > GETDATE()-3
ORDER BY
	Feccre DESC