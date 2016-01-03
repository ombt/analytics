-- production_reports_kx_hdr
-- production_reports_kx
-- production_reports_kx_hdr_by_board
-- production_reports_kx_by_board
-- production_reports_kx_hdr_raw
-- production_reports_kx_raw

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
-- 
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

-- select
--     ph.mgmt_report_id,
--     ph.report_id,
--     ph.product_id,
--     ph.equipment_id,
--     ph.start_time,
--     ph.end_time,
--     ph.setup_id,
--     ph.nc_version,
--     ph.lane_no,
--     ph.job_id,
--     ph.report_file
-- from
--     production_reports_kx_hdr ph
-- where
--     ph.equipment_id = 1002
-- and
--     ph.start_time <= 1433054421
-- and
--     1433054421 <= ph.end_time
-- go
-- 
-- select
--     ph.mgmt_report_id,
--     ph.report_id,
--     ph.product_id,
--     ph.equipment_id,
--     ph.start_time,
--     ph.end_time,
--     ph.setup_id,
--     ph.nc_version,
--     ph.lane_no,
--     ph.job_id,
--     ph.report_file,
--     p.report_id,
--     p.stage_no,
--     -- p.total_run_time,
--     -- p.real_run_time,
--     p.pickup_count,
--     -- p.pickup_miss_count,
--     -- p.recog_miss_count,
--     -- p.height_miss_count,
--     p.place_count,
--     p.boards_produced,
--     p.blocks_produced
--     -- p.print_boards,
--     -- p.solder_supply_count,
--     -- p.cleaning_count,
--     -- p.total_down_time,
--     -- p.prev_proc_wait_time,
--     -- p.next_proc_wait_time,
--     -- p.singl_cycl_stop_time,
--     -- p.chip_supp_wait_time,
--     -- p.sldr_ctr_wait_time,
--     -- p.sldr_snsr_wait_time,
--     -- p.cln_paper_wait_time,
--     -- p.start_imp_stop_time,
--     -- p.singl_cycl_err_time,
--     -- p.chip_eject_err_time,
--     -- p.chip_mount_err_time,
--     -- p.chip_recog_err_time,
--     -- p.chip_errect_err_time,
--     -- p.chip_pickup_err_time,
--     -- p.transport_err_time,
--     -- p.mntpt_recog_err_time,
--     -- p.pcb_recog_err_time,
--     -- p.pcb_elong_err_time,
--     -- p.paste_cntup_err_time,
--     -- p.mask_recog_err_time,
--     -- p.feedback_err_time,
--     -- p.bond_recog_err_time,
--     -- p.other_error_time,
--     -- p.total_down_cnt,
--     -- p.prev_proc_wait_cnt,
--     -- p.next_proc_wait_cnt,
--     -- p.singl_cycl_stop_cnt,
--     -- p.chip_supp_wait_cnt,
--     -- p.sldr_ctr_wait_cnt,
--     -- p.sldr_snsr_wait_cnt,
--     -- p.cln_paper_wait_cnt,
--     -- p.start_imp_stop_cnt,
--     -- p.singl_cycl_err_cnt,
--     -- p.chip_eject_err_cnt,
--     -- p.chip_mount_err_cnt,
--     -- p.chip_recog_err_cnt,
--     -- p.chip_errect_err_cnt,
--     -- p.chip_pickup_err_cnt,
--     -- p.transport_err_cnt,
--     -- p.mntpt_recog_err_cnt,
--     -- p.pcb_recog_err_cnt,
--     -- p.pcb_elong_err_cnt,
--     -- p.paste_cntup_err_cnt,
--     -- p.mask_recog_err_cnt,
--     -- p.feedback_err_cnt,
--     -- p.bond_recog_err_cnt,
--     -- p.other_error_cnt
-- from
--     production_reports_kx_hdr ph
-- inner join
--     production_reports_kx p
-- on
--     ph.report_id = p.report_id
-- where
--     ph.equipment_id = 1002
-- and
--     ph.start_time <= 1433054421
-- and
--     1433054421 <= ph.end_time
-- go
-- 
-- select
--     ph.mgmt_report_id,
--     ph.report_id,
--     ph.product_id,
--     ph.equipment_id,
--     ph.start_time,
--     ph.end_time,
--     ph.setup_id,
--     ph.nc_version,
--     ph.lane_no,
--     -- ph.job_id,
--     -- ph.report_file
--     -- p.report_id,
--     p.stage_no,
--     -- p.total_run_time,
--     -- p.real_run_time,
--     p.pickup_count,
--     -- p.pickup_miss_count,
--     -- p.recog_miss_count,
--     -- p.height_miss_count,
--     p.place_count
--     -- p.boards_produced,
--     -- p.blocks_produced
--     -- p.print_boards,
--     -- p.solder_supply_count,
--     -- p.cleaning_count,
--     -- p.total_down_time,
--     -- p.prev_proc_wait_time,
--     -- p.next_proc_wait_time,
--     -- p.singl_cycl_stop_time,
--     -- p.chip_supp_wait_time,
--     -- p.sldr_ctr_wait_time,
--     -- p.sldr_snsr_wait_time,
--     -- p.cln_paper_wait_time,
--     -- p.start_imp_stop_time,
--     -- p.singl_cycl_err_time,
--     -- p.chip_eject_err_time,
--     -- p.chip_mount_err_time,
--     -- p.chip_recog_err_time,
--     -- p.chip_errect_err_time,
--     -- p.chip_pickup_err_time,
--     -- p.transport_err_time,
--     -- p.mntpt_recog_err_time,
--     -- p.pcb_recog_err_time,
--     -- p.pcb_elong_err_time,
--     -- p.paste_cntup_err_time,
--     -- p.mask_recog_err_time,
--     -- p.feedback_err_time,
--     -- p.bond_recog_err_time,
--     -- p.other_error_time,
--     -- p.total_down_cnt,
--     -- p.prev_proc_wait_cnt,
--     -- p.next_proc_wait_cnt,
--     -- p.singl_cycl_stop_cnt,
--     -- p.chip_supp_wait_cnt,
--     -- p.sldr_ctr_wait_cnt,
--     -- p.sldr_snsr_wait_cnt,
--     -- p.cln_paper_wait_cnt,
--     -- p.start_imp_stop_cnt,
--     -- p.singl_cycl_err_cnt,
--     -- p.chip_eject_err_cnt,
--     -- p.chip_mount_err_cnt,
--     -- p.chip_recog_err_cnt,
--     -- p.chip_errect_err_cnt,
--     -- p.chip_pickup_err_cnt,
--     -- p.transport_err_cnt,
--     -- p.mntpt_recog_err_cnt,
--     -- p.pcb_recog_err_cnt,
--     -- p.pcb_elong_err_cnt,
--     -- p.paste_cntup_err_cnt,
--     -- p.mask_recog_err_cnt,
--     -- p.feedback_err_cnt,
--     -- p.bond_recog_err_cnt,
--     -- p.other_error_cnt
-- from
--     production_reports_kx_hdr ph
-- inner join
--     production_reports_kx p
-- on
--     ph.report_id = p.report_id
-- where
--     p.pickup_count > 10000
-- order by
--     ph.equipment_id asc,
--     ph.report_id asc
-- go

select
    ph.equipment_id,
    ph.lane_no,
    p.stage_no,
    count(p.pickup_count) as count_pickup_gt_10000
from
    production_reports_kx_hdr ph
inner join
    production_reports_kx p
on
    ph.report_id = p.report_id
where
    p.pickup_count > 10000
group by
    ph.equipment_id,
    ph.lane_no,
    p.stage_no
order by
    ph.equipment_id asc,
    ph.lane_no asc,
    p.stage_no asc
go

select
    ph.equipment_id,
    ph.lane_no,
    p.stage_no,
    count(p.pickup_count) as count_pickup_le_10000
from
    production_reports_kx_hdr ph
inner join
    production_reports_kx p
on
    ph.report_id = p.report_id
where
    p.pickup_count <= 10000
group by
    ph.equipment_id,
    ph.lane_no,
    p.stage_no
order by
    ph.equipment_id asc,
    ph.lane_no asc,
    p.stage_no asc
go

