DECLARE @VALORES_BUSCADOS TABLE (Valores VARCHAR(50));

INSERT INTO @VALORES_BUSCADOS VALUES
('Workmind')
,('Travellights')
,('Pythagoras')
,('TRAWEX')
,('Europlayas')
,('RTS')
,('CC Group')
,('NetStorming')
,('Riya Holidays')
,('Tyrex Travel')
,('Travelodeal Limited')
,('Europa Destinos')
,('Travelsup Turizm')
,('BusyRooms')
,('Kumo')
,('Tripedge')
,('Top Group Express')
,('STS Vacations')
,('Guangzhou Qiaoyi')
,('RateTiger')
,('Travware')
,('VNTravel Group')
,('Cyberlogic')
,('Peakwork')
,('SAMO - SAMOSoft')
,('Tee Times')
,('Grupotel')
,('Yanolja Cloud Solution')
,('Beyond Experience')
,('eMind GmbH')
,('EnkoSoft Company SRL')
,('Hotelp.app')
,('Rsv-service')
,('TravelClick')
,('Paxport - Multicom')
,('TeamSystem Hospitality - Evols')
,('FNSRooms')
,('Autoupdate-PMS')
,('Etravel-way - RoomsInCloud')
,('Hotel Availabilities')
,('Zeus Tech')
,('primalRES')
,('Ermes Hotels by Blastness')
,('TUI Group')
,('Agoda')
,('WuBook')
,('B&A e-Travel')
,('Atrapalo')
,('Booking Expert')
,('Tee Times')
,('TopDog')
,('BusyRooms')
,('e-GDS')
,('Umbrella Travel')
,('OnTheBeach')
,('LeoRevoo')
,('SDH - Memorandum')
,('APC')
,('Winhotelsolution')
,('Conecta Turismo')
,('RateGain')


SELECT
	(SELECT TOP 1 V.Valores
	FROM @VALORES_BUSCADOS V
	WHERE pm.PM_TextoAdicional LIKE '%' + V.Valores + '%') AS MatchSubModulo,
	(SELECT TOP 1 V.Valores
	FROM @VALORES_BUSCADOS V
	WHERE m.MOD_nombre_ES LIKE '%' + V.Valores + '%') AS MatchModulo,
	p.P_nom,
	p.P_codi,
	pm.MOD_id,
	m.MOD_nombre_ES,
	pm.Id_PM,
	pm.PM_TextoAdicional,
    CASE    p.p_estat
        WHEN 1 THEN 'Inicio'
        WHEN 2 THEN 'Diseño'
        WHEN 3 THEN 'Implantación'
        WHEN 4 THEN 'Testing'
        WHEN 5 THEN 'Preproducción'
        WHEN 6 THEN 'Producción'
        WHEN 7 THEN 'Acción comercial'
    END										AS [Estado Proyecto],
    CASE    pm.PM_estado
        WHEN 0 THEN 'Live'
        WHEN 1 THEN 'StandBy'
        WHEN 2 THEN 'Cancelado'
        WHEN 3 THEN 'UnSet'
    END										AS [Estado Modulo]	
FROM
				agencias.dbo.PROJECTE p
	LEFT JOIN	agencias.dbo.PROJECTE_MODULO pm ON pm.P_codi = p.P_codi
	LEFT JOIN 	agencias.dbo.MODULO m ON m.MOD_id = PM.MOD_id
WHERE 
	1 = 1
	AND p.P_client = 18224
	--AND (pm.PM_TextoAdicional  LIKE @SEARCH OR m.MOD_nombre_ES LIKE @SEARCH)
	AND (EXISTS (SELECT 1 FROM  @VALORES_BUSCADOS WHERE  pm.PM_TextoAdicional LIKE '%'+Valores+'%') OR EXISTS (SELECT 1 FROM  @VALORES_BUSCADOS WHERE m.MOD_nombre_ES LIKE '%'+Valores+'%'))



ORDER BY
	p.p_codi DESC,
	pm.PM_TextoAdicional DESC


SELECT
	(SELECT TOP 1 V.Valores
	FROM @VALORES_BUSCADOS V
	WHERE pal.PalNombre LIKE '%' + V.Valores + '%') AS MatchComplemento,
	p.P_codi,
	p.P_nom,
	pal.Id_Pal,
	pal.PalNombre,
    pal.PalCancelado                         AS [PAL_Cancelado]
FROM
				agencias.dbo.PROJECTE p
	LEFT JOIN	agencias.dbo.PROJECTE_ALTRES pal ON pal.PalProyecto = p.P_codi
WHERE 
	1 = 1
	AND p.P_client = 18224
	--AND pal.PalNombre LIKE @SEARCH
	AND EXISTS (SELECT 1 FROM  @VALORES_BUSCADOS WHERE  pal.PalNombre LIKE '%'+Valores+'%')
ORDER BY
	p.p_codi DESC,
	pal.PalNombre DESC