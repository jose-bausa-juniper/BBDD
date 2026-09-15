WITH 
PAL AS (
    SELECT
        P_codi,
        Id_Pal,
        PalNombre
    FROM
                    agencias.dbo.PROJECTE           P
        LEFT JOIN   agencias.dbo.PROJECTE_ALTRES    PA ON PA.PalProyecto = P.P_codi AND PA.PalCancelado = 0
    WHERE
            P.P_client = 18224
        AND PA.PalNombre LIKE '[[]%'
),

TODAS_FACTURAS AS (
    SELECT
        DISTINCT
        MAX(F.Id_Fac)                                       AS LAST_FACTURA,
        PA.P_codi,
        PA.Id_Pal,
        PA.PalNombre,
        MAX(LF.Id_LFa)                                      AS LAST_LINEA_FACTURA,
        LF.LFa_IdTipo,
        LF.LFa_Tipo,
        CONCAT (LF.P_Codi,'-',LF.LFa_Tipo,'-',LF.LFa_IdTipo) AS Articulo_factura,
        LF.LFa_Concepto
    FROM 
                    agencias.dbo.TBL_FACTURA        F
        INNER JOIN  agencias.dbo.TBL_LINEAFACTURA   LF ON LF.Id_Fac = F.Id_Fac
        INNER JOIN  PAL                             PA ON PA.Id_Pal = LF.LFa_idTipo   
    WHERE 
            F.A_Codi = 18224
        AND LF.LFa_Tipo IN ('OT1','OT2','OT3')
        AND F.Fac_Fecha BETWEEN '2025-08-01' AND '2026-09-09'
    GROUP BY
        PA.P_codi,
        PA.Id_Pal,
        PA.PalNombre,
        LF.LFa_IdTipo,
        LF.LFa_Tipo,
        LF.P_Codi,
        LF.LFa_Concepto
)
SELECT
    --TOP 0
    LFa_Concepto,
    PalNombre,
    P_codi,
    Id_Pal,
    Articulo_factura
FROM
    TODAS_FACTURAS 
WHERE
        PalNombre <> LFa_Concepto 
    --AND (LFa_Concepto LIKE '%Soporte XML%' OR LFa_Concepto LIKE '%[[]%%')
ORDER BY 
    Articulo_factura DESC


    -- SELECT
    --     DISTINCT
    --     LF.P_Codi,
    --     LF.LFa_Tipo,
    --     LF.LFa_IdTipo,
    --     CONCAT (LF.P_Codi,'-',LF.LFa_Tipo,'-',LF.LFa_IdTipo) AS Articulo_factura,
    --     LF.LFa_Concepto,
    --     PA.PalNombre,
    --     PA.PalCancelado
    -- FROM 
    --                 agencias.dbo.TBL_FACTURA        F
    --     LEFT JOIN   agencias.dbo.TBL_LINEAFACTURA   LF ON LF.Id_Fac = F.Id_Fac
    --     LEFT JOIN   agencias.dbo.PROJECTE_ALTRES    PA ON PA.Id_Pal = LF.LFa_idTipo   
    -- WHERE 
    --         F.A_Codi = 18224
    --     AND LF.LFa_Tipo IN ('OT1','OT2','OT3')
    --     AND F.Fac_Fecha BETWEEN '2025-09-01' AND '2026-09-01'
    --     AND PA.PalNombre NOT LIKE '%[[]%'
    --     AND PA.PalCancelado = 0
    --     --AND PA.Id_Pal NOT IN (9477,9507,9575,9580,9597)
    --     AND LF.P_Codi NOT IN (6220,7844)
    -- GROUP BY
    --     LF.P_Codi,
    --     LF.LFa_IdTipo,
    --     LF.LFa_Tipo,
    --     LF.LFa_Concepto,
    --     PA.PalNombre,
    --     PA.PalCancelado