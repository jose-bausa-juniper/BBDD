USE BD_SuppliersPush

--SELECT * FROM Tbl_AlojaSupplierPushConfig WHERE Id_SuP = 16
/*
public class regla
{
	public tiposCondicion tipoCondicion;
	public short? minCondicion;
	public short? maxCondicion;
	public short? horaLimite;
	public tiposPenalizacion tipoPenalizacion;
	public double valorPenalizacion;
}

public enum tiposCondicion : byte
{
	DiasAntesLLegada = 0,
	HorasAntesLlegada = 1,
	NoShow = 2
}

public enum tiposPenalizacion : byte
{
	Porcentual = 0,
	CantidadFija = 1,
	Noches = 2
}
*/
SELECT
	--ASPE.SPE_CodHotel,
	--ASPE.SPE_RatePlanCode,
	--ASPE.SPE_CodigoHabitacion,
	--ASPPC.SPC_Codigo,
	ASPPCR.SPR_TipoCondicion,
	ASPPCR.SPR_ValorMinCondicion,
	ASPPCR.SPR_ValorMaxCondicion,
	ASPPCR.SPR_HoraLimite,
	ASPPCR.SPR_TipoPenalizacion,
	ASPPCR.SPR_ValorPenalizacion
FROM 
				Tbl_AlojaSupplierPushElemento					ASPE
	INNER JOIN	Tbl_AlojaSupplierPushPoliticaCancelacion		ASPPC	ON ASPPC.Id_SPE = ASPE.Id_SPE
	INNER JOIN	Tbl_AlojaSupplierPushPoliticaCancelacionRegla	ASPPCR	ON ASPPCR.Id_SPC = ASPPC.Id_SPC
WHERE
	1 = 1
	--AND ASPE.Id_SuP = 16
	--AND ASPPCR.SPR_TipoPenalizacion = 2
	--AND ASPPCR.SPR_ValorMaxCondicion > 1

	--AND ASPE.SPE_CodHotel = 'HYQDXBAA'
	--AND ASPE.SPE_RatePlanCode = 'O18SAVER'
	--AND ASPE.SPE_CodigoHabitacion = 'K1'
GROUP BY
--	ASPE.Id_SuP,
--	ASPE.SPE_CodHotel,
--	--ASPE.SPE_RatePlanCode,
--	--ASPE.SPE_CodigoHabitacion,
--	ASPPC.SPC_Codigo,
	ASPPCR.SPR_TipoCondicion,
	ASPPCR.SPR_ValorMinCondicion,
	ASPPCR.SPR_ValorMaxCondicion,
	ASPPCR.SPR_HoraLimite,
	ASPPCR.SPR_TipoPenalizacion,
	ASPPCR.SPR_ValorPenalizacion
ORDER BY 
	ASPPCR.SPR_TipoPenalizacion,
	ASPPCR.SPR_TipoCondicion


