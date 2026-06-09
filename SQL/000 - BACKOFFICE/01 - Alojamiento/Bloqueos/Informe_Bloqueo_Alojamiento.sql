--Parcialmente Bloqueados Auc -- 115.924 JPCodes (Auc)

    SELECT
        auc.Id_Auc,
        auc.AUC_JPCode JPcode,
        auc.AUC_Bloqueado Bloqueado,
        auc.AUC_Recomendado Puntuacion,
        auc.AUC_Priorizacion Priorizacion,
        auc.AUC_Id_EAU AUC_Id_EAU,
        auc.AUC_Comentario AUC_Comentario
    FROM
        BD_Nincoming.dbo.Tbl_AlojamientoUnicoCliente auc  
    WHERE
        auc.Id_Auc > 0
        AND auc.AUC_Bloqueado = 0
    ORDER BY
        auc.Id_Auc

--Bloqueados Auc -- 29 JPCodes (Auc)

    SELECT
        auc.Id_Auc,
        auc.AUC_JPCode JPcode,
        auc.AUC_Bloqueado Bloqueado,
        auc.AUC_Recomendado Puntuacion,
        auc.AUC_Priorizacion Priorizacion,
        auc.AUC_Id_EAU AUC_Id_EAU,
        auc.AUC_Comentario AUC_Comentario  
    FROM
        BD_Nincoming.dbo.Tbl_AlojamientoUnicoCliente auc  
    WHERE
        auc.Id_Auc > 0 
        And auc.AUC_Bloqueado = 1
    ORDER BY
        auc.Id_Auc

--bdComun -- 784.653 JPCodes

    SELECT
        u.Id_ALU,
        u.ALU_JPcode JPCode,
        u.ALU_Nombre Nombre,
        u.ALU_GIATA GIATA,
        u.ALU_Latitud LATITUD,
        u.ALU_Longitud LONGITUD,
        u.ALU_CodigoPostal CodigoPostal,
        u.Id_Zon,
        u.ALU_direccion Direccion,
        u.AlU_CategoriaHotelJuniper CategoriaId,
        c.caj_codigo CategoriaCodigo,
        u.Alu_IsAccurated EsBlanco,
        u.Alu_CityName NombreCiudad,
        u.Alu_FullCityName NombreCompletoCiudad,
        u.ALU_UrlGoogle UrlGoogle,
        u.ALU_UrlWebOficial UrlWebOficial,
        u.alu_NombreZona NombreZona  
    FROM
        [cmspain2].[bd_comun].[dbo].Tbl_AlojamientoUnico u  
    left join
        [cmspain2].[bd_comun].[dbo].tbl_categoriaalojamientojuniper c 
            on c.id_caj = u.alu_categoriahoteljuniper  
    WHERE
        Id_ALU > 0 
        and AlU_IsAccurated = 1  
    ORDER BY
        Id_ALU

--Filtros TAU -- 14 Tipos de Alojamiento Unico 

    SELECT
        tauc.id_TAU,
        tauc.PAU_Id_Auc Id_Auc,
        tauc.pau_id_taj,
        tai.iTA_nombre taj_nombre  
    FROM
        BD_Nincoming.dbo.Tbl_TipoAlojaUnicoCliente tauc  
    INNER JOIN
        BD_Nincoming.dbo.Tbl_TipoAlojamiento taj 
            on taj.id_taj = tauc.PAU_Id_Taj  
    LEFT join
        BD_Nincoming.dbo.tbl_idintaj tai 
            on tai.id_taj=taj.id_taj 
            and tai.id_idi='es'
    WHERE
        tauc.id_TAU > 0
    ORDER BY
        tauc.id_TAU

--Canales bloqueados

    SELECT
        anc.Id_ANC,
        anc.id_AUC,
        anc.Id_Can,
        auc.AUC_Bloqueado  
    FROM
        BD_Nincoming.dbo.Tbl_AluNCan anc 
    LEFT JOIN
        BD_Nincoming.dbo.Tbl_AlojamientoUnicoCliente  auc 
            ON anc.id_AUC=auc.id_AUC 
    WHERE
        anc.Id_ANC > 0
    ORDER BY
        anc.Id_ANC


--Proveedores bloqueados

    SELECT
        pauc.id_PAU,
        pauc.PAU_Id_AUC,
        pauc.PAU_AlE_Prov,
		pauc.PAU_Bloqueado,
        auc.AUC_Bloqueado  
    FROM
        BD_Nincoming.dbo.Tbl_ProvAlojaUnicoCliente pauc 
    LEFT JOIN
        BD_Nincoming.dbo.Tbl_AlojamientoUnicoCliente  auc 
            ON pauc.PAU_Id_AUC=auc.id_AUC 
    WHERE
        pauc.id_PAU > 0
    ORDER BY
        pauc.id_PAU


