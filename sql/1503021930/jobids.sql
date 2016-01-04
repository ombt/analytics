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
-- product_run_history product_run_history_id
-- product_run_history equipment_id
-- product_run_history lane_no
-- product_run_history setup_id
-- product_run_history start_time
-- product_run_history end_time

select 
    count(*) as 'jobid_cnt'
from
    panels p
go
select 
    -- p.job_id as 'p.job_id'
    count(*) as 'null_jobid_cnt'
from
    panels p
where
    p.job_id IS NULL
go
select 
    -- p.job_id as 'p.job_id'
    count(*) as 'not_null_jobid_cnt'
from
    panels p
where
    p.job_id IS NOT NULL
go
