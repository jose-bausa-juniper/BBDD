USE BD_Nincoming

-----------------------------------------------------------------

SELECT 
	vjph.AlU_JPCode AS [JPCode]
	,a.id_alo AS [HBE]
   	,a.Alo_DirFoto AS [Alo_DirFoto]
    ,ia.ImA_Ruta AS [ImA_Ruta]
    ,LEFT(ia.ImA_Ruta,LEN(ImA_Ruta) - CHARINDEX('/',REVERSE(ia.ImA_Ruta),1)) AS [Carpeta]
FROM  
				tbl_alojamiento						AS a  
	FULL JOIN	BD_Nincoming.dbo.vwQlik_JP_Hoteles	AS vjph	ON	vjph.AlE_Cod = CONVERT(VARCHAR(100),a.Id_Alo)
    FULL JOIN  Tbl_ImagenesAlojamiento             AS ia   ON ia.id_Alo = a.id_Alo
WHERE 1 = 1
	AND vjph.AlE_Prov = 'J107'
ORDER BY
	(vjph.AlU_JPCode) DESC