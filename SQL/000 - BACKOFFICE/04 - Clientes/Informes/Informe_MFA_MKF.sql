-- Listado completo de agentes 
select mer.Mer_Nombre MERCADO,	gra.Id_GRA IDGRUPOAGE, gra.GRA_Nombre NOMBREGRUPO, c.id_cli ID_AGENCIA, c.Cli_Nombre NOMBRE_AGENCIA, c.cli_activa ACTIVO_AGENCIA, 
   	case c.Cli_TipoPago
		when 'C' then 'Crédito'
    	when 'B' then 'Prepago'
		when 'T' then 'TPV'
		else '--'
	end 'TIPO_PAGO',
	ccl.CCl_LoginMFA ACTIVO_MFA_AGNECIA, ccl.CCl_PorcentajeComisionExterna,ccl.CCl_comisionExternaVisible,ccl.CCl_comisionExternaEditable,
	i.id_int ID_INTEGRADOR, i.Int_Nombre NOMBRE_INTEGRADOR,
	id_cag ID_AGENTE, cag.cag_nombre NOMBRE_AGENTE, cag.cag_login LOGIN_AGENTE, cag.CAg_Activo ACTIVO_AGENTE, 
	cag.Cag_FechaUltimaActualizacionPassword FECHA_ULTIMO_CAMBIO_PASSWORD,  cag.cag_passpermanente PASSWORD_PERMANENTE,

   	case cag_accesoAPI 
		when 1 then 'Acceso API'
    	when 0 then 'Acceso web'
		else 'ambos'
	end 'TIPO_acceso',
	cag.CAg_AdministrarAgentes Es_Administrador,
	cag.CAg_Email EmialAgente
from				tbl_cliente					c
		inner join	Tbl_ClienteConfiguracion	ccl On c.id_cli = ccl.id_cli
		inner join	tbl_clienteagente			cag on c.id_cli   = cag.id_cli
		inner join	Tbl_GrupoAgencia			gra on c.Id_GRA   = gra.id_gra
		inner join	Tbl_Mercado					mer on gra.id_mer = mer.Id_Mer 
		left  join	tbl_integradorws			i   on c.id_int   = i.id_int
	where 1=1
		and c.Cli_Activa = 1
		AND cag.CAg_Activo = 1
		AND mer.Mer_Nombre = 'PRO'