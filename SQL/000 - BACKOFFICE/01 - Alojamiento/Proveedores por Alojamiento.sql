WITH ALO_CCO_PRO AS (
SELECT 
    A.Id_Alo,
    CCA.Id_CCo,
    CASE 
        WHEN CCAE.Id_Pro IS NULL THEN A.Id_Pro
        ELSE CCAE.Id_Pro
    END AS ID_PRO,
    CASE 
        WHEN CCAE.Id_Pro IS NULL THEN P.Pro_Nombre
        ELSE P1.Pro_Nombre
    END AS PROV
FROM 
                TBL_Alojamiento                     A
    LEFT JOIN   Tbl_Proveedor                       P       ON P.Id_Pro = A.Id_Pro
    LEFT JOIN   Tbl_ContratoCompraAloja             CCA     ON CCA.Id_Alo = A.Id_Alo
    LEFT JOIN   Tbl_ContratoCompraAlojaExtendido    CCAE    ON CCAE.Id_CCo = CCA.Id_CCo
    LEFT JOIN   Tbl_Proveedor                       P1      ON P1.Id_Pro = CCAE.Id_Pro
),
COLISION AS (
SELECT
    COUNT(DISTINCT(Id_Pro)) NUM, Id_Alo
FROM
    ALO_CCO_PRO
GROUP BY Id_Alo
HAVING COUNT(DISTINCT(Id_Pro)) > 2
)

SELECT 
id_Alo, MAX(Id_CCo) MAX_CONTRACT, COUNT (Id_CCo) NUM_CONTRACT, ID_PRO, PROV
FROM ALO_CCO_PRO WHERE Id_Alo IN (SELECT Id_Alo FROM COLISION)
GROUP BY
id_Alo, ID_PRO, PROV
