/*
SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME LIKE 'Emp_NombreComercial'
SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME IN ('id_EmpresaCompra','id_EmpresaVenta','id_FinancieraCompra','id_FinancieraEmpresaVenta') ORDER BY TABLE_NAME

SELECT * from tbl_Permiso where Per_Nombre like 'chkModificarContratadora'
SELECT * from tbl_RolUsuarioPermiso where Id_Per = 170 and Per_ValorActual = 'true'
SELECT * from tbl_RolUsuario where Id_Rol in (57)

    Emp_Tipo
    Public Enum tipoOrganizacion
        Financiera = 0
        Facturadora = 1
        Contratadora = 2
        Venta = 3
        Compra = 4
        todas = 5
    End Enum
*/
WITH LineaReservaAccounting AS (
    SELECT  R.Res_Localizador,
            R.id_res,
            LR.Id_LRe,
            LR.LRe_Tipo,
            LR.LRe_TipoDesglosado,
            lra.Id_lra,
            lra.Id_EmpresaCompra,
            e.Emp_NombreComercial,
            31 AS [NUEVA CONTRATADORA]
    FROM   Tbl_Reserva AS r
            LEFT OUTER JOIN
            Tbl_LineaReserva AS lr
            ON lr.Id_Res = r.Id_Res
            LEFT OUTER JOIN
            Tbl_lineaReservaAccounting AS lra
            ON lra.Id_lre = lr.Id_LRe
            LEFT OUTER JOIN
            Tbl_Empresas AS e
            ON e.Id_Emp = lra.Id_EmpresaCompra
    WHERE  1 = 1
            AND NOT (lr.LRe_Tipo = 'PS2'
                    AND lr.LRe_TipoDesglosado = 'PHMZ')
            AND r.Res_Localizador IN ('5CST55', 'CGVNJQ', 'YL82B3', '53DF5R', 'CLH31F', 'V54515', 'LRF41J', '8P7R11', '8ZTCZZ', 'DG33ZC', 'T45ZZP', 'VDMX1C', '2FVR1P', 'VDT8WH', 'KS32DW', 'TB24G3', '17Y4F3', '6Q2W1M', 'B2ZJN1', 'Q92HB3', 'R5QXDD', '94GL7F', 'RW9NN5', '1DBGWX', '5BG2C1', 'QLF844', 'GBNPZY', 'N5F5S6', 'QS5B7K', 'TBG1NM', '4C312J', 'KPN2JQ', 'R4LBB1', 'WHRWP6', '5212BJ', '5FDN5H', 'FD2134', 'HV2G4V', 'MCS34V', '3JD6WK', 'RDQF45', 'S8ZD17', 'RDQF45', 'S8ZD17', 'BK24JX', 'X45XS2', 'TLRF7N', '4T14RJ', 'JH3JS2', '61NT84', '371M4Q', '96Z11J', 'C85472', 'HSDYG9', '7SRLGT', 'HKSNY1', 'GZ1236', '9PZBXP', 'B5PHJZ', 'Z1C5YQ', 'L4FDYR', '9547LR', '5FVZXS', '312LJ3', 'YCZKX4', 'J4NS7Z', 'PQSL15', 'M1S444', 'PQSL15', 'J8261V', 'XM7N2K', '9CRVK1', 'PN9R2T', 'W1WMSY', '4QWNZG', 'RVGLXG', '4QWNZG', 'QSB6M7', '239T1V', '33LD5Q', '68RR61', '13W3L2', 'J31RW1', 'J31RW1', 'G4M85K', 'Q2HZD9', '51L446', '1F8KC9', 'GDKYHQ', '2V9XKP', 'YZ9XX2', '36FPWT', '282SQY', 'MPPX3Y', '3PGFDC', 'SJ4BSL', '3PGFDC', 'B1VX2G', 'N1B7V7', 'SL4B91', '94R6KY', 'X18Q3Y', 'QNK57M', '337RQT', '74281N', '4TM2RC', '15MK55', 'WYPPDY', 'RM3XK9', 'SD3MTK', 'WNG15C', 'H58WMH', 'LKP51X', '5DRT3R', 'VN1WPS', 'C1G5M1', '24ZJ63', '38VZ7G', '38VZ7G', 'WRZRR9', '3BV2DW', '93NN4W', 'TTC3B7', '3T9NH4', '46DRGP', '5827P7', 'B1KGX1', 'C34G5B', '8K39DL', '12RWP4', '649DWX', 'H179K3', 'R184HW', 'BW1JP5', 'MDKMHR', '6XMFY5', '8MCR1J', '22M3QB', '37LL2X', 'YP8V7F', '9JR836', '39G2F5', '1351BW', 'DVXBY4', 'N8PM3G', 'KJH5RK', '1P5LXJ', '2F7QMG', '25RDNL', 'RSCPS6', 'L5XV55', 'YS1N5S', '41HR58', 'CYS5FB', 'TKKD81', '6Z84KQ', 'H5W2M9', '27D9MR', 'P1TCFX', '7MNN86', '61Y1SN', 'F2SFKH', 'C5MFBK', 'LD1TD9', 'ZP2CTH', 'T92S1F', 'YFGZNV', '8H7T8Y', '9RN5DX', 'B59LCN', 'FJLNMP', 'R19M3V', 'S4Y8WV', 'TRY5BM', 'TVQ166', 'TVQ166', 'CJ7Q85', 'P97VG5', 'XQV3VY', '2DS5R2', '73N467', 'C6W14L', 'DMRBW9', 'Q2F49H', 'SR38W7', '9X6MMG', '3B3415', 'CJQMD3', 'N11SX2', 'Z52B5L', 'XTT2R8', 'P9B3WD', '15F4HF', '72C3SX', 'PS4M1V', 'DP8K3B', 'DP8K3B', '2PY1BJ', '41YCQ7', '73M25V', 'DL4N3D', 'GCCL22', 'L3HT5V', 'L9B3V7', 'XWXJNG', '1Q1YF3', 'PV981L', '5YV27J', 'BWQYH5', 'X4D32N', 'X4D32N', '5KDRSQ', 'BFH82L', 'MP6R22', 'BJ4493', 'JFX3WP', '3WFMMB', 'BV5C2Z', 'W3CYLM', 'JMXWXC', 'LJWC34', 'SM1GGJ', '1VGC2Z', 'Z8RRF2', 'KJ2VZL', 'H5545M', '4QKM83', 'FR44HK', 'MXTK6V', '4YTM7G', '65YHVL', '26712Q', 'CV1D4L', 'F57FQ2', '8BDNV3', 'X5TV3X', '71H3G6', '333MXZ', 'LLPL65', 'LLPL65', '6DLBC1', '6DLBC1', '6M88B4', 'G1Y2W5', 'G1Y2W5', '7V219Y', '8PMG2K', '531PD9', '2JYB92', '2JYB92', 'XN1V33', 'M4D1YM', 'M11L34', 'LQSX22', '2T1JKW', '8W1CX6', 'R5LWFJ', 'WBJS1K', 'FD324M', 'FYT263', 'FYT263', 'KJ3233', '54HLJV', 'ML9L2H', '3S68LF', 'F9Z2J1', 'P87564', 'QGZ198', '215CMM', '215CMM', 'D45J1Q', '9HQ3M8', '9HQ3M8', '5V4C61', '7FXZG1', 'XQSVS4')
)

UPDATE Tbl_lineaReservaAccounting
SET    Id_EmpresaCompra = 31
WHERE  Id_lra IN (SELECT id_lra FROM LineaReservaAccounting)

INSERT INTO Tbl_Historial (Id_Res, Id_LRe, His_Usuario, His_Fecha, His_Texto)
SELECT Id_Res, id_lre, 'Jun:José Bausá García', GETDATE(), '<text><es>Actualizamos contratadora solicitado en incidencia 1126182</es></text>' FROM LineaReservaAccounting

;