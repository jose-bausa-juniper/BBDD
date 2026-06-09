USE BD_BookingEngine
SELECT top 10 Faa_Prov, Faa_Imagenes
FROM Tbl_FichaAlojamientoAplanada
WHERE 1=1
AND Faa_Prov = 'ADN'
AND Faa_Imagenes is not null





