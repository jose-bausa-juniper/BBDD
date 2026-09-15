DECLARE @Threads INT = 10;

WITH PUSH_STATS AS(
	SELECT 
		Id_SPS,
		SPS_DataType,
		SPS_ChangesProcessed,
		SPS_ProcessTimeMilliseconds,
		SPS_WaitingMilliseconds,
		Feccre,
		(SPS_ProcessTimeMilliseconds*1./SPS_ChangesProcessed)			AS [ProcessTime],
		((SPS_ProcessTimeMilliseconds*1. / (60000 * @Threads)) * 100)	AS [QueueLoadPct] 
	FROM Tbl_AlojaSupplierPushStats 
)

SELECT * FROM PUSH_STATS
