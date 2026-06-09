select	distinct Alo.Id_Alo as HBE,
		AloN.IAl_Nombre as Hotel,
		C.Id_CCo as Id_Contrato,
		C.CCo_Nombre as Nombre_Contrato,
		C.CCo_Activo as Contrato_Activo,
		C.CCo_Extranet as Extranet,
		pro.Pro_Nombre as Proveedor_Contrato,
 
		case 
			when vcc.VCC_Payment = 1 THEN 'Si'
			when vcc.VCC_Payment = 0 THEN 'No'
			when vcc.VCC_Payment = 2 THEN 'Según configuración'
			Else 'Según configuración'
		end Pago_VCC,
		vcc.VCC_CardPool as Card_Pool,
		vcc.VCC_ValidFrom as Fecha_pago,
		vcc.VCC_IncreaseDays as Días,
		vcc.VCC_Email as VCC_Email,
		vcc.VCC_EditionLocked as Pago_Inmediato,
 
		Temporada.tmp_nombre as Temporada,
		C.CCo_InicioTemporada as Fecha_Inicio_Temporada,
		C.CCo_FinTemporada as Fecha_Fin,
		Tipo.TTa_Nombre as Tipo
from	Tbl_ContratoCompraAloja C
		left join	Tbl_ContratoCompraAlojaExtendido	ext			on ext.Id_CCo = C.Id_CCo
		left join	Tbl_Proveedor						pro			on pro.Id_Pro = ext.Id_Pro
		inner join	Tbl_Temporada						Temporada	on C.Id_tmp = Temporada.id_tmp
		inner join	Tbl_TipoTarifa						Tipo		on C.Id_TTa = Tipo.Id_TTa
		inner join	Tbl_Alojamiento						Alo			on C.Id_Alo = Alo.Id_Alo
		left join	Tbl_ContratoCompraAloInfoVCC		vcc			on vcc.Id_CCo = C.Id_CCo
		left join	Tbl_IDiNAlo							AloN		on Alo.Id_Alo = AloN.Id_Alo
where	1=1
and AloN.Id_Idi = 'es'
and C.CCo_FinTemporada >= GETDATE()
and C.CCo_Activo = 1
--and C.Id_CCo = '203639'
--and Alo.Id_Alo in (10856)
--and vcc.VCC_Payment = '1'
order by alo.Id_Alo, C.CCo_Nombre


