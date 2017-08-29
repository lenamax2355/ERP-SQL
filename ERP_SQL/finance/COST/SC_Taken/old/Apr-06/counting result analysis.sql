

1. Find out the PHYSICAL_INVENTORY_ID

select PHYSICAL_INVENTORY_NAME,PHYSICAL_INVENTORY_ID,ORGANIZATION_ID,DESCRIPTION,FREEZE_DATE,TOTAL_ADJUSTMENT_VALUE,NEXT_TAG_NUMBER  from apps.MTL_PHYSICAL_INVENTORIES 
where trunc(FREEZE_DATE)>= to_date('2006-04-23','YYYY-MM-DD')
  and trunc(FREEZE_DATE)<= to_date('2006-04-30','YYYY-MM-DD')
order by PHYSICAL_INVENTORY_ID


---------------------------------------------------------------------------

2. 
PRD Counting Result Analysis(with locator)

select (select f.tag_number from apps.mtl_physical_inventory_tags f where a.adjustment_id=f.adjustment_id and rownum=1) tag,
system_quantity,count_quantity,adjustment_quantity as Diff_Qty,
actual_cost Cost,round(nvl(adjustment_quantity*actual_cost,0),2) Diff_Amount,
 b.segment1 item,b.DESCRIPTION, a.revision Rev, a.subinventory_name Stock, 
c.segment2||'.'||c.segment3||'.'||c.segment4||'.'||c.segment5 Locator,
e.cost_group,
(select g.license_plate_number from apps.wms_license_plate_numbers g where a.parent_lpn_id=g.lpn_id and rownum=1) LPN
--c.segment2 Locat1,c.segment3 Locat2,(c.segment4) Locat3,c.segment5 Locat4
from   apps.mtl_physical_adjustments a, apps.mtl_system_items b, apps.mtl_item_locations c, apps.cst_cost_groups e 
where  a.physical_inventory_id =:d --and actual_cost > 50 
       and a.inventory_item_id=b.inventory_item_id and a.organization_id=133 and b.organization_id=133
       and a.locator_id=c.inventory_location_id and c.organization_id=133
       and a.cost_group_id=e.cost_group_id --AND adjustment_quantity<>0
	   order by tag

	   
	   select * from apps.mtl_system_items



---------------------------------------------------------------------------

3. 
PRJ Counting Result Analysis (without locator)

select (select f.tag_number from apps.mtl_physical_inventory_tags f where a.adjustment_id=f.adjustment_id and rownum=1) Tag,
 b.segment1 Item,b.DESCRIPTION, a.revision Rev, a.subinventory_name Stock, 
c.segment2||'.'||c.segment3||'.'||c.segment4||'.'||c.segment5 Locator,
system_quantity,count_quantity,adjustment_quantity as Diff_Qty,
actual_cost Cost,round(nvl(adjustment_quantity*actual_cost,0),2) Diff_Amount
--,c.segment2 Locat1,c.segment3 Locat2,(c.segment4) Locat3,c.segment5 Locat4
from apps.mtl_physical_adjustments a, apps.mtl_system_items b, apps.mtl_item_locations c 
where  a.physical_inventory_id =801
       and a.inventory_item_id=b.inventory_item_id and a.organization_id=132 and b.organization_id=132
       and a.locator_id=c.inventory_location_id and c.organization_id=132 
	   and a.subinventory_name='SBT'
union
select (select f.tag_number from apps.mtl_physical_inventory_tags f where a.adjustment_id=f.adjustment_id and rownum=1) Tag,
 b.segment1 Item,b.DESCRIPTION, a.revision Rev, a.subinventory_name Stock, 
'' Locator,
system_quantity,count_quantity,adjustment_quantity as Diff_Qty,
actual_cost Cost,round(nvl(adjustment_quantity*actual_cost,0),2) Diff_Amount
from apps.mtl_physical_adjustments a, apps.mtl_system_items b--, apps.mtl_item_locations c 
where  a.physical_inventory_id =801
       and a.inventory_item_id=b.inventory_item_id and a.organization_id=132 and b.organization_id=132
	   and a.subinventory_name<>'SBT'
