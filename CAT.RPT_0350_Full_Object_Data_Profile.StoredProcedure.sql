USE [DWMgmt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[RPT_0350_Full_Object_Data_Profile]') AND type in (N'P', N'PC'))
DROP PROCEDURE [CAT].[RPT_0350_Full_Object_Data_Profile]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAT].[RPT_0350_Full_Object_Data_Profile]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [CAT].[RPT_0350_Full_Object_Data_Profile]
@NamePart NVARCHAR(4000) = N''ALL''
, @ExactName BIT = 0

AS

SELECT DISTINCT DENSE_Rank() OVER (ORDER BY V200.Fully_Qualified_Name, V200.REG_Column_Rank) as Tbl_ID
, V200.Fully_Qualified_Name
, V200.Schema_Bound_Name
, V200.REG_Column_Name
, V200.REG_Column_Rank
, V200.Column_Type_Desc as Column_Type
, odp.TRK_Column_nulls as Column_Nulls
, odp.TRK_distinct_values as Distinct_Values
, odp.TRK_density as Column_Density
, odp.TRK_uniqueness as Column_Uniqueness
, sub.REG_Constraint_Name as Constraint_Name
, sub.Constraint_Definition
FROM CAT.VI_0200_Column_Tier_Latches AS V200 WITH(NOLOCK)
LEFT JOIN (
	SELECT ccl.LNK_T3P_ID, ccl.LNK_FK_0400_PRM_ID, ccl.REG_Constraint_Name
	, ocl.REG_Code_Content as Constraint_Definition
	FROM CAT.VI_0344_Constraint_Column_Latches AS ccl WITH(NOLOCK)
	JOIN CAT.LNK_0300_0300_Object_Dependencies AS lod WITH(NOLOCK)
	ON lod.LNK_FK_T3R_ID = ccl.LNK_T3P_ID
	AND lod.LNK_FK_0300_PRM_ID = ccl.LNK_FK_0300_CON_ID
	AND getdate() BETWEEN lod.LNK_Post_Date AND lod.LNK_Term_Date
	JOIN CAT.LNK_0300_0600_Object_Code_Sections AS ocs WITH(NOLOCK)
	ON ocs.LNK_FK_T3_ID = lod.LNK_FK_T3P_ID
	AND ocs.LNK_FK_0300_ID = ccl.LNK_FK_0300_CON_ID
	AND getdate() BETWEEN ocs.LNK_Post_Date AND ocs.LNK_Term_Date
	JOIN CAT.REG_0600_Object_Code_Library AS ocl WITH(NOLOCK)
	ON ocl.REG_0600_ID = ocs.LNK_FK_0600_ID	
	) AS Sub
ON V200.LNK_T3_ID = sub.LNK_T3P_ID
AND V200.REG_0400_ID = sub.LNK_FK_0400_PRM_ID
JOIN CAT.VI_0354_Object_Data_Profile AS odp WITH(NOLOCK)
ON odp.LNK_T2_ID = V200.LNK_T2_ID
AND odp.LNK_T3_ID = V200.LNK_T3_ID
AND odp.LNK_T4_ID = V200.LNK_T4_ID
WHERE (@ExactName = 0 AND (@NamePart = ''ALL''
	OR CHARINDEX(v200.Fully_Qualified_Name, ''''+@NamePart+'''') > 0 
	OR CHARINDEX(''''+@NamePart+'''', v200.Fully_Qualified_Name) > 0)
OR (@ExactName = 1 AND @NamePart = v200.Fully_Qualified_Name))
' 
END
GO
