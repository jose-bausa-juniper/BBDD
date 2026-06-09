USE BD_Comun;

SELECT 
	FCO_Tipo,
	FCO_Name 
FROM 
	Tbl_FormaCobro
WHERE
	FCO_Tipo IN ('JOU','CSH','CRC','BKT')