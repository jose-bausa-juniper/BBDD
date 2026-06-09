USE BD_Nincoming;
SELECT GREATEST(([ID CENTRAL]), ([ID SUCURSAL])) FROM
(SELECT
DISTINCT(C.Id_Cli) AS [ID CENTRAL],
CCl_VerReservasMisSucursales AS [VER],
CCl_CancelarReservasMisSucursales AS [CAN],
CCl_ModificarReservasMisSucursales AS [MOD],
MAX(S.Id_Cli)  AS [ID SUCURSAL]

FROM 
			Tbl_Cliente					S
LEFT JOIN	Tbl_Cliente					C	ON S.Cli_IdCentral = C.Id_Cli 
LEFT JOIN	Tbl_ClienteConfiguracion	CC	ON C.Id_Cli = CC.Id_Cli
WHERE
1 = 1
AND S.Cli_IdCentral IS NOT NULL
AND S.Cli_Activa = 1
AND C.Cli_Activa = 1


GROUP BY C.Id_Cli,CCl_VerReservasMisSucursales,CCl_CancelarReservasMisSucursales,CCl_ModificarReservasMisSucursales) AS T GROUP BY VER, CAN, MOD


SELECT
MAX(C.Id_Cli) AS [ID CENTRAL],
CCl_VerReservasMisSucursales AS [VER],
CCl_CancelarReservasMisSucursales AS [CAN],
CCl_ModificarReservasMisSucursales AS [MOD],
MAX(S.Id_Cli)  AS [ID SUCURSAL]

FROM 
			Tbl_Cliente					S
LEFT JOIN	Tbl_Cliente					C	ON S.Cli_IdCentral = C.Id_Cli 
LEFT JOIN	Tbl_ClienteConfiguracion	CC	ON C.Id_Cli = CC.Id_Cli
WHERE
1 = 1
AND S.Cli_IdCentral IS NOT NULL
AND S.Cli_Activa = 1
AND C.Cli_Activa = 1


GROUP BY CCl_VerReservasMisSucursales,CCl_CancelarReservasMisSucursales,CCl_ModificarReservasMisSucursales