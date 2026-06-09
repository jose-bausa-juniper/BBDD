select
Log_Usuario AS Username,
Log_Tipo,
convert(varchar(max), convert(BIGINT,Log_DirIP/256/256/256) % 256) + '.' + convert(varchar(max),convert(BIGINT,Log_DirIP/256/256) % 256) + '.' + convert(varchar(max),convert(BIGINT,Log_DirIP/256) % 256) + '.' + convert(varchar(max),convert(BIGINT,Log_DirIP) % 256) as IP
--,Log_dirIP,*
from tbl_loglogins
where 1=1
--and Log_Tipo = 'Ext' 
and log_dirip in (SELECT LIP_DirIP from Tbl_ListaIPs where LIP_IdUsuario = 120 and LIP_TipoUsuario = 'Int')--*/1306717542,773337546)
--and Feccre > '2023-11-01 00:00:00'
and Log_Usuario = 'tivolihotel'
GROUP by Log_DirIP,Log_Usuario,Log_Tipo
order by Log_Usuario desc

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Consulta Bloqueo de IPs --
/*
select top 300 
max(ll.Feccre),
count(*),
Log_Usuario,
Int_Nombre,
Int_ChannelManagerExtranet,
Log_DirIP 
from tbl_loglogins ll
inner join Tbl_ListaIPs li on li.LIP_DirIP=ll.Log_DirIP and LIP_TipoUsuario='Int'
inner join Tbl_IntegradorWS iws on iws.Id_Int=li.LIP_IdUsuario
where Log_Tipo is null 
and ll.Feccre>getdate()-1 
and Int_ChannelManagerExtranet=1 
and Int_Nombre like '%ratetiger%'
group by Log_Usuario,Int_Nombre,Int_ChannelManagerExtranet,Log_DirIP
order by 1 desc

*/