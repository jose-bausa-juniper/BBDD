USE BD_Nincoming

DECLARE @IDSEX INT; SET @IDSEX = 58;
DECLARE @SMPPROV varchar(10); SET @SMPPROV = 'AVT';
DECLARE @SMPHOT INT; SET @SMPHOT = 337816;
DECLARE @SMPREG INT; SET @SMPREG = 3;


SELECT 
SE.SEx_Nombre																				AS	[Sistema Externo],
SASE.Id_SAS,
SASE.SAS_Codigo,
SASE.SAS_Nombre,
Snsas.Id_SAS,
Snsas.Id_Ser,
Ser.Id_Ser,
INSer.Id_Ser,
INSer.Id_Idi,
INser.ISe_Nombre

FROM 
						Tbl_SistemaExterno							SE
		INNER JOIN		Tbl_ServicioAlojamientoSistemaExterno		SASE	ON SASE.Id_SEx = SE.Id_SEx
		INNER JOIN		Tbl_SerNSas									Snsas	ON Snsas.Id_SAS = SASE.Id_SAS
		INNER JOIN		Tbl_Servicio								Ser		ON Ser.Id_Ser = Snsas.Id_Ser
		INNER JOIN		Tbl_IDiNser									INSer	ON INSer.Id_Ser = Ser.Id_Ser


WHERE 
	1 = 1
	AND SE.Id_SEx = @IDSEX
	AND INSer.Id_Idi IN ('ES','EN')
