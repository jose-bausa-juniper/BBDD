DECLARE @CLI INT = 107;

WITH TodasSubidas AS (
    SELECT
        BD.Id_BDD       AS ID_EMPRESA,
        BD.BDD_Empresa  AS EMPRESA,
        W.ID_BDD,
        CASE W.id_web
            WHEN 1278 THEN 'DMC'
            WHEN 2009 THEN 'NEXT'
            WHEN 1920 THEN 'FLOWO'
            ELSE CAST(W.id_WEB AS VARCHAR(5))
        END AS WEB,
        U.U_nom AS USUARIO,
        B.bak_comentario AS COMENTARIO,
        B.bak_fichero AS FICHERO,
        B.Feccre AS FECHA_PRE,
        B.bak_entorno AS ENTORNO,
        B.bak_operacion AS OPERACION,
        B.bak_dlls AS DLLS,
        B.bck_id_proceso AS PROCESO
    FROM BD_BookingEngine.dbo.Tbl_Web W
    INNER JOIN BD_BookingEngine.dbo.Tbl_Backups B ON B.Id_web = W.id_WEB
    INNER JOIN agencias.dbo.usuari U ON U.id_Usuari = B.Id_usuario
    INNER JOIN BD_BookingEngine.dbo.Tbl_BaseDatos BD ON BD.Id_BDD = W.id_BDD
    WHERE 1=1
      --AND W.ID_BDD = @CLI
      AND B.bak_entorno IN ('WWW', 'PRE')
),
UltimasWWW AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY WEB ORDER BY FECHA_PRE DESC) AS rn
    FROM TodasSubidas
    WHERE ENTORNO = 'WWW'
),
UltimaWWW AS (
    SELECT * FROM UltimasWWW WHERE rn = 1
),
PenultimaWWW AS (
    SELECT * FROM UltimasWWW WHERE rn = 2
),
UltimaPRE AS (
    SELECT *
    FROM (
        SELECT *,
               ROW_NUMBER() OVER (PARTITION BY WEB ORDER BY FECHA_PRE DESC) AS rn
        FROM TodasSubidas TS
        WHERE ENTORNO = 'PRE'
    ) p
    WHERE rn = 1
),
PREAntesDeUltimaWWW AS (
    SELECT p.*, w.FECHA_PRE AS FECHA_WWW, 'PRE antes de última WWW' AS TIPO
    FROM TodasSubidas p
    JOIN UltimaWWW w ON p.WEB = w.WEB AND p.FECHA_PRE < w.FECHA_PRE
    WHERE p.ENTORNO = 'PRE'
),
PREAntesDePenultimaWWW AS (
    SELECT p.*, w.FECHA_PRE AS FECHA_WWW, 'PRE antes de penúltima WWW' AS TIPO
    FROM TodasSubidas p
    JOIN PenultimaWWW w ON p.WEB = w.WEB AND p.FECHA_PRE < w.FECHA_PRE
    WHERE p.ENTORNO = 'PRE'
),
PREsFiltrados AS (
    SELECT * FROM (
        SELECT *, ROW_NUMBER() OVER (PARTITION BY WEB, TIPO ORDER BY FECHA_WWW DESC, FECHA_PRE DESC) AS rn
        FROM (
            SELECT * FROM PREAntesDeUltimaWWW
            UNION ALL
            SELECT * FROM PREAntesDePenultimaWWW
        ) x
    ) y
    WHERE rn = 1
),
CasuisiticaPorWEB AS (
    SELECT WEB,
           MAX(CASE WHEN ENTORNO = 'PRE' THEN FECHA_PRE ELSE NULL END) AS UltimaPRE,
           MAX(CASE WHEN ENTORNO = 'WWW' THEN FECHA_PRE ELSE NULL END) AS UltimaWWW,
           CASE 
               WHEN MAX(CASE WHEN ENTORNO = 'PRE' THEN FECHA_PRE ELSE NULL END) > 
                    MAX(CASE WHEN ENTORNO = 'WWW' THEN FECHA_PRE ELSE NULL END)
               THEN 'PRE'
               ELSE 'WWW'
           END AS CASUISTICA 
    FROM TodasSubidas
    GROUP BY WEB
),
Resultado AS (
    -- PRE: último PRE y PRE antes de última WWW
    SELECT 
        p.ID_EMPRESA, p.EMPRESA, p.WEB, p.USUARIO,
        p.COMENTARIO, p.FICHERO, p.FECHA_PRE, p.ENTORNO,
        p.OPERACION, p.DLLS, p.PROCESO,'Último PRE' AS TIPO,
        c.CASUISTICA , CAST(NULL AS DATETIME) AS FECHA_WWW
    FROM UltimaPRE p
    JOIN CasuisiticaPorWEB c ON p.WEB = c.WEB
    WHERE c.CASUISTICA  = 'PRE'
    UNION ALL
    SELECT 
        p.ID_EMPRESA, p.EMPRESA, p.WEB, p.USUARIO,
        p.COMENTARIO, p.FICHERO, p.FECHA_PRE, p.ENTORNO,
        p.OPERACION, p.DLLS, p.PROCESO, p.TIPO,
        c.CASUISTICA, p.FECHA_WWW
    FROM PREsFiltrados p
    JOIN CasuisiticaPorWEB c ON p.WEB = c.WEB
    WHERE (c.CASUISTICA  = 'PRE' AND p.TIPO = 'PRE antes de última WWW')
       OR (c.CASUISTICA  = 'WWW' AND p.TIPO IN ('PRE antes de última WWW', 'PRE antes de penúltima WWW'))
)
SELECT 
EMPRESA,
WEB,
USUARIO,
ENTORNO,
TIPO,
DLLS,
PROCESO,
FECHA_PRE,
COMENTARIO,
FECHA_WWW
FROM Resultado WHERE  EMPRESA = 'W2M'
ORDER BY EMPRESA, WEB, FECHA_PRE DESC
