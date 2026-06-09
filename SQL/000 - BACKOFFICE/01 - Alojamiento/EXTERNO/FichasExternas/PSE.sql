Select top 1000 AlE_NombreZona, AlE_EsNoHotel, Ale_EsNoHotelProveedor,ALU_JPCode, AlE_Cod, * 
from Tbl_AlojamientoExterno 
where 1=1
and AlE_Prov= 'RKT' 
and ALU_JPCode like 'JP001514'


Select top 1000 AlE_NombreZona, AlE_EsNoHotel, Ale_EsNoHotelProveedor,ALU_JPCode, AlE_Cod, * 
from Tbl_AlojamientoExterno 
where 1=1
and AlE_EsNoHotel = 0
and Ale_EsNoHotelProveedor = 0
and AlE_Prov= 'AGO' 
-- and ALU_JPCode like 'JP001514'