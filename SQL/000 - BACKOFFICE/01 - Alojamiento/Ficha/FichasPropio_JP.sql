USE BD_Nincoming

-----------------------------------------------------------------

SELECT 
	vjph.AlU_JPCode		AS [JPCode],
	COUNT(*)			AS [NUM]
FROM  
				tbl_alojamiento						AS a  
	FULL JOIN	BD_Nincoming.dbo.vwQlik_JP_Hoteles	AS vjph	ON	vjph.AlE_Cod = CONVERT(VARCHAR(100),a.Id_Alo)
WHERE 
	1 = 1
	AND vjph.AlE_Prov = 'J107'
	AND a.Alo_borrado = 0
GROUP BY
	vjph.AlU_JPCode
HAVING 
	COUNT (*) > 1
ORDER BY
	[NUM] DESC