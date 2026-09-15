DECLARE @fechacierre DATETIME = '2025-01-01 00:00:00';

SELECT
	ic.ICO_PoolRequestID												AS [PR],
	ic.ico_project														AS [PROJECT],
	ic.ICO_branch														AS [BRANCH],
	ic.ICO_Repository													AS [GIT],
	ic.FecMod															AS [FECHA_COMMIT],
	CASE ic.ICO_EstadoCompilacion
		WHEN ('4') THEN 'Desplegado'
		WHEN ('3') THEN  'Descartado'
		WHEN ('2') THEN  'Compilado'
		WHEN ('1') THEN  'Pend. compilación'
		WHEN ('0') THEN  'Creado' 
	END																	AS [ESTADO_PR]
FROM	
	agencias.dbo.Tbl_IncidenciaCommit	ic
WHERE	
	1 = 1
	AND ic.ICO_EstadoCompilacion IN (2,4)
	AND ic.FecMod
ORDER BY
	ic.FecMod DESC

SELECT * FROM agencias.dbo.Tbl_IncidenciaCommit WHERE ICO_EstadoCompilacion IN (2,4) order by 1 DESC
