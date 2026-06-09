------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------   CONSULTA GENERAL   ------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------
USE BD_Nincoming
SELECT
    c.id_cli 'A - ID',
    --cc.CCl_comisionExternaVisible 'A - Usa markup ficticio en la web (Visible)',
    --cc.CCl_PorcentajeComisionExterna 'A - Usa markup ficticio en la web (Porcentaje)',
    --cc.CCl_comisionExternaEditable 'A - Usa markup ficticio en la web (Editable)',
	c.Cli_Nombre 'A - Nombre',	
    c.Cli_Activa 'A - Activa',

    c.id_gra 'GrA - ID',
    g.GRA_Nombre 'GrA - Nombre',
		
    c.id_pai 'A - ID Pais por defecto',
    p.pai_Nombre 'A - Nombre Pais por defecto',

    /* Las Sucursales siempre tienen una Centrar asociada */
    CASE WHEN c.Cli_IdCentral IS NULL THEN 'False' ELSE 'True' END AS 'A - Sucursal?',	
    ISNULL(c.Cli_IdCentral,0) 'A - ID Agencia Central',

    /*Mapeos de tipos de pago*/
    CASE C.Cli_TipoPago WHEN 'B' THEN 'Prepago' WHEN 'C' THEN 'Crédito' WHEN 'T' THEN 'TPV' END 'A - Tipo de pago', 

    /*Si no tiene monedas a nivel de Agencia, se toman las del Grupo de Agencias*/
    ISNULL(Cc.CCl_MonedasOperacionCliente,STUFF((SELECT ',' + gc.Mon_Siglas FROM Tbl_GraNCur gc WHERE gc.Id_Gra=c.Id_GRA FOR XML PATH('')), 1, 1, '')) 'A - Moneda Operación Cliente',
    c.Cli_ReferenciaOblig AS 'A - Referencia reserva obligatoria',
    c.cli_LocExtCliente AS 'A - Localizador externo producto cliente',

    c.Cli_Ggestion 'A - Es Grupo Gestión',

    cc.CCL_CreacionReservas 'A - Permite la creación de reservas nuevas',

    c.Cli_AccesoWeb 'A - Acceso a las reservas a través de la web externa',

    CASE WHEN c.Cli_FecActBloqueo IS NULL THEN 'False' ELSE 'True' END 'A - Bloquear reservas',

    CASE c.Cli_FecActBloqueo WHEN 0 THEN 'Fecha inicio viaje' WHEN 1 THEN 'Fecha fin viaje' ELSE 'False' END AS 'A - Bloquear reservas (Fecha)',

    cc.CCL_DiasFechaActBloqueo 'A - Bloquear reservas (Dias)',

    /*Días margen en función de la configuración mas restrictiva*/
    CASE 
        --> 1ª. Campo "Días Margen por canal" específico a nivel de Agencia
            WHEN (SELECT COUNT(R.Ccr_DiasRelease) FROM Tbl_ClienteCanalRelease R WHERE R.id_cli = c.Id_Cli AND r.id_can = 'WPRO') > 0 
                THEN (SELECT R.Ccr_DiasRelease FROM Tbl_ClienteCanalRelease R WHERE R.id_cli = c.Id_Cli AND r.id_can = 'WPRO') 
        --> 2ª. Campo "Días Margen por canal" genérico a nivel de Agencia
            WHEN (SELECT COUNT(R.Ccr_DiasRelease) FROM Tbl_ClienteCanalRelease R WHERE R.id_cli = c.Id_Cli AND r.id_can IS NULL) > 0 
                THEN (SELECT R.Ccr_DiasRelease FROM Tbl_ClienteCanalRelease R WHERE R.id_cli = c.Id_Cli AND r.id_can IS NULL) 
        --> 3ª. Campo "Días Margen" genérico a nivel de Agencia
            WHEN c.Cli_diasMargen IS NOT NULL 
                THEN c.Cli_diasMargen 
        --> 4ª. Días Margen para canal WPRO = 0
            WHEN (SELECT COUNT(p.par_valor) FROM Tbl_Parametro p WHERE p.par_codigo = 'Reserva/DiasMargen' and p.Id_Can = 'WPRO') > 0
                THEN (SELECT p.par_valor FROM Tbl_Parametro p WHERE p.par_codigo = 'Reserva/DiasMargen' and p.Id_Can = 'WPRO') 
        --> 5ª. Días Margen genérico = 0
            WHEN (SELECT COUNT(p.par_valor) FROM Tbl_Parametro p WHERE p.par_codigo = 'Reserva/DiasMargen' AND p.Id_Can IS NULL) > 0
                THEN (SELECT p.par_valor FROM Tbl_Parametro p WHERE p.par_codigo = 'Reserva/DiasMargen' AND p.Id_Can IS NULL) 
    END 'A - Días Margen',

    cc.CCl_comisionExternaVisible 'A - Usa markup ficticio en la web (Visible)',
    cc.CCl_PorcentajeComisionExterna 'A - Usa markup ficticio en la web (Porcentaje)',
    cc.CCl_comisionExternaEditable 'A - Usa markup ficticio en la web (Editable)',
    cc.CCl_PermitirIncrementarPrecio 'A - Permite incrementar precio',
    ISNULL(cc.CCl_PorcentajeImporteMaximoPermitido,0)  'A - Porcentaje de importe máximo permitido de incremento',
    cc.CCl_PermitirDecrementarPrecio 'A - Permite decrementar precio',

    cc.CCl_DenegarPagoTPVReservaConGastos 'A - Bloquear reservas que entren en gastos realizadas con pasarela de pago',

    c.Cli_VerComision 'A - Ver Comisión',

    g.gra_ValidadorRefAgencia 'GrA - Validador de ref. agencia reservas',

    /*Consultamos si el Grupo de Agencia asociado tiene configurada la generación automática de la referencia*/
    CASE WHEN (SELECT COUNT(P.Id_GrA) FROM tbl_parametro P WHERE P.Par_Codigo like '%Reserva/referenciaAutoAge%' AND P.Id_GrA=c.Id_GrA) > 0 THEN 1 ELSE 0 END AS 'GrA - Generar referencia automática por Grupo de Agencia'
    
/*Tablas implicadas*/
FROM tbl_cliente c
    INNER JOIN Tbl_GrupoAgencia			g ON c.Id_GRA=g.Id_GRA
	INNER JOIN Tbl_Mercado				m ON m.Id_Mer = g.Id_Mer
    INNER JOIN Tbl_Paises				p ON p.id_pai = c.id_pai
    INNER JOIN tbl_ClienteConfiguracion cc ON c.id_cli=cc.id_cli
	INNER JOIN Tbl_ClienteAgente		ca ON ca.id_Cli=c.Id_Cli

/*Ejemplos de Agencias con configuraciones específicas*/
WHERE 1 = 1
	--AND cc.CCl_comisionExternaVisible = 1
	--AND cc.CCl_comisionExternaEditable = 1
	AND  cc.CCl_PorcentajeComisionExterna <> 0
	AND m.Mer_Nombre = 'PRO'
	AND c.Cli_Activa = 1
    --AND c.Id_GRA = 688
	--AND C.id_Cli = 72361
    --(4812, -- Es Grupo Gestion
    --13327, -- Es Sucursal
    --56214, -- EROSKI VIAJES 105
    --11367, -- TEST PROVEEDORES DMC
    --86, -- Bloqueo reservas
    --12337,-- Markup ficticio
    --17818, -- GrA - Validador ref. agencia
    --18270 -- GrA - Generar referencia agencia automática
    --)
    
------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------



