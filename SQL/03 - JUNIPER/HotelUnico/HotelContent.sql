SELECT 
CONVERT(nVARCHAR(1000), Hot_Content, 2),
CAST(DECOMPRESS(Hot_Content) AS NVARCHAR(MAX)) AS info,
Hot_Content
FROM Tbl_HotelContentComplete 
WHERE Hot_Provider IN ('HMT') AND Hot_Code = 'h5fabdcdf03152'



