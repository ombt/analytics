-- tracking_data serial_no
-- tracking_data prod_model_no
-- tracking_data panel_id
-- tracking_data pattern_id
-- tracking_data barcode
-- tracking_data setup_id
-- tracking_data top_bottom
-- tracking_data timestamp
-- tracking_data import_flag

-- panels panel_id
-- panels equipment_id
-- panels nc_version
-- panels start_time
-- panels end_time
-- panels panel_equipment_id
-- panels panel_source
-- panels panel_trace
-- panels stage_no
-- panels lane_no
-- panels job_id
-- panels setup_id
-- panels trx_product_id

-- panel_placement_header panel_equipment_id
-- panel_placement_header equipment_id
-- panel_placement_header master_placement_id
-- panel_placement_header panel_placement_id
-- panel_placement_header timestamp
-- panel_placement_header trx_product_id

-- panel_placement_details panel_placement_id
-- panel_placement_details reel_id
-- panel_placement_details nc_placement_id
-- panel_placement_details pattern_no
-- panel_placement_details z_num
-- panel_placement_details pu_num
-- panel_placement_details part_no
-- panel_placement_details custom_area1
-- panel_placement_details custom_area2
-- panel_placement_details custom_area3
-- panel_placement_details custom_area4
-- panel_placement_details ref_designator

