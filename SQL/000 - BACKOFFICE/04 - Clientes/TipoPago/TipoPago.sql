SELECT 
Id_Cli AS ID_Cli,
Cli_Nombre AS CLI_Nombre,
Cli_TipoPago AS Pago,
GRA_Nombre AS Grupo_Agencia,
Mer_Nombre AS Mercado
FROM BD_Nincoming.dbo.Tbl_Cliente C 
INNER JOIN BD_Nincoming.dbo.Tbl_GrupoAgencia GA ON GA.Id_GRA = C.Id_GRA
INNER JOIN BD_Nincoming.dbo.Tbl_Mercado M ON M.Id_Mer = GA.Id_Mer
WHERE Cli_Activa = 1 AND Cli_TipoPago = 'T' 
ORDER BY Mer_Nombre,GRA_Nombre