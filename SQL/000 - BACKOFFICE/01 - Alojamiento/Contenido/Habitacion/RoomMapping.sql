USE BD_JuniperMapping

--SELECT * FROM  WHERE ID_UNR IN (7,51)

SELECT 
	HR.Id_HRO,
	HR.ProviderID,
	HR.HotelID,
	HR.Id_EXR,
	HR.HRO_Hash,
-------------------------
	ER.Id_EXR,
	ER.EXR_Name,
	ER.EXR_NameCleaned,
	ER.EXR_IsTimedOut,
	ER.EXR_Hash,
	ER.EXR_invalid,
	ER.EXR_IsRefundable,
	ER.EXR_Refundable,
	ER.EXR_Additions,
	ER.EXR_Conditions,
	ER.Id_EIR,
	ER.EXR_IsNormalized,
	ER.exr_lastDateRequested,
-------------------------
	ERM.Id_ERM,
	--ERM.Id_EXR,
	ERM.Id_AGL,
	ERM.ERM_NormalizedRoom,
	--ERM.Id_UNR,
-------------------------
	UR.Id_UNR,
	UR.UNR_Name,
	UR.UNR_Code,
-------------------------
	--AL.Id_AGL,
	AL.AGL_Value


FROM 
				BD_JuniperMapping.RoomMapping.Tbl_HotelRoom				HR
	INNER JOIN	BD_JuniperMapping.RoomMapping.Tbl_ExternalRoom			ER	ON ER.Id_EXR = HR.Id_EXR
	INNER JOIN	BD_JuniperMapping.RoomMapping.Tbl_ExternalRoomMapping	ERM	ON ERM.Id_EXR = ER.Id_EXR
	INNER JOIN	BD_JuniperMapping.RoomMapping.Tbl_UniqueRoom			UR	ON UR.Id_UNR = ERM.Id_UNR
	INNER JOIN	BD_JuniperMapping.RoomMapping.Tbl_AggrupationLevel		AL	ON AL.Id_AGL = ERM.Id_AGL

WHERE 
	1 = 1
	AND HR.ProviderID = 'J107'
	AND HR.HotelID = 8163
	AND AL.AGL_Value = 'Low'
	AND UR.Id_UNR = 29
	AND ER.EXR_Name IN ('SINGLE ROOM.','DOUBLE ROOM.','SINGLE ROOM.','TWIN ROOM','SUPERIOR ROOM','SUITE ROOM 2PAX','SUITE 3 PAX','SINGLE ROOM.','SUITE ROOM 4PAX','TRIPLE ROOM.','TRIPLE ROOM.','SUITE 3 PAX','CUADRUPLE.','SUITE ROOM 4PAX','CUADRUPLE.','SUITE ROOM 4PAX')
	--AND HR.Id_HRO IN (65988,65989,133447,65991,65992,65993,133454,133445,133446,133455,66001,66002,133453,133444,66003,66004)
	--AND HR.Id_EXR IN (65988,65989,133447,65991,65992,65993,133454,133445,133446,133455,66001,66002,133453,133444,66003,66004)
