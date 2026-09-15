--DATOS RESERVA
SELECT
	R.id_Res, LR.id_Lre, LR.Id_Zon
FROM
				Tbl_Reserva			R
	LEFT JOIN	TBL_LineaReserva	LR  ON LR.id_res = R.id_Res
WHERE
	Res_Localizador = 'RPTP5P' AND id_lre = 37403217;

--ZONA
SELECT * FROM tbl_zona WHERE Zon_Nombre_EN = 'Thailand';


--UPDATE
UPDATE
	Tbl_LineaReserva
SET
	Id_Zon = 55762,
	Lre_UltimaModificacion = GETDATE (),
	FecMod = GETDATE()
WHERE 
	Id_LRe = 37403217;

UPDATE
	Tbl_Reserva
SET
	Res_FechaUltimaModificacion = GETDATE(),
	FecMod = GETDATE()
WHERE 
	Res_Localizador = 'RPTP5P';

--HISTORIAL
INSERT INTO Tbl_Historial (Id_Res, Id_LRe, His_Usuario, His_Fecha, His_Texto) 
SELECT 
	Id_Res,
	Id_LRe,
	'Jun:José Bausá García', 
	GETDATE(),  
	'<text><es>Zona y fechas de modificación actualizadas, solicitado en incidencia 1124263</es><en>Area and modification date updated, as requested in ticket 1124263</en></text>'
FROM
	TBL_LineaReserva
WHERE
	id_lre = 37403217;