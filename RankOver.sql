  /*  
UPDATE table_name t2
SET t2.rank=
  SELECT t1.rank FROM(
  SELECT company,     direction,    type,    YEAR,    MONTH,    value,
    rank() OVER (PARTITION BY direction, type, YEAR, MONTH ORDER BY value DESC) AS rank
  FROM table_name
  GROUP BY company,
    direction,    TYPE,    YEAR,    MONTH,    VALUE
	ORDER BY company,
    direction,    TYPE,    YEAR,    MONTH,    VALUE
  ) t1
WHERE t1.company = t2.company
AND t1.direction = t2.direction; */
-----------------------------RANK OVER ---------------------------------
SELECT GTIN, SKU_ID, SKU_Short_Description, Dup_count, [DUP_Rank] 
	,RANK() OVER (PARTITION BY GTIN order by SKU_ID asc) as  [DUP_Rank] 
	  FROM [Repository].[dbo].[ProductFeed_AD_Master_Items_List]     pf
					  WHERE   [NAV_ItemNo]   like 'Not%'   and NOT(GTIN is null)
							 and Dup_count > 1  -- and GTIN  =  '00000024101510'

/*
--------------------------------------------------------DOES NOT WORK------------------------
 UPDATE   [Repository].[dbo].[ProductFeed_AD_Master_Items_List] 
 SET [Repository].[dbo].[ProductFeed_AD_Master_Items_List].[DUP_Rank] 
			= SELECT pf.[DUP_Rank]  FROM ( S-----------------------------RANK OVER ---------------------------------
SELECT GTIN, SKU_ID, SKU_Short_Description, Dup_count, [DUP_Rank] 
	,RANK() OVER (PARTITION BY GTIN order by SKU_ID asc) as  [DUP_Rank] 
	  FROM [Repository].[dbo].[ProductFeed_AD_Master_Items_List]     pf
					  WHERE   [NAV_ItemNo]   like 'Not%'   and NOT(GTIN is null)
							 and Dup_count > 1   and GTIN  =  '00000024101510')
--FROM   [Repository].[dbo].[ProductFeed_AD_Master_Items_List] pf2	
	--		JOIN  [Repository].[dbo].[ProductFeed_AD_Master_Items_List]  pf
	--		ON pf.SKU_ID = pf2.SKU_ID  
 WHERE   [Repository].[dbo].[ProductFeed_AD_Master_Items_List].SKU_ID = pf.SKU_ID  and   p2.GTIN  =  '00000024101510'


 */
 -----------------------CREATE A NEW TABLE

 select * into   z_AD_RANK
from
(
SELECT GTIN, SKU_ID, SKU_Short_Description, Dup_count 
	,RANK() OVER (PARTITION BY GTIN order by SKU_ID asc) as  [DUP_Rank] 
	  FROM [Repository].[dbo].[ProductFeed_AD_Master_Items_List]     pf
					  WHERE   [NAV_ItemNo]   like 'Not%'   and NOT(GTIN is null)
							 and Dup_count > 1  
) mysourcedata
;

