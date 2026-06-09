update Tbl_ClienteConfiguracion 
set CCL_LOGINMFA= 0 
where id_cli in (Select ID_Cli from Tbl_Cliente where Cli_TipoPago = 'B')

insert into tbl_clientehistorial(Id_Cli,His_Fecha,His_Texto) 
select Id_Cli, GETDATE(), '<text><es>Desactivado MFA, incidencia 884099</es><en>Disabled MFA, incident 884099</en></text>' from Tbl_Cliente 
where Cli_TipoPago = 'B'

-- TBL_CLIENTE Cli_TipoPago (B Prepago;C Credito;T TPV)--

Select ID_Cli from Tbl_Cliente where Cli_TipoPago = 'B' --26213 rows--