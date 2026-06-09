DECLARE @ALOJAMIENTOS_NOTIFICABLES TABLE (ID_ALO INT, IWS NVARCHAR(400));
DECLARE @LINEAS_RESERVA_NOTIFICABLES TABLE (ID_ALO INT, ID_LRE INT, RES_MOD DATETIME, LRE_MOD DATETIME, FECHAINI DATETIME);

INSERT INTO @ALOJAMIENTOS_NOTIFICABLES
    SELECT
        DISTINCT
        A.Id_Alo,
        IWS.Int_Nombre
    FROM
                    Tbl_IntegradorWS    IWS
        INNER JOIN  Tbl_UsuarioExtranet UE  ON UE.id_Int = IWS.id_Int
        INNER JOIN  Tbl_UsENAlo         UEA ON UEA.Id_Alo = UE.Id_UsE
        INNER JOIN  Tbl_Alojamiento     A   ON A.Id_Alo = UEA.Id_Alo
    WHERE
        1 = 1
        AND A.Alo_borrado = 0
        AND UE.Id_Int IN (84,101,347,458) -- TravelClick-EzYield (Legacy); CloudHospitaly; TravelClick; Cloudbeds

SELECT COUNT(*) AS [TODOS_ALOJAMIENTOS_NOTIFICABLES] FROM @ALOJAMIENTOS_NOTIFICABLES

INSERT INTO @LINEAS_RESERVA_NOTIFICABLES
    SELECT
        RA.Id_Alo,
        LR.Id_LRE,
        R.Res_FechaUltimaModificacion,
        LR.Lre_UltimaModificacion,
        LR.LRe_finiViaje
    FROM
                    (SELECT Id_Res, Res_FechaUltimaModificacion FROM TBl_Reserva)           R
        INNER JOIN  (SELECT LRe_Tipo,Id_Lre, Id_Res, Lre_UltimaModificacion, LRe_finiViaje FROM Tbl_LineaReserva)   LR  ON (LRe_Tipo = 'A' AND LR.Id_Res = R.Id_Res)
        INNER JOIN  (SELECT Id_Lre, Id_Alo, RAl_FechaEntrada FROM Tbl_ReservaAlojamiento)    RA  ON (RA.id_Lre = LR.id_Lre)
    WHERE
        1 = 1
        AND RA.Id_Alo IN (SELECT ID_ALO FROM @ALOJAMIENTOS_NOTIFICABLES)
       -- AND LR.LRe_finiViaje > GETDATE () - 180
        AND (R.Res_FechaUltimaModificacion > GETDATE() -90 OR LR.Lre_UltimaModificacion > GETDATE() -90)
SELECT COUNT(*) AS [LINEAS_RESERVA_NOTIFICABLES] FROM @LINEAS_RESERVA_NOTIFICABLES