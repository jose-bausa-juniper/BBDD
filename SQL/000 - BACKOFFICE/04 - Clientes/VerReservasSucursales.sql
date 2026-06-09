-- CENTRALES
-- LISTAMOS AGENCIAS CENTRALES ACTIVAS CON SUCURSALES ASOCIADAS
SELECT DISTINCT(cli_IdCentral) 
FROM tbl_cliente 
WHERE cli_Activa = 1 
AND cli_IdCentral IS NOT NULL

--VEMOS CONFIGURACIÓN ACTUAL DEL CHECK VER RESERVAS DE MIS SUCURSALES A NIVEL DE AGENCIA PARA LOS IDs OBTENIDOS PREVIAMENTE
SELECT CCl_VerReservasMisSucursales 
FROM Tbl_ClienteConfiguracion 
WHERE Id_Cli IN (
                SELECT DISTINCT(cli_IdCentral) 
                FROM tbl_cliente 
                WHERE cli_Activa = 1 
                AND cli_IdCentral IS NOT NULL
                )

--SETEAMOS EL CHECK VER RESERVAS DE MIS SUCURSALES A NIVEL DE AGENCIA PARA LOS IDs DE AGENCIA OBTENIDOS PREVIAMENTE a 1 (TRUE)
UPDATE Tbl_ClienteConfiguracion
SET CCl_VerReservasMisSucursales = 1
WHERE Id_Cli IN (
                SELECT DISTINCT(cli_IdCentral) 
                FROM tbl_cliente 
                WHERE cli_Activa = 1 
                AND cli_IdCentral IS NOT NULL
                )

 

-- AGENTES DE AGENCIAS CENTRALES SELECCIONADAS PREVIAMENTE, ACTIVOS, WEB Y QUE PUEDAN VER OTRAS RESERVAS
SELECT Id_CAg
FROM tbl_clienteagente 
WHERE cag_Activo =1   
AND cag_AccesoAPi=0
AND CAg_VerOtrasReservas=1
AND Id_Cli IN (
                SELECT DISTINCT(cli_IdCentral) 
                FROM tbl_cliente 
                WHERE cli_Activa = 1 
                AND cli_IdCentral IS NOT NULL
                )

-- SETEAMOS EL CHECK VER RESERVAS DE MIS SUCURSALES A NIVEL DE AGENTE PARA LOS IDs DE AGENCIA OBTENIDOS PREVIAMENTE a 1 (TRUE)
UPDATE tbl_clienteagente
SET CAg_VerReservasSucursales = 1
WHERE Id_CAg IN (
                SELECT Id_CAg
                FROM tbl_clienteagente 
                WHERE cag_Activo =1   
                AND cag_AccesoAPi=0
                AND CAg_VerOtrasReservas=1
                AND Id_Cli IN (
                                SELECT DISTINCT(cli_IdCentral) 
                                FROM tbl_cliente 
                                WHERE cli_Activa = 1 
                                AND cli_IdCentral IS NOT NULL
                                )
                )

