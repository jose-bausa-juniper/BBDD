USE BD_Nincoming

SELECT
	Z_W2M.Id_Zon,
	Z_W2M.Id_ZonPadre,
	Z_W2M.Zon_idZonBE,
	Z_W2M.Zon_Nombre_ES,
	Z_W2M_P.zpg_coordenadas
	
	---

FROM			BD_Nincoming.dbo.Tbl_Zona			Z_W2M
	LEFT JOIN	BD_Nincoming.dbo.Tbl_ZonasPoligono	Z_W2M_P ON Z_W2M_P.Id_Zon = Z_W2M.Id_Zon
WHERE 
	1 = 1
	--AND ZP.zpg_coordenadas IS NOT NULL -- ZONAS CUSTOM W2M CON POLIGONO
	--AND (Z.Zon_idZonBE IS NOT NULL AND ZP.zpg_coordenadas IS NOT NULL) -- ZONAS JUNIPER CON POLIGONO EDITADO
	--AND (Z.Zon_idZonBE IS NULL AND ZP.zpg_coordenadas IS NOT NULL) -- ZONAS CUSTOM W2M CON POLIGONO
	--AND Z.Zon_idZonBE IS NULL -- ZONAS W2M
	--AND (Z.Zon_idZonBE IS NULL AND ZP.zpg_coordenadas IS NULL) -- ZONAS W2M SIN POLIGONO
	--AND (Z.Zon_idZonBE IS NOT NULL AND ZP.zpg_coordenadas IS NULL) -- ZONAS CON POLIGONO JUNIPER
	