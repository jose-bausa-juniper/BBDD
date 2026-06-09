DECLARE
	@fechacierre DATETIME = '2025-01-01 00:00:00',
	@idcliente INT = 18224
SELECT  
    i.Id_incidencia																						,
    i.I_asumpte																							AS NombreIncidencia,
    ti.TI_Etiqueta_ES																					,
    CASE i.I_estat
        WHEN 'N'	THEN 'Pendiente'
        WHEN 'E'	THEN 'En curso'
        WHEN 'C'	THEN 'Cerrada'
        WHEN '5'	THEN 'Pend Proveedor'
        WHEN '4'	THEN 'Pend Juniper'
        WHEN '3'	THEN 'Pend Cliente'
					ELSE i.I_estat
    END																									AS EstadoIncidencia,
    u_responsable.U_nom																					AS Responsable,
    u_responsableTicket.U_nom																			AS ResponsableTicket,
    i.FecCre																							AS FechaCreacion,
	datediff(DAY, getdate(), i.FecCre)																	as DiasDIF_con_creacion,
    iu.IU_data																							AS FechaUltimoComentarioExterno,
	datediff(DAY, getdate(), iu.IU_data)																as DiasDIF_con_FechaUltimoComentarioExterno,
    ii.IU_data																							AS FechaUltimoComentarioInterno,
	datediff(DAY, getdate(), ii.IU_data)																as DiasDIF_con_FechaUltimoComentarioInterno,
	datediff(DAY, iu.IU_data, ii.IU_data)																as DiasDIF_UltimoExterno_UltimoInterno,

    CASE 
        WHEN u_ultimoComentarioExterno.Id_usuari = 10000	THEN iu.IU_nomUsuari
															ELSE u_ultimoComentarioExterno.U_nom
    END																									AS UsuarioUltimoComentarioExterno,
    u_ultimoComentarioInterno.U_nom																		AS UsuarioUltimoComentarioInterno,	
	dbo.converthtml(iu.IU_descripcio)																	AS UltimoComentarioExterno,
	dbo.converthtml(ii.IU_descripcio)																	AS UltimoComentarioInterno

FROM			agencias.dbo.INCIDENCIA			i
    JOIN		agencias.dbo.USUARI				u_responsable				ON i.Id_usuari = u_responsable.Id_usuari
    JOIN		agencias.dbo.USUARI				u_responsableTicket			ON i.I_responsableTicket = u_responsableTicket.Id_usuari
    JOIN		agencias.dbo.INCIDENCIAUSUARI	iu							ON i.Id_incidencia = iu.Id_incidencia
    JOIN		agencias.dbo.INCIDENCIAINTERNA	ii							ON i.Id_incidencia = ii.Id_incidencia
    LEFT JOIN	agencias.dbo.TIPO_INCIDENCIA	ti							ON ti.TI_id = i.I_tipus AND ti.TI_Activo = 1
    LEFT JOIN	agencias.dbo.USUARI				u_ultimoComentarioExterno	ON iu.Id_usuari = u_ultimoComentarioExterno.Id_usuari
    LEFT JOIN	agencias.dbo.USUARI				u_ultimoComentarioInterno	ON ii.Id_usuari = u_ultimoComentarioInterno.Id_usuari

WHERE 1=1
	and i.A_codi = @idcliente -- Filtramos por cliente W2M
    AND i.I_estat <> 'C'
	AND ti.TI_id NOT IN (16,35,32,37) -- SOPORTE XML;DESARROLLO ENTREGADO;ERROR RESUELTO;SOPORTE ENTREGADO
    AND iu.IU_data =	(
						SELECT 
							TOP 1 IU_data 
						FROM 
							agencias.dbo.INCIDENCIAUSUARI 
						WHERE 
							Id_incidencia = i.Id_incidencia
						ORDER BY 
							IU_data DESC
						)
    AND ii.IU_data =	(
						SELECT 
							TOP 1 IU_data 
						FROM 
							agencias.dbo.INCIDENCIAINTERNA 
						WHERE 
							Id_incidencia = i.Id_incidencia 
							AND Id_usuari NOT IN (10000, 9999, 9998)
							AND IU_descripcio not like '%Se ha modificado la puntuación de manera automática de %'
						ORDER BY 
							IU_data DESC
						)
	--AND ii.IU_descripcio LIKE '%NOTA PM%'
	--AND iu.IU_data > ii.IU_data
	--AND u_ultimoComentarioExterno.Id_usuari = 10000
ORDER BY 
	ti.TI_Etiqueta_ES DESC,
	u_responsableTicket.U_nom


	--SELECT * FROM USUARI WHERE U_nom LIKE '%juan diaz%' OR U_nom LIKE '%Lorena Taverna%'