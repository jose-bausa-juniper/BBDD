Select * from Tbl_CanalVentaURL where Feccre > '2023-10-01'
Select * from Tbl_CanalVenta where id_CAN = 'WPRO'

INSERT Tbl_CanalVentaURL (CVU_URL,CVU_URLS,id_CAN, Feccre, Id_Ent) VALUES 
('http://pro2next.juniperbetemp.com/','https://pro2next.juniperbetemp.com/','WPRO',GETDATE(),1),
('http://pro2next.juniper.es/','https://pro2next.juniper.es/','WPRO',GETDATE(),2),
('http://test-pro2next.juniper.es/','https://test-pro2next.juniper.es/','WPRO',GETDATE(),3),
('http://desa-pro2next.juniper.es/','https://desa-pro2next.juniper.es/','WPRO',GETDATE(),4)
