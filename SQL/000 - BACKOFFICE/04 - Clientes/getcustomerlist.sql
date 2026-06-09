USE BD_Nincoming
-- Tbl_Cliente

    -- Grupo de gestion
        SELECT TOP 1 Cli_Ggestion, * FROM Tbl_Cliente WHERE Cli_Ggestion=0
        SELECT TOP 1 Cli_Ggestion, * FROM Tbl_Cliente WHERE Cli_Ggestion=1

    -- Acceso reservas web externa
        SELECT TOP 1 Cli_AccesoWeb , * FROM Tbl_Cliente WHERE Cli_AccesoWeb =0
        SELECT TOP 1 Cli_AccesoWeb , * FROM Tbl_Cliente WHERE Cli_AccesoWeb =1

-- Tbl_ClienteConfiguracion

    -- Creacion de reservas
    SELECT TOP 1 CCl_CreacionReservas, * FROM  Tbl_ClienteConfiguracion WHERE CCl_CreacionReservas = 1
    SELECT TOP 1 CCl_CreacionReservas, * FROM  Tbl_ClienteConfiguracion WHERE CCl_CreacionReservas = 0