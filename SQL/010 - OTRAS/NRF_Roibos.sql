USE BD_SuppliersPush

SELECT * FROM Tbl_AlojaSupplierPushConfig WHERE ID_SUP = 20
SELECT * FROM Tbl_AlojaSupplierPushElemento WHERE ID_SUP = 20 AND SPE_CodHotel = 46715 AND SPE_RatePlanCode = 'ROINR' AND SPE_CodigoHabitacion = 'QQBF'
SELECT * FROM Tbl_AlojaSupplierPushPoliticaCancelacion WHERE Id_SPE IN (825457,825458,841900)
SELECT * FROM Tbl_AlojaSupplierPushPoliticaCancelacionRegla WHERE Id_SPC = 105147
SELECT * FROM Tbl_AlojaSupplierPushPoliticaCancelacionFecha WHERE Id_SPC = 105147