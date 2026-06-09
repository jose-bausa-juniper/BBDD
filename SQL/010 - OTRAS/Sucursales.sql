use BD_Nincoming
-- Listado completo de agentes 
select 
	mer.Id_Mer									ID_MERCADO,
	mer.Mer_Nombre								MERCADO,
	gra.Id_GRA									ID_GRUPO_AGENCIA,
	gra.GRA_Nombre								GRUPO_AGENCIA,
	c.id_cli									ID_AGENCIA,
	c.Cli_Nombre								AGENCIA,
	c.cli_activa								AGENCIA_ACTIVO, 
	ccl.CCl_VerReservasMisSucursales			,
	ccl.CCl_ModificarReservasMisSucursales		,
	ccl.CCl_CancelarReservasMisSucursales		,
	id_cag										ID_AGENTE,
	cag.cag_nombre								AGENTE,
	cag.CAg_Email								EMAIL_AGENTE,
	cag.CAg_Activo								AGENTE_ACTIVO, 
    case cag_accesoAPI 
		when 1 then 'Acceso API'
    	when 0 then 'Acceso WEB'
	end											TIPO_ACCESO,
	cag.CAg_VerOtrasReservas					VER_RESERVAS_OTROS_AGENTES,
	cag.CAg_VerReservasSucursales				,
	cag.CAg_ModificarReservasSucursales			,
	cag.CAg_CancelarReservasSucursales,
	cag.Feccre
from tbl_cliente  c
	   inner join Tbl_ClienteConfiguracion ccl On c.id_cli = ccl.id_cli
	   inner join tbl_clienteagente      cag on c.id_cli   = cag.id_cli
	   inner join Tbl_GrupoAgencia       gra on c.Id_GRA   = gra.id_gra
	   inner join Tbl_Mercado            mer on gra.id_mer = mer.Id_Mer 
where 
		1=1
		and c.Cli_IdCentral IS NULL
		and c.Cli_Activa = 1
		and cag_Activo = 1
		and cag_accesoAPI = 0
		AND C.Id_Cli IN (7255,3278)
		----BOOKING  92S2H4    -- Agencia Sucursal
		----BOOKING ******  -- Agente Sucursal
		----and (cag.CAg_VerReservasSucursales = 1 AND cag.CAg_VerOtrasReservas = 1) -- Jose Bausá - Acceso WEB	--> VE LA RESERVA
		----and (cag.CAg_VerReservasSucursales = 1 AND cag.CAg_VerOtrasReservas = 0) -- Toni Reina				--> NO VE LA RESERVA
		and (cag.CAg_VerReservasSucursales = 0 AND cag.CAg_VerOtrasReservas = 1) -- martin.olmos-web			--> NO VE LA RESERVA
		----and (cag.CAg_VerReservasSucursales = 0 AND cag.CAg_VerOtrasReservas = 0) -- Miquel - AccesoWEB		--> NO VE LA RESERVA
		--and (cag.CAg_VerReservasSucursales = 1 AND cag.CAg_VerOtrasReservas = 1 AND cag.CAg_ModificarReservasSucursales = 0)
