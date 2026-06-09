--1) Comprobamos el que las reservas no están en estado CON
select Res_Estado,Res_Localizador,Id_Res,Res_PrecioCoste,Res_PrecioTotal,Res_Fecha,* from tbl_reserva where
 res_localizador in (
                    'P35FFY',
                    'LXK34K',
                    'RLJHJ9',
                    'N7255L'
)

--2) Actualizamos por id_res el estado a CON y actualizamos fecha de Ultima Modificacion

UPDATE Tbl_Reserva 
SET Res_Estado = 'Pag', 
Res_FechaUltimaModificacion = GETDATE() 
WHERE res_localizador in (
                        'P35FFY',
                        'LXK34K',
                        'RLJHJ9',
                        'N7255L'
                        )


INSERT INTO Tbl_Historial (id_res, His_Usuario, his_fecha,his_texto) 
SELECT Id_Res, 'Jun:José Bausá', GETDATE(), '<text><es>Datos de modificados: Cambiado el estado de reserva de Quo a OK y actualizada fecha última modificación. Solicitado en ticket 898750.</es></text>' 
FROM tbl_reserva 
WHERE res_localizador IN (
                        'P35FFY',
                        'LXK34K',
                        'RLJHJ9',
                        'N7255L'
                        )

    
--3) insertamos en historial el registro del cambio
INSERT INTO Tbl_Historial (id_res, His_Usuario, his_fecha,his_texto) VALUES (17580953,'Jun:José Bausá', GETDATE(), '<text><es>Datos de modificados: Cambiado el estado de reserva de Quo a OK y actualizada fecha última modificación. Solicitado en ticket 898750.</es></text>')
