USE BD_Nincoming;
SELECT
	R.Res_Estado,
	R.Res_Localizador,
	RE.Rex_PlatformBookingReference,
	R.Id_Can,
	R.Id_Ifz,
	R.Feccre
FROM
				Tbl_Reserva				R
	INNER JOIN	Tbl_ReservaExtendida	RE	ON R.id_Res = RE.id_Res
WHERE 
	1 = 1
	AND R.Id_Can = 'WPRO'
	AND R.Id_Ifz = 'XML'
	AND RE.Rex_PlatformBookingReference IS NULL
ORDER BY
	R.Feccre DESC


-- UPDATE Tbl_ReservaExtendida SET Rex_PlatformBookingReference = '$$' WHERE Id_Res = (SELECT Id_Res FROM Tbl_Reserva WHERE Res_Localizador = '$$')
-- INSERT INTO Tbl_Historial (Id_Res, His_Usuario, His_Texto) VALUES ((SELECT Id_Res FROM Tbl_Reserva WHERE Res_Localizador = '$$'), 'José Bausá', '$$');