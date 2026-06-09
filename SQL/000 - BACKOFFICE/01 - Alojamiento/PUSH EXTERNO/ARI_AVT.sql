/*
https://devops.itjuniper.com/tfs/juniperConsulting/BookingEngine/_git/BookingEngine?path=/BookingEngine_v35a_test/LibreriaInt/HotelBookingEngineInt/SistemaExterno/SupplierPush.vb&version=GBmaster&line=6&lineEnd=12&lineStartColumn=1&lineEndColumn=13&lineStyle=plain&_a=contents
Public Enum tIntegracion As Byte
    Synxis = 1
    Avantio = 2
    Derby = 3
    Shiji = 4
    BestWestern = 5
End Enum
*/

WITH

CONFIGS_PUSH AS (
    SELECT
        Id_SuP,SuP_Nombre,SuP_TipoIntegracion
    FROM
        Tbl_AlojaSupplierPushConfig 
    WHERE
        SuP_TipoIntegracion = 2
),

FICHAS_AVT AS (
    SELECT 
        AlE_Cod, AlE_Nombre,ALU_JPCode
    FROM
        vwQlik_JP_Externos
    WHERE
        AlE_Prov = 'AVT'
),

FULL_ELEMENTOS AS (
    SELECT
        *
    FROM
        Tbl_AlojaSupplierPushElemento
    WHERE
        Id_SuP IN (SELECT Id_SuP FROM CONFIGS_PUSH)
),

ELEMENTOS_FICHAS AS (
    SELECT 
        CASE
            WHEN Id_SPE IS NULL THEN 'FICHA SIN PUSH'
            WHEN AlE_Cod IS NULL THEN 'PUSH SIN FICHA'
            ELSE 'PUSH CON FICHA'
        END AS CASO,
        * 
    FROM 
                    FULL_ELEMENTOS  FE 
        FULL JOIN   FICHAS_AVT      FA ON FA.AlE_Cod = FE.SPE_CodHotel
)

SELECT
    DISTINCT CASO,SPE_CodHotel,AlE_Cod,AlE_Nombre,ALU_JPCode,SPE_CodCliente, Id_SuP
FROM
    ELEMENTOS_FICHAS 
WHERE
    1 = 1
    --AND Id_SuP = 1
    --AND AlE_Nombre LIKE '%falesia%'
    --AND (AlE_Cod IS NULL)
    --AND (Id_SuP IS NULL)
    AND (AlE_Cod IS NOT NULL AND ALU_JPCode IS NULL and Id_SuP IS NOT NULL)
ORDER BY 
    CASO, SPE_CodHotel
