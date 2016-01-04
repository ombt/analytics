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

-- start table: panel_placement_details
-- start metadata:
-- table_name	field_name	is_identity	user_type_id	type_name	precision
-- panel_placement_details	panel_placement_id	0	108	numeric	38
-- panel_placement_details	reel_id	0	108	numeric	38
-- panel_placement_details	nc_placement_id	0	108	numeric	38
-- panel_placement_details	pattern_no	0	108	numeric	38
-- panel_placement_details	z_num	0	108	numeric	38
-- panel_placement_details	pu_num	0	231	nvarchar	0
-- panel_placement_details	part_no	0	262	udt_part_no	0
-- panel_placement_details	custom_area1	0	264	udt_lot_no	0
-- panel_placement_details	custom_area2	0	263	udt_vendor_no	0
-- panel_placement_details	custom_area3	0	231	nvarchar	0
-- panel_placement_details	custom_area4	0	262	udt_part_no	0
-- panel_placement_details	ref_designator	0	231	nvarchar	0
-- end metadata:
-- end table: panel_placement_details

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
-- 
-- panel_equipment_id	equipment_id	master_placement_id	panel_placement_id	timestamp	trx_product_id
-- 1219762	1000	1085935	1085964	1417462814	1417462809-0000026227-+03EA547CC27A97+-01-00-4796
-- 1219765	1000	1085967	1085967	1417462839	1417462830-0000026224-+03EA547CBF1194+-02-00-4796

select 
    panel_placement_id,
    z_num,
    pu_num,
    part_no,
    reel_id,
    nc_placement_id,
    pattern_no,
    custom_area1,
    custom_area2,
    custom_area3,
    custom_area4,
    ref_designator
from
    panel_placement_details
where
    panel_placement_id in ( 1085935, 1085964, 1085967 )
order by
    panel_placement_id asc,
    z_num asc,
    pu_num asc,
    part_no asc,
    reel_id asc
go

select 
    pph.panel_equipment_id,
    pph.equipment_id,
    pph.master_placement_id,
    pph.panel_placement_id,
    pph.timestamp,
    pph.trx_product_id,
    ppd.panel_placement_id,
    ppd.z_num,
    ppd.pu_num,
    ppd.part_no,
    ppd.reel_id,
    ppd.nc_placement_id,
    ppd.pattern_no,
    -- ppd.custom_area1,
    -- ppd.custom_area2,
    -- ppd.custom_area3,
    -- ppd.custom_area4,
    ppd.ref_designator
from
    panel_placement_header pph
inner join 
    panel_placement_details ppd
on
    ppd.panel_placement_id = pph.panel_placement_id 
    
where
    pph.trx_product_id like '%1417462809-0000026227%'
or
    pph.trx_product_id like '%1417462830-0000026224%'
go
    pph.equipment_id asc,
    pph.panel_placement_id asc,
    ppd.z_num asc,
    ppd.pu_num asc,
    ppd.part_no asc,
    ppd.reel_id asc
go

