-- 
-- panel_strace_header panel_equipment_id
-- panel_strace_header equipment_id
-- panel_strace_header master_strace_id
-- panel_strace_header panel_strace_id
-- panel_strace_header timestamp
-- panel_strace_header trx_product_id
-- 
-- panel_strace_details panel_strace_id
-- panel_strace_details reel_id
-- panel_strace_details z_num
-- panel_strace_details pu_num
-- panel_strace_details part_no
-- panel_strace_details custom_area1
-- panel_strace_details custom_area2
-- panel_strace_details custom_area3
-- panel_strace_details custom_area4
-- panel_strace_details feeder_bc
-- 
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
-- 
-- track_panels track_panels_id
-- track_panels serial_no
-- track_panels prod_model_no
-- track_panels panel_id
-- track_panels pattern_id
-- track_panels barcode
-- track_panels setup_id
-- track_panels top_bottom
-- track_panels equipment_id
-- track_panels nc_version
-- track_panels start_time
-- track_panels end_time
-- track_panels panel_equipment_id
-- track_panels panel_source
-- track_panels panel_trace
-- track_panels stage_no
-- track_panels lane_no
-- track_panels job_id
-- track_panels trx_product_id
-- 
-- tracking_data serial_no
-- tracking_data prod_model_no
-- tracking_data panel_id
-- tracking_data pattern_id
-- tracking_data barcode
-- tracking_data setup_id
-- tracking_data top_bottom
-- tracking_data timestamp
-- tracking_data import_flag
--

-- select 
--     count(*)
-- from
--     panel_strace_header sh
-- go 

-- select 
--     top(10)
--     sh.panel_equipment_id,
--     sh.equipment_id,
--     sh.master_strace_id,
--     sh.panel_strace_id,
--     sh.timestamp,
--     sh.trx_product_id,
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
--     panel_strace_header sh
-- left join
--     panels p
-- on
--     p.panel_equipment_id = sh.panel_equipment_id
-- order by
--     sh.panel_equipment_id
-- go 

-- select 
--     sh.panel_equipment_id,
--     count(p.panel_equipment_id) as 'panel_count'
-- from
--     panel_strace_header sh
-- left join
--     panels p
-- on
--     p.panel_equipment_id = sh.panel_equipment_id
-- group by
--     sh.panel_equipment_id
-- having
--     count(p.panel_equipment_id) <> 1
-- order by
--     sh.panel_equipment_id
-- go 

-- select 
--     sh.panel_equipment_id,
--     sh.equipment_id,
--     sh.trx_product_id,
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
--     p.trx_product_id,
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
--     panel_strace_header sh
-- left join
--     panels p
-- on
--     p.panel_equipment_id = sh.panel_equipment_id
-- left join
--     tracking_data td
-- on
--     td.panel_id = p.panel_id
-- order by
--     sh.panel_equipment_id asc,
--     td.serial_no asc
-- go 
-- 

-- select 
--     td.serial_no,
--     count(td.serial_no) as 'serial_count'
-- from
--     tracking_data td
-- group by
--     td.serial_no
-- order by
--     td.serial_no asc
-- go 

-- select 
--     top(20)
--     sh.panel_equipment_id,
--     sh.equipment_id,
--     sh.trx_product_id,
--     p.panel_id,
--     p.equipment_id,
-- --     p.nc_version,
-- --     p.start_time,
-- --     p.end_time,
--     p.panel_equipment_id,
-- --     p.panel_source,
-- --     p.panel_trace,
-- --     p.stage_no,
-- --     p.lane_no,
-- --     p.job_id,
-- --     p.setup_id,
--     p.trx_product_id,
--     td.serial_no,
-- --     td.prod_model_no,
--     td.panel_id,
-- --     td.pattern_id,
--     td.barcode
-- --     td.setup_id,
-- --     td.top_bottom,
-- --     td.timestamp,
-- --     td.import_flag
-- from
--     panel_strace_header sh
-- left join
--     panels p
-- on
--     p.panel_equipment_id = sh.panel_equipment_id
-- left join
--     tracking_data td
-- on
--     td.panel_id = p.panel_id
-- order by
--     sh.panel_equipment_id asc,
--     td.serial_no asc
-- go 
-- 

select 
    -- top(100)
    sh.equipment_id,
    sh.panel_equipment_id,
    sh.trx_product_id,
    p.panel_id,
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
--     p.trx_product_id,
    td.serial_no,
    td.barcode,
    td.prod_model_no,
    td.panel_id,
    td.pattern_id,
    td.setup_id,
    td.top_bottom,
    td.timestamp,
    td.import_flag
from
    panel_strace_header sh
full outer join
    panels p
on
    p.panel_equipment_id = sh.panel_equipment_id
full outer join
    tracking_data td
on
    td.panel_id = p.panel_id
order by
    sh.equipment_id asc,
    td.serial_no asc,
    sh.panel_equipment_id asc
go 

