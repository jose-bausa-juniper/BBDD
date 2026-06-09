/*	
NIVEL JP	
BD_Nincoming.dbo.vwQlik_JP_HotelChain
*/

SELECT
	TOP 100
	AU.ALU_JPCode					,
	AU.ALU_Nombre					,
	AU.Alu_CadenaJuniper			,
	CHJI.Cji_Nombre					,
	AU.Alu_MarcaJuniper				,
	MHJI.Mji_Nombre
FROM
				BD_BookingEngine.dbo.Tbl_AlojamientoUnico				AU
	LEFT JOIN	BD_BookingEngine.dbo.Tbl_CadenaHotelJuniper				CHJ		ON CHJ.Id_Cju = AU.Alu_CadenaJuniper
	LEFT JOIN	BD_BookingEngine.dbo.Tbl_CadenaHotelJuniperIdioma		CHJI	ON CHJI.id_Cju = CHJ.Id_Cju
	LEFT JOIN	BD_BookingEngine.dbo.Tbl_MarcaHotelJuniper				MHJ		ON MHJ.Id_Mju = AU.Alu_MarcaJuniper AND MHJ.Id_Cju = CHJ.Id_Cju
	LEFT JOIN	BD_BookingEngine.dbo.Tbl_MarcaHotelJuniperIdioma		MHJI	ON MHJI.Id_Mju = MHJ.Id_Mju
WHERE 
	1 = 1
	AND AU.ALU_JPCode = 'JP06511X'
ORDER BY
	CHJ.id_Cju DESC

/*
NIVEL Externo
BD_Nincoming.dbo.vwQlik_JP_ExternalChain
*/
SELECT
	TOP 100
	AE.ALU_JPCode					,
	AE.AlE_Prov						,
	AE.AlE_Cod						,
	AE.AlE_Nombre					,
	AE.Ale_CadenaJuniper			,
	CHJI.Cji_Nombre					,
	AE.Ale_MarcaJuniper				,
	MHJI.Mji_Nombre					,
	AE.Ale_CodCadenaProveedor		,
	SDCH.Cad_Nombre					,
	AE.Ale_CodMarcaProveedor		,
	SDMH.Mar_Nombre

FROM
				BD_BookingEngine.dbo.Tbl_AlojamientoExterno					AE
	LEFT JOIN	BD_BookingEngine.dbo.Tbl_CadenaHotelJuniper					CHJ		ON CHJ.Id_Cju = AE.Ale_CadenaJuniper
	LEFT JOIN	BD_BookingEngine.dbo.Tbl_CadenaHotelJuniperIdioma			CHJI	ON CHJI.id_Cju = CHJ.Id_Cju
	LEFT JOIN	BD_BookingEngine.dbo.Tbl_MarcaHotelJuniper					MHJ		ON MHJ.Id_Mju =	AE.Ale_MarcaJuniper AND MHJ.Id_Cju = CHJ.Id_Cju
	LEFT JOIN	BD_BookingEngine.dbo.Tbl_MarcaHotelJuniperIdioma			MHJI	ON MHJI.Id_Mju = MHJ.Id_Mju
	LEFT JOIN	BD_BookingEngine.dbo.Tbl_StaticDataCadenaHotel				SDCH	ON (SDCH.Cad_Prov = AE.AlE_Prov) AND (SDCH.Cad_Codigo = AE.Ale_CodCadenaProveedor)
	LEFT JOIN	BD_BookingEngine.dbo.Tbl_StaticDataMarcaHotel				SDMH	ON (SDMH.Mar_Prov = AE.AlE_Prov) AND (SDMH.Mar_Codigo = AE.Ale_CodMarcaProveedor)
WHERE
	1 = 1
	AND AE.AlE_Prov = 'EXR'
	AND AE.ALU_JPCode = 'JP06511X'
ORDER BY
	CHJ.id_Cju DESC