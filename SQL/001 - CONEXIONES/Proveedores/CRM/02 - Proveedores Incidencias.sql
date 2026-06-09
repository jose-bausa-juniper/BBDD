USE BD_BookingEngine;

DECLARE @CONFIGPROD TABLE (ConfigModule VARCHAR(4));
DECLARE @idcliente INT = 18224;

INSERT INTO @CONFIGPROD
VALUES 
('ADN'),('AGO'),('ATI'),('AVO'),('AVT'),('BOK'),('BON'),('BWD'),('C249'),('CMB'),('CYC1'),('DMA'),('DNG1'),('DOW'),('DTR'),('DY18'),('DY20'),('DY22'),('DY33'),('DYS6'),('DYS9'),('EPL'),('EXR'),('FAST'),('G2T'),('GAR'),('GGBT'),('H2K'),('H2T'),('HB2'),('HDM'),('HIND'),('HL2'),('HLT'),('HP2'),('HRWV'),('HSTC'),('HTD'),('HTS'),('HYG'),('IACC'),('IBR'),('IGEK'),('ITC'),('ITM'),('ITR'),('J054'),('J075'),('J283'),('J407'),('J455'),('J513'),('J542'),('J562'),('J569'),('J640'),('J725'),('JBO'),('LOE'),('LTV'),('M100'),('MED'),('MIK'),('MNQ'),('NAIC'),('NMGO'),('OMB'),('PPKF'),('PABR'),('PAX'),('PHMZ'),('POEU'),('POS'),('PSE'),('PTRN'),('RHK'),('RKT'),('SAL'),('SEE'),('SMB'),('SND'),('STR'),('SUH'),('SY10'),('SY15'),('SY18'),('SY19'),('SY22'),('SY26'),('SY28'),('SY29'),('SY31'),('SY33'),('SY35'),('SY36'),('SY37'),('SY38'),('SY46'),('SY47'),('SY48'),('SY50'),('SY52'),('SY53'),('SY54'),('SY55'),('SY57'),('SY58'),('SY59'),('SY60'),('SY62'),('SY63'),('SY64'),('SY66'),('SY67'),('SY69'),('SYX1'),('SYX2'),('SYX3'),('SYX5'),('SYX6'),('SYX7'),('TBH'),('TDZ'),('TEA'),('TRD'),('TTR'),('TV7'),('UNI'),('VET'),('WYN'),('YGO')

SELECT 
	MODULSINCIDENCIA.ConfigModule									AS [ConfigModule],
	MODULSINCIDENCIA.[ID Proyecto P]								AS [ID Proyecto P],
	MODULSINCIDENCIA.[Nombre Proyecto]								AS [Nombre Proyecto],
	MODULSINCIDENCIA.[ID Módulo PM]									AS [ID Módulo PM],
	MODULSINCIDENCIA.[Nombre Modulo M]								AS [Nombre Modulo M],
	MODULSINCIDENCIA.[Producto]										AS [Producto],
	INCIDENCIA.Id_incidencia										AS [Id_incidencia],
	agencias.dbo.converthtml(INCIDENCIA.I_asumpte)					AS [I_asumpte]
FROM 
	(
	SELECT 
	CONFIG.ConfigModule						AS [ConfigModule],
	MODULSCONF.[ID Proyecto P]				AS [ID Proyecto P],
	MODULSCONF.[Nombre Proyecto]			AS [Nombre Proyecto],
	MODULSCONF.[ID Módulo PM]				AS [ID Módulo PM],
	MODULSCONF.[Nombre Modulo M]			AS [Nombre Modulo M],
	MODULSCONF.[Producto]					AS [Producto]
	FROM 
					@CONFIGPROD AS CONFIG
		LEFT JOIN	(
					SELECT 
						p.p_codi                                        AS [ID Proyecto P],
						p.P_nom                                         AS [Nombre Proyecto],
						pm.MOD_ID                                       AS [ID Módulo PM],
						CASE(pm.PM_estado)
							WHEN 0 THEN 'Live'
							WHEN 1 THEN	'Standby'
							WHEN 2 THEN	'Cancelado'
							WHEN 3 THEN	'Unset'	
						END												AS [Estado],
						m.MOD_nombre_ES                                 AS [Nombre Modulo M],
						mm.MpM_CodigoProducto                           AS [Producto]

					FROM
										agencias.dbo.PROJECTE                 p
						INNER JOIN      agencias.dbo.PROJECTE_MODULO          pm     ON pm.P_codi = p.P_codi
						INNER JOIN      agencias.dbo.MODULO                   m      ON m.MOD_id = pm.MOD_id
						INNER JOIN      agencias.dbo.tbl_MapeadoModulos       mm     ON mm.MOD_id = m.MOD_id
  
					WHERE 
						1 = 1
						AND p.p_client = 18224
						AND p.P_cancelado = 0
						AND pm.PM_estado IN (0,1,2,3) -- 0=Live;1=Standby;2=Cancelado;3=Unset
					GROUP BY
						p.P_codi,
						p.P_nom,
						pm.MOD_ID,
						pm.PM_estado,
						m.MOD_nombre_ES,
						mm.MpM_CodigoProducto
					)	AS MODULSCONF ON MODULSCONF.Producto = CONFIG.ConfigModule
	) AS MODULSINCIDENCIA
	LEFT JOIN	
		(SELECT
			INCI.Id_incidencia,
			agencias.dbo.converthtml(INCI.I_asumpte)		AS [I_asumpte],
			INCI.MOD_id										AS [MOD_id]
		FROM
			(SELECT
				MIN(Id_incidencia)	AS [Id_incidencia],
				MOD_id				AS [MOD_id]
			FROM
				agencias.dbo.INCIDENCIA
			WHERE
				A_codi = 18224
			GROUP BY
				MOD_id
			) AS MAX_INCI_X_MOD
			INNER JOIN agencias.dbo.INCIDENCIA INCI ON INCI.Id_incidencia = MAX_INCI_X_MOD.Id_incidencia
		)	AS INCIDENCIA ON (MODULSINCIDENCIA.[ID Módulo PM] = INCIDENCIA.MOD_id)	

WHERE 
	1 = 1
GROUP BY
	MODULSINCIDENCIA.ConfigModule,
	MODULSINCIDENCIA.[ID Proyecto P],
	MODULSINCIDENCIA.[Nombre Proyecto],
	MODULSINCIDENCIA.[ID Módulo PM],
	MODULSINCIDENCIA.[Nombre Modulo M],
	MODULSINCIDENCIA.[Producto],
	INCIDENCIA.Id_incidencia,
	INCIDENCIA.I_asumpte