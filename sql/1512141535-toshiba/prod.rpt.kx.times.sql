-- name name
-- production_reports_kx_hdr mgmt_report_id
-- production_reports_kx_hdr report_id
-- production_reports_kx_hdr product_id
-- production_reports_kx_hdr equipment_id
-- production_reports_kx_hdr start_time
-- production_reports_kx_hdr end_time
-- production_reports_kx_hdr setup_id
-- production_reports_kx_hdr nc_version
-- production_reports_kx_hdr lane_no
-- production_reports_kx_hdr job_id
-- production_reports_kx_hdr report_file
-- name name
-- production_reports_kx report_id
-- production_reports_kx stage_no
-- production_reports_kx total_run_time
-- production_reports_kx real_run_time
-- production_reports_kx pickup_count
-- production_reports_kx pickup_miss_count
-- production_reports_kx recog_miss_count
-- production_reports_kx height_miss_count
-- production_reports_kx place_count
-- production_reports_kx boards_produced
-- production_reports_kx blocks_produced
-- production_reports_kx print_boards
-- production_reports_kx solder_supply_count
-- production_reports_kx cleaning_count
-- production_reports_kx total_down_time
-- production_reports_kx prev_proc_wait_time
-- production_reports_kx next_proc_wait_time
-- production_reports_kx singl_cycl_stop_time
-- production_reports_kx chip_supp_wait_time
-- production_reports_kx sldr_ctr_wait_time
-- production_reports_kx sldr_snsr_wait_time
-- production_reports_kx cln_paper_wait_time
-- production_reports_kx start_imp_stop_time
-- production_reports_kx singl_cycl_err_time
-- production_reports_kx chip_eject_err_time
-- production_reports_kx chip_mount_err_time
-- production_reports_kx chip_recog_err_time
-- production_reports_kx chip_errect_err_time
-- production_reports_kx chip_pickup_err_time
-- production_reports_kx transport_err_time
-- production_reports_kx mntpt_recog_err_time
-- production_reports_kx pcb_recog_err_time
-- production_reports_kx pcb_elong_err_time
-- production_reports_kx paste_cntup_err_time
-- production_reports_kx mask_recog_err_time
-- production_reports_kx feedback_err_time
-- production_reports_kx bond_recog_err_time
-- production_reports_kx other_error_time
-- production_reports_kx total_down_cnt
-- production_reports_kx prev_proc_wait_cnt
-- production_reports_kx next_proc_wait_cnt
-- production_reports_kx singl_cycl_stop_cnt
-- production_reports_kx chip_supp_wait_cnt
-- production_reports_kx sldr_ctr_wait_cnt
-- production_reports_kx sldr_snsr_wait_cnt
-- production_reports_kx cln_paper_wait_cnt
-- production_reports_kx start_imp_stop_cnt
-- production_reports_kx singl_cycl_err_cnt
-- production_reports_kx chip_eject_err_cnt
-- production_reports_kx chip_mount_err_cnt
-- production_reports_kx chip_recog_err_cnt
-- production_reports_kx chip_errect_err_cnt
-- production_reports_kx chip_pickup_err_cnt
-- production_reports_kx transport_err_cnt
-- production_reports_kx mntpt_recog_err_cnt
-- production_reports_kx pcb_recog_err_cnt
-- production_reports_kx pcb_elong_err_cnt
-- production_reports_kx paste_cntup_err_cnt
-- production_reports_kx mask_recog_err_cnt
-- production_reports_kx feedback_err_cnt
-- production_reports_kx bond_recog_err_cnt
-- production_reports_kx other_error_cnt

select
    ph.equipment_id as eqid,
    ph.lane_no as lnno,
    p.stage_no as stgno,
    ph.setup_id as sid,
    ph.product_id as pid,
    min(ph.end_time) as kx_sum_min_time,
    max(ph.end_time) as kx_sum_max_time,
    NULL as last_col
from
    production_reports_kx_hdr ph
inner join
    production_reports_kx p
on
    p.report_id = ph.report_id
