USE BD_Nincoming

SELECT uea.id_alo, ue.Id_UsE

FROM Tbl_UsuarioExtranet ue
INNER JOIN Tbl_UsENAlo uea ON ue.Id_UsE=uea.Id_UsE

WHERE 1 = 1
AND id_int = 111 
AND UsE_Activo = 1 
AND (Use_Permisos LIKE '%<set id="verDatosTarjetaWS">True</set>%' AND Use_Permisos LIKE '%<set id="verReservasIntranet">True</set>%') 

ORDER BY 1 DESC

