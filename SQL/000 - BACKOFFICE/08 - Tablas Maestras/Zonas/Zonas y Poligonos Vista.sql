SELECT
	Z_W2M.Id_Zon			AS [ID_ZON],
	Z_W2M.Id_ZonPadre		AS [ID_ZON_PADRE],
	Z_W2M.Zon_idZonBE		AS [ID_ZON_JUN],
	Z_W2M.Zon_Nombre_ES		AS [NOMBRE_ES],
	Z_P_W2M.zpg_coordenadas	AS [COORDENADAS_W2M],
	Z_P_JUN.zpg_coordenadas	AS [COORDENADAS_JUN]

FROM			BD_Nincoming.dbo.Tbl_Zona						Z_W2M
	LEFT JOIN	BD_Nincoming.dbo.Tbl_ZonasPoligono				Z_P_W2M ON Z_P_W2M.Id_Zon = Z_W2M.Id_Zon
	LEFT JOIN	BD_Nincoming.dbo.vwTbl_ZonasPoligono_JUNIPER	Z_P_JUN ON Z_P_JUN.Id_Zon = Z_W2M.Zon_idZonBE