where
    ph.equipment_id in ( 1001, 1003, 1005, 1009 )
group by
    ph.equipment_id,
    ph.lane_no,
    p.stage_no,
    ph.setup_id,
    ph.product_id
order by
    ph.equipment_id,
    ph.lane_no,
    p.stage_no,
    ph.setup_id,
    ph.product_id,
    kx_sum_max_time
go

select
    ph.equipment_id as eqid,
    ph.lane_no as lnno,
    p.stage_no as stgno,
    min(ph.end_time) as kx_sum_min_time,
    max(ph.end_time) as kx_sum_max_time,
    NULL as last_col
from
    production_reports_kx_hdr ph
inner join
    production_reports_kx p
on
    p.report_id = ph.report_id
where
    ph.equipment_id in ( 1001, 1003, 1005, 1009 )
group by
    ph.equipment_id,
    ph.lane_no,
    p.stage_no
order by
    ph.equipment_id,
    ph.lane_no,
    p.stage_no,
    kx_sum_max_time
go

select
    ph.equipment_id as eqid,
    min(ph.end_time) as kx_sum_min_time,
    max(ph.end_time) as kx_sum_max_time,
    NULL as last_col
from
    production_reports_kx_hdr ph
inner join
    production_reports_kx p
on
    p.report_id = ph.report_id
where
    ph.equipment_id in ( 1001, 1003, 1005, 1009 )
group by
    ph.equipment_id
order by
    ph.equipment_id,
    kx_sum_max_time
go

select
    ph.equipment_id as eqid,
    ph.lane_no as lnno,
    p.stage_no as stgno,
    ph.setup_id as sid,
    ph.product_id as pid,
    min(ph.end_time) as kx_raw_min_time,
    max(ph.end_time) as kx_raw_max_time,
    NULL as last_col
from
    production_reports_kx_hdr_raw ph
inner join
    production_reports_kx_raw p
on
    p.report_id = ph.report_id
where
    ph.equipment_id in ( 1001, 1003, 1005, 1009 )
group by
    ph.equipment_id,
    ph.lane_no,
    p.stage_no,
    ph.setup_id,
    ph.product_id
order by
    ph.equipment_id,
    ph.lane_no,
    p.stage_no,
    ph.setup_id,
    ph.product_id,
    kx_raw_max_time
go

select
    ph.equipment_id as eqid,
    ph.lane_no as lnno,
    p.stage_no as stgno,
    min(ph.end_time) as kx_raw_min_time,
    max(ph.end_time) as kx_raw_max_time,
    NULL as last_col
from
    production_reports_kx_hdr_raw ph
inner join
    production_reports_kx_raw p
on
    p.report_id = ph.report_id
where
    ph.equipment_id in ( 1001, 1003, 1005, 1009 )
group by
    ph.equipment_id,
    ph.lane_no,
    p.stage_no
order by
    ph.equipment_id,
    ph.lane_no,
    p.stage_no,
    kx_raw_max_time
go

select
    ph.equipment_id as eqid,
    min(ph.end_time) as kx_raw_min_time,
    max(ph.end_time) as kx_raw_max_time,
    NULL as last_col
from
    production_reports_kx_hdr_raw ph
inner join
    production_reports_kx_raw p
on
    p.report_id = ph.report_id
where
    ph.equipment_id in ( 1001, 1003, 1005, 1009 )
group by
    ph.equipment_id
order by
    ph.equipment_id,
    kx_raw_max_time
go

select
    phr.equipment_id as eqid,
    min(ph.end_time) as kx_sum_min_time,
    max(ph.end_time) as kx_sum_max_time,
    min(phr.end_time) as kx_raw_min_time,
    max(phr.end_time) as kx_raw_max_time,
    NULL as last_col
from
    production_reports_kx_hdr_raw phr
inner join
    production_reports_kx_hdr ph
on
    ph.equipment_id = ph.equipment_id
where
    phr.equipment_id in ( 1001, 1003, 1005, 1009 )
group by
    phr.equipment_id
order by
    phr.equipment_id
go

