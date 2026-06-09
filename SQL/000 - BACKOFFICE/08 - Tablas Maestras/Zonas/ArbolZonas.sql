--USE BD_BookingEngine;
--USE BD_Nincoming;

DECLARE @ID_ZON_W2M AS int; 
SET @ID_ZON_W2M = 55747;

DECLARE @ID_ZON_JUN AS int; 
SET @ID_ZON_JUN = 36705;

SELECT  
	zon1.id_zon											AS [Id_zone], 
	zon1.Zon_Nombre_ES									AS [zon_nombre_ES], 
    zon1.zon_codigo										AS [IATA],
	concat(zon1.id_zon,' - ', zon1.zon_nombre_ES)		AS [Zone_Name_Lev1],
	concat(zon2.id_zon,' - ', zon2.Zon_Nombre_ES)		AS [Zone_Name_Lev2],
	concat(zon3.id_zon,' - ', zon3.Zon_Nombre_ES)		AS [Zone_Name_Lev3],
	concat(zon4.id_zon,' - ', zon4.Zon_Nombre_ES)		AS [Zone_Name_Lev4],
	zon1.Zon_Tipo										AS [Zon_Tipo],	
	zon1.Zon_TieneAeropuerto							AS [Zon_TieneAeropuerto]
FROM			tbl_zona zon1
	 LEFT JOIN	tbl_zona zon2 ON zon1.id_ZonPadre = zon2.id_zon
	 LEFT JOIN	tbl_zona zon3 ON zon2.id_ZonPadre = zon3.id_zon
	 LEFT JOIN	tbl_zona zon4 ON zon3.id_ZonPadre = zon4.id_zon
WHERE 
	1 = 1
	AND (((zon1.id_zon = @ID_ZON_W2M or zon2.id_zon = @ID_ZON_W2M) or zon3.id_zon = @ID_ZON_W2M )or zon4.id_zon = @ID_ZON_W2M )
	--AND (((zon1.id_zon = @ID_ZON_JUN or zon2.id_zon = @ID_ZON_JUN) or zon3.id_zon = @ID_ZON_JUN )or zon4.id_zon = @ID_ZON_JUN )


ORDER BY
	[Zone_Name_Lev4] ASC,
	[Zone_Name_Lev3] ASC,
	[Zone_Name_Lev2] ASC,
	[Zone_Name_Lev1] ASC