-- 
-- select
--     td.serial_no,
--     td.prod_model_no,
--     td.panel_id,
--     td.pattern_id,
--     td.barcode,
--     td.setup_id,
--     td.top_bottom,
--     td.timestamp,
--     td.import_flag,
--     p.panel_id,
--     p.equipment_id,
--     p.nc_version,
--     p.start_time,
--     p.end_time,
--     p.panel_equipment_id,
--     p.panel_source,
--     p.panel_trace,
--     p.stage_no,
--     p.lane_no,
--     p.job_id,
--     p.setup_id,
--     p.trx_product_id
-- from
--     tracking_data td
-- inner join 
--     panels p
-- on
--     td.panel_id = p.panel_id
-- where
--     td.serial_no = 'S0244800001'
-- order by
--     td.panel_id asc
-- go
-- 
-- select
--     td.serial_no,
--     td.panel_id,
--     td.pattern_id,
--     td.barcode
-- from
--     tracking_data td
-- where
--     td.serial_no = 'S0244800001'
-- order by
--     td.panel_id asc
-- go
-- 
-- select
--     p.panel_id,
--     p.equipment_id,
--     p.nc_version,
--     p.start_time,
--     p.end_time,
--     p.panel_equipment_id,
--     p.panel_source,
--     p.panel_trace,
--     p.stage_no,
--     p.lane_no,
--     p.job_id,
--     p.setup_id,
--     p.trx_product_id
-- from
--     panels p
-- where
--     p.panel_id in ( 1211, 1212 )
-- go
-- 
-- select
--     td.serial_no,
--     td.prod_model_no,
--     td.panel_id,
--     td.pattern_id,
--     td.barcode,
--     td.setup_id,
--     td.top_bottom,
--     td.timestamp,
--     td.import_flag
-- from
--     tracking_data td
-- where
--     td.serial_no = 'S0244800001'
-- order by
--     td.panel_id asc
-- go
-- 
-- 
-- select
--     td.serial_no,
--     td.prod_model_no,
--     td.panel_id,
--     td.pattern_id,
--     td.barcode,
--     td.setup_id,
--     td.top_bottom,
--     td.timestamp,
--     td.import_flag
-- from
--     tracking_data td
-- where
--     td.serial_no = 'S0244800001'
-- order by
--     td.panel_id asc
-- go
-- 
-- select
--     td.serial_no,
--     td.prod_model_no,
--     td.panel_id,
--     td.pattern_id,
--     td.barcode,
--     td.setup_id,
--     td.top_bottom,
--     td.timestamp,
--     td.import_flag,
--     p.panel_id,
--     p.equipment_id,
--     p.nc_version,
--     p.start_time,
--     p.end_time,
--     p.panel_equipment_id,
--     p.panel_source,
--     p.panel_trace,
--     p.stage_no,
--     p.lane_no,
--     p.job_id,
--     p.setup_id,
--     p.trx_product_id
-- from
--     tracking_data td
-- inner join 
--     panels p
-- on
--     td.panel_id = p.panel_id
-- where
--     td.serial_no = 'S0244800001'
-- order by
--     td.panel_id asc
-- go
-- 
-- select
--     td.serial_no,
--     td.panel_id,
--     td.pattern_id,
--     td.barcode,
--     td.top_bottom,
--     p.panel_id,
--     p.equipment_id,
--     p.nc_version,
--     p.panel_equipment_id,
--     p.panel_source,
--     p.panel_trace,
--     p.stage_no,
--     p.lane_no,
--     p.trx_product_id
-- from
--     tracking_data td
-- inner join 
--     panels p
-- on
--     td.panel_id = p.panel_id
-- where
--     td.serial_no = 'S0244800001'
-- order by
--     td.panel_id asc
-- go
-- 
-- select distinct
--     td.serial_no,
--     td.panel_id,
--     td.pattern_id,
--     td.barcode,
--     td.top_bottom,
--     p.panel_id,
--     p.equipment_id,
--     p.nc_version,
--     p.panel_equipment_id,
--     p.panel_source,
--     p.panel_trace,
--     p.stage_no,
--     p.lane_no,
--     p.trx_product_id,
--     pph.panel_equipment_id,
--     pph.equipment_id,
--     pph.master_placement_id,
--     pph.panel_placement_id,
--     pph.timestamp,
--     pph.trx_product_id,
--     ppd.panel_placement_id,
--     ppd.reel_id,
--     ppd.nc_placement_id,
--     ppd.pattern_no,
--     ppd.z_num,
--     ppd.pu_num,
--     ppd.part_no,
--     ppd.custom_area1,
--     ppd.custom_area2,
--     ppd.custom_area3,
--     ppd.custom_area4,
--     ppd.ref_designator
-- from
--     tracking_data td
-- inner join 
--     panels p
-- on
--     td.panel_id = p.panel_id
-- inner join 
--     panel_placement_header pph
-- on
--     pph.panel_equipment_id = p.panel_equipment_id
-- inner join 
--     panel_placement_details ppd
-- on
--     ppd.panel_placement_id = pph.panel_placement_id 
-- or
--     ppd.panel_placement_id = pph.master_placement_id 
-- where
--     td.serial_no = 'S0244800001'
-- order by
--     td.panel_id asc
-- go
-- 
-- select distinct
--     td.serial_no,
--     td.panel_id,
--     td.pattern_id,
--     td.barcode,
--     td.top_bottom,
--     p.panel_id,
--     p.equipment_id,
--     p.nc_version,
--     p.panel_equipment_id,
--     p.panel_source,
--     p.panel_trace,
--     p.stage_no,
--     p.lane_no,
--     p.trx_product_id,
--     pph.panel_equipment_id,
--     pph.equipment_id,
--     pph.master_placement_id,
--     pph.panel_placement_id,
--     pph.timestamp,
--     pph.trx_product_id,
--     ppd.panel_placement_id,
--     ppd.reel_id,
--     ppd.nc_placement_id,
--     ppd.pattern_no,
--     ppd.z_num,
--     ppd.pu_num,
--     ppd.part_no,
--     ppd.custom_area1,
--     ppd.custom_area2,
--     ppd.custom_area3,
--     ppd.custom_area4,
--     ppd.ref_designator
-- from
--     tracking_data td
-- inner join 
--     panels p
-- on
--     td.panel_id = p.panel_id
-- inner join 
--     panel_placement_header pph
-- on
--     pph.panel_equipment_id = p.panel_equipment_id
-- inner join 
--     panel_placement_details ppd
-- on
--     ppd.panel_placement_id = pph.panel_placement_id 
-- or
--     ppd.panel_placement_id = pph.master_placement_id 
-- where
--     td.serial_no = 'S0244800001'
-- order by
--     td.panel_id asc
-- go

