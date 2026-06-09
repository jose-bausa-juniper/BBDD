--LISTADO PUSH EDF--

SELECT 
c.id_cli,
c.Cli_Nombre,
iws.Int_Nombre,
cea.Cea_Hora,
cea.Cea_Dias
       
FROM tbl_cliente c 
INNER JOIN Tbl_ConfiguracionConexionAgencia cca  ON c.Id_Cli = cca.Id_Cli
INNER JOIN Tbl_IntegradorWS iws ON c.id_int = iws.id_int
FULL JOIN Tbl_ConfiguracionEjecucionAgencia cea ON cca.Id_Cca = cea.Id_Cca
WHERE C.Cli_Activa = 1
ORDER BY

c.Id_Cli ASC