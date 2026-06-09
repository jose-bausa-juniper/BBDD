USE BD_Nincoming

SELECT
	CTV.fecmod AS FechaMod,
	CAST(DECOMPRESS(Ctv_Atributos) AS XML) AS [INFO],
	*
from 
	Tbl_ConfiguracionTarjetaVirtual CTV
WHERE 
	1 = 1
	--AND Ctv_Activa = 1	
	--AND id_Ctv = 1 
	--AND Ctv_Obsoleta = 0
	--AND Ctv_Provider = 'BavelEPay'
	--AND Ctv_Provider = 'W2M'
	--AND CAST(DECOMPRESS(Ctv_Atributos) AS varchar(MAX)) LIKE '%EFPLNJ84CHZPLUM2-W2M-638884244161564927%'
ORDER BY
FechaMod DESC


--SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME LIKE '%ctv%'