select distinct
    td.serial_no,
    -- td.panel_id,
    td.pattern_id,
    td.barcode,
    td.top_bottom,
    -- p.panel_id,
    p.equipment_id,
    p.nc_version,
    -- p.panel_equipment_id,
    -- p.panel_source,
    -- p.panel_trace,
    p.stage_no,
    p.lane_no,
    -- p.trx_product_id,
    -- pph.panel_equipment_id,
    -- pph.equipment_id,
    pph.master_placement_id,
    pph.panel_placement_id,
    -- pph.timestamp,
    -- pph.trx_product_id,
    -- ppd.panel_placement_id,
    ppd.reel_id,
    ppd.nc_placement_id,
    ppd.pattern_no,
    ppd.z_num,
    ppd.pu_num,
    ppd.part_no,
    -- ppd.custom_area1,
    -- ppd.custom_area2,
    -- ppd.custom_area3,
    -- ppd.custom_area4,
    ppd.ref_designator
from
    tracking_data td
inner join 
    panels p
on
    td.panel_id = p.panel_id
inner join 
    panel_placement_header pph
on
    pph.panel_equipment_id = p.panel_equipment_id
and
    pph.equipment_id = p.equipment_id
inner join 
    panel_placement_details ppd
on
    ppd.panel_placement_id = pph.panel_placement_id 
or
    ppd.panel_placement_id = pph.master_placement_id 
where
    td.serial_no = 'S0244800001'
order by
    p.equipment_id asc,
    ppd.pu_num asc
go

select distinct
    td.serial_no,
    -- td.panel_id,
    td.pattern_id,
    td.barcode,
    td.top_bottom,
    -- p.panel_id,
    p.equipment_id,
    p.nc_version,
    -- p.panel_equipment_id,
    -- p.panel_source,
    -- p.panel_trace,
    p.stage_no,
    p.lane_no,
    p.trx_product_id
from
    tracking_data td
inner join 
    panels p
on
    td.panel_id = p.panel_id
where
    td.serial_no = 'S0244800001'
order by
    p.equipment_id asc
go

select distinct
    td.serial_no,
    -- td.panel_id,
    td.pattern_id,
    td.barcode,
    td.top_bottom,
    -- p.panel_id,
    p.equipment_id,
    p.nc_version,
    -- p.panel_equipment_id,
    -- p.panel_source,
    -- p.panel_trace,
    p.stage_no,
    p.lane_no,
    -- p.trx_product_id,
    ncpd.nc_placement_id,
    ncpd.idnum,
    ncpd.ref_designator,
    ncpd.nc_version,
    ncpd.part_name,
    ncpd.pattern_number
from
    tracking_data td
inner join 
    panels p
on
    td.panel_id = p.panel_id
inner join 
    nc_placement_detail ncpd
on
    ncpd.nc_version = p.nc_version
where
    td.serial_no = 'S0244800001'
order by
    p.equipment_id asc,
    p.nc_version asc,
    ncpd.part_name asc
go

select distinct
    td.serial_no,
    -- td.panel_id,
    -- td.pattern_id,
    -- td.barcode,
    td.top_bottom,
    -- p.panel_id,
    p.equipment_id,
    p.nc_version,
    -- p.panel_equipment_id,
    -- p.panel_source,
    -- p.panel_trace,
    p.stage_no,
    p.lane_no,
    -- p.trx_product_id,
    ncpd.nc_placement_id,
    ncpd.idnum,
    ncpd.ref_designator,
    ncpd.nc_version,
    ncpd.part_name,
    ncpd.pattern_number
from
    tracking_data td
inner join 
    panels p
on
    td.panel_id = p.panel_id
inner join 
    nc_placement_detail ncpd
on
    ncpd.nc_version = p.nc_version
where
    td.serial_no = 'S0244800001'
order by
    p.equipment_id asc,
    p.nc_version asc,
    ncpd.part_name asc
go
