USE [BD_Nincoming]
GO

INSERT INTO [dbo].[tbl_MultiMarkup]
           ([id_cve],[id_del],[id_tta],[Feccre],[Fecmod],[UsrCre],[UsrMod],[mmu_aloexcluido])
           (
			SELECT 
				CVE.id_cve			AS [id_cve],
				CVE.CVe_Nombre,
				MM.id_del			AS [id_del],
				12					AS [id_tta],		--MM.id_tta,
				GETDATE()			AS [Feccre],
				GETDATE()			AS [Fecmod],
				2609				AS [UsrCre],
				2609				AS [UsrMod],
				MM.mmu_aloexcluido	AS [mmu_aloexcluido]
			FROM 
							tbl_MultiMarkup			MM
				INNER JOIN	Tbl_ContratoVentaAloja	CVE	ON CVE.Id_CVe = MM.id_cve
			WHERE
				1 = 1
				AND CVE.CVe_Activo = 1
				AND CVE.CVe_multiAlojamiento = 1
				AND CVE.CVe_FinTemporada > GETDATE()
				AND MM.id_tta = 12
			GROUP BY 
				CVE.id_cve,
				CVE.CVe_Nombre,
				CVE.CVe_Activo,
				MM.id_del,
				MM.id_tta,
				MM.mmu_aloexcluido
			)
GO