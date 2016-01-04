-- start table: panel_placement_header
-- start metadata:
-- table_name	field_name	is_identity	user_type_id	type_name	precision
-- panel_placement_header	panel_equipment_id	0	108	numeric	38
-- panel_placement_header	equipment_id	0	108	numeric	38
-- panel_placement_header	master_placement_id	0	108	numeric	38
-- panel_placement_header	panel_placement_id	1	108	numeric	38
-- panel_placement_header	timestamp	0	108	numeric	38
-- panel_placement_header	trx_product_id	0	231	nvarchar	0
-- end metadata:
-- end table: panel_placement_header

select 
    panel_equipment_id,
    equipment_id,
    master_placement_id,
    panel_placement_id,
    timestamp,
    trx_product_id
from
    panel_placement_header
where
    trx_product_id like '%1417462809-0000026227%'
    or
    trx_product_id like '%1417462830-0000026224%'
go


