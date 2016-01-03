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
-- 
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
-- routes route_id
-- routes route_name
-- routes host_name
-- routes dos_line_no
-- routes flow_direction
-- routes valid_flag
-- routes subimport_path
-- routes stand_alone
-- routes route_startup
-- routes lnb_host_name
-- routes route_abbr
-- routes dgs_line_id
-- routes dgs_import_mode
-- routes mgmt_upload_type
-- routes sub_part_import_src
-- routes navi_import_mode
-- routes restricted_components_enabled
-- routes separate_network_ip
-- routes separate_network_enabled
-- routes publish_mode
-- routes linked_to_publish
-- routes publish_route_id
-- routes disable_tray_part_scan
-- routes enable_tray_interlock
-- routes bmx_zone_id
-- routes bmx_storage_unit_id
-- routes bmx_dedication_type
-- routes pt200_line_id
-- routes allow_delete

-- 
-- route_layout route_id
-- route_layout pos
-- route_layout zone_id
-- route_layout dos_cell_no
-- route_layout pro_module_no

-- 
-- zones zone_id
-- zones zone_name
-- zones host_name
-- zones control_mode
-- zones control_level
-- zones trace_level
-- zones queue_size
-- zones zone_type
-- zones valid_flag
-- zones zone_barcode
-- zones mgmt_mode
-- zones product_mode
-- zones program_mode
-- zones zone_startup
-- zones pin_adjust_mode
-- zones module_id
-- zones ms_zone_id
-- zones active_status
-- zones module_type
-- zones operational_level
-- zones allow_delete

-- 
-- zone_layout zone_id 
-- zone_layout pos 
-- zone_layout equipment_id 

-- 
-- machines equipment_id
-- machines model_number
-- machines mgmt_report
-- machines double_feeder_mode
-- machines cmd_flags
-- machines data_flags
-- machines mgmt_flags
-- machines file_flags
-- machines dir_flags
-- machines num_files
-- machines del_flags
-- machines ipc
-- machines setup_file_flags
-- machines valid_flag
-- machines spc
-- machines single_lane_mode
-- machines machine_vendor
-- machines file_order
-- machines data_order
-- machines num_stages
-- machines simulation_mode
-- machines cph_in_thousands

-- 
-- current_feeders equipment_id
-- current_feeders slot
-- current_feeders subslot
-- current_feeders reel_id
-- current_feeders timestamp
-- current_feeders supply_method
-- current_feeders feeder_id
-- current_feeders operator_id
-- current_feeders splice_operator_id
-- current_feeders expected_pn
-- current_feeders primary_pn
-- current_feeders pu_number
-- current_feeders audit_status
-- current_feeders audit_failures
-- current_feeders audit_timestamp

-- 
-- feeder_history feeder_history_id
-- feeder_history equipment_id
-- feeder_history carriage_no
-- feeder_history slot
-- feeder_history subslot
-- feeder_history time_on
-- feeder_history time_off
-- feeder_history reel_id
-- feeder_history operation_type
-- feeder_history feeder_id
-- feeder_history operator_id
-- feeder_history unmount_operator_id
-- feeder_history splice_operator_id
-- feeder_history expected_pn
-- feeder_history pu_number
-- feeder_history material_name
-- feeder_history comparison_id
-- feeder_history override_reason
-- feeder_history pac_part_no
-- feeder_history pac_extra_data
-- feeder_history pac_evaluation
-- feeder_history next_reel_id

-- reel_data reel_id
-- reel_data part_no
-- reel_data mcid
-- reel_data vendor_no
-- reel_data lot_no
-- reel_data quantity
-- reel_data user_data
-- reel_data reel_barcode
-- reel_data current_quantity
-- reel_data update_time
-- reel_data master_reel_id
-- reel_data create_time
-- reel_data part_class
-- reel_data material_name
-- reel_data prev_reel_id
-- reel_data next_reel_id
-- reel_data adjusted_current_quantity
-- reel_data tray_quantity
-- reel_data bulk_master_id
-- reel_data is_msd

-- equipment equipment_id
-- equipment equipment_name
-- equipment equipment_type
-- equipment icon_filename
-- equipment valid_flag
-- equipment equipment_abbr
-- equipment pmd_priority_group_id

-- production_reports_kx_hdr_raw mgmt_report_id
-- production_reports_kx_hdr_raw report_id
-- production_reports_kx_hdr_raw product_id
-- production_reports_kx_hdr_raw equipment_id
-- production_reports_kx_hdr_raw start_time
-- production_reports_kx_hdr_raw end_time
-- production_reports_kx_hdr_raw setup_id
-- production_reports_kx_hdr_raw nc_version
-- production_reports_kx_hdr_raw lane_no
-- production_reports_kx_hdr_raw job_id
-- production_reports_kx_hdr_raw report_file
-- 
-- production_reports_kx_raw report_id
-- production_reports_kx_raw stage_no
-- production_reports_kx_raw total_run_time
-- production_reports_kx_raw real_run_time
-- production_reports_kx_raw pickup_count
-- production_reports_kx_raw pickup_miss_count
-- production_reports_kx_raw recog_miss_count
-- production_reports_kx_raw height_miss_count
-- production_reports_kx_raw place_count
-- production_reports_kx_raw boards_produced
-- production_reports_kx_raw blocks_produced
-- production_reports_kx_raw print_boards
-- production_reports_kx_raw solder_supply_count
-- production_reports_kx_raw cleaning_count
-- production_reports_kx_raw total_down_time
-- production_reports_kx_raw prev_proc_wait_time
-- production_reports_kx_raw next_proc_wait_time
-- production_reports_kx_raw singl_cycl_stop_time
-- production_reports_kx_raw chip_supp_wait_time
-- production_reports_kx_raw sldr_ctr_wait_time
-- production_reports_kx_raw sldr_snsr_wait_time
-- production_reports_kx_raw cln_paper_wait_time
-- production_reports_kx_raw start_imp_stop_time
-- production_reports_kx_raw singl_cycl_err_time
-- production_reports_kx_raw chip_eject_err_time
-- production_reports_kx_raw chip_mount_err_time
-- production_reports_kx_raw chip_recog_err_time
-- production_reports_kx_raw chip_errect_err_time
-- production_reports_kx_raw chip_pickup_err_time
-- production_reports_kx_raw transport_err_time
-- production_reports_kx_raw mntpt_recog_err_time
-- production_reports_kx_raw pcb_recog_err_time
-- production_reports_kx_raw pcb_elong_err_time
-- production_reports_kx_raw paste_cntup_err_time
-- production_reports_kx_raw mask_recog_err_time
-- production_reports_kx_raw feedback_err_time
-- production_reports_kx_raw bond_recog_err_time
-- production_reports_kx_raw other_error_time
-- production_reports_kx_raw total_down_cnt
-- production_reports_kx_raw prev_proc_wait_cnt
-- production_reports_kx_raw next_proc_wait_cnt
-- production_reports_kx_raw singl_cycl_stop_cnt
-- production_reports_kx_raw chip_supp_wait_cnt
-- production_reports_kx_raw sldr_ctr_wait_cnt
-- production_reports_kx_raw sldr_snsr_wait_cnt
-- production_reports_kx_raw cln_paper_wait_cnt
-- production_reports_kx_raw start_imp_stop_cnt
-- production_reports_kx_raw singl_cycl_err_cnt
-- production_reports_kx_raw chip_eject_err_cnt
-- production_reports_kx_raw chip_mount_err_cnt
-- production_reports_kx_raw chip_recog_err_cnt
-- production_reports_kx_raw chip_errect_err_cnt
-- production_reports_kx_raw chip_pickup_err_cnt
-- production_reports_kx_raw transport_err_cnt
-- production_reports_kx_raw mntpt_recog_err_cnt
-- production_reports_kx_raw pcb_recog_err_cnt
-- production_reports_kx_raw pcb_elong_err_cnt
-- production_reports_kx_raw paste_cntup_err_cnt
-- production_reports_kx_raw mask_recog_err_cnt
-- production_reports_kx_raw feedback_err_cnt
-- production_reports_kx_raw bond_recog_err_cnt
-- production_reports_kx_raw other_error_cnt

print N'List reports IDs by route_id and equipment_id for given times'

select
    r.route_id,
    -- r.route_name,
    -- z.zone_id,
    -- z.zone_name,
    m.equipment_id,
    -- eq.equipment_name,
    -- m.double_feeder_mode,
    -- m.single_lane_mode,
    -- m.num_stages,
    -- prkxh.mgmt_report_id,
    prkxh.report_id,
    -- prkxh.product_id,
    -- prkxh.equipment_id,
    prkxh.start_time,
    prkxh.end_time,
    -- prkxh.setup_id,
    -- prkxh.nc_version,
    prkxh.lane_no
    -- prkxh.job_id,
    -- prkxh.report_file
from
    routes r
inner join
    route_layout rl
on
    r.route_id = rl.route_id
inner join
    zones z
on
    rl.zone_id = z.zone_id
inner join
    zone_layout zl
on
    z.zone_id = zl.zone_id
inner join
    machines m
on
    zl.equipment_id = m.equipment_id
inner join
    equipment eq
on
    eq.equipment_id = m.equipment_id
inner join
    production_reports_kx_hdr prkxh
on
    prkxh.equipment_id =  zl.equipment_id
where
    r.valid_flag = 'T'
and
    z.module_id <> -1
and
    prkxh.end_time > 1422540000
and
    prkxh.end_time <= 1422626400
order by
    r.route_id asc,
    zl.equipment_id asc
go

print N'Generate ALL SUMs for by route_id, equipment_id, lane_no, and stage_no for given times'

select
    r.route_id,
    -- r.route_name,
    -- z.zone_id,
    -- z.zone_name,
    m.equipment_id,
    -- eq.equipment_name,
    -- m.double_feeder_mode,
    -- m.single_lane_mode,
    -- m.num_stages,
    -- prkxh.mgmt_report_id,
    -- prkxh.report_id,
    -- prkxh.product_id,
    -- prkxh.equipment_id,
    -- prkxh.start_time,
    -- prkxh.end_time,
    -- prkxh.setup_id,
    -- prkxh.nc_version,
    prkxh.lane_no,
    -- prkxh.job_id,
    -- prkxh.report_file
    -- prkx.report_id,
    sum(prkx.stage_no) as 'sum_stage_no', 
    sum(prkx.total_run_time) as 'sum_total_run_time', 
    sum(prkx.real_run_time) as 'sum_real_run_time', 
    sum(prkx.pickup_count) as 'sum_pickup_count', 
    sum(prkx.pickup_miss_count) as 'sum_pickup_miss_count', 
    sum(prkx.recog_miss_count) as 'sum_recog_miss_count', 
    sum(prkx.height_miss_count) as 'sum_height_miss_count', 
    sum(prkx.place_count) as 'sum_place_count', 
    sum(prkx.boards_produced) as 'sum_boards_produced', 
    sum(prkx.blocks_produced) as 'sum_blocks_produced', 
    sum(prkx.print_boards) as 'sum_print_boards', 
    sum(prkx.solder_supply_count) as 'sum_solder_supply_count', 
    sum(prkx.cleaning_count) as 'sum_cleaning_count', 
    sum(prkx.total_down_time) as 'sum_total_down_time', 
    sum(prkx.prev_proc_wait_time) as 'sum_prev_proc_wait_time', 
    sum(prkx.next_proc_wait_time) as 'sum_next_proc_wait_time', 
    sum(prkx.singl_cycl_stop_time) as 'sum_singl_cycl_stop_time', 
    sum(prkx.chip_supp_wait_time) as 'sum_chip_supp_wait_time', 
    sum(prkx.sldr_ctr_wait_time) as 'sum_sldr_ctr_wait_time', 
    sum(prkx.sldr_snsr_wait_time) as 'sum_sldr_snsr_wait_time', 
    sum(prkx.cln_paper_wait_time) as 'sum_cln_paper_wait_time', 
    sum(prkx.start_imp_stop_time) as 'sum_start_imp_stop_time', 
    sum(prkx.singl_cycl_err_time) as 'sum_singl_cycl_err_time', 
    sum(prkx.chip_eject_err_time) as 'sum_chip_eject_err_time', 
    sum(prkx.chip_mount_err_time) as 'sum_chip_mount_err_time', 
    sum(prkx.chip_recog_err_time) as 'sum_chip_recog_err_time', 
    sum(prkx.chip_errect_err_time) as 'sum_chip_errect_err_time', 
    sum(prkx.chip_pickup_err_time) as 'sum_chip_pickup_err_time', 
    sum(prkx.transport_err_time) as 'sum_transport_err_time', 
    sum(prkx.mntpt_recog_err_time) as 'sum_mntpt_recog_err_time', 
    sum(prkx.pcb_recog_err_time) as 'sum_pcb_recog_err_time', 
    sum(prkx.pcb_elong_err_time) as 'sum_pcb_elong_err_time', 
    sum(prkx.paste_cntup_err_time) as 'sum_paste_cntup_err_time', 
    sum(prkx.mask_recog_err_time) as 'sum_mask_recog_err_time', 
    sum(prkx.feedback_err_time) as 'sum_feedback_err_time', 
    sum(prkx.bond_recog_err_time) as 'sum_bond_recog_err_time', 
    sum(prkx.other_error_time) as 'sum_other_error_time', 
    sum(prkx.total_down_cnt) as 'sum_total_down_cnt', 
    sum(prkx.prev_proc_wait_cnt) as 'sum_prev_proc_wait_cnt', 
    sum(prkx.next_proc_wait_cnt) as 'sum_next_proc_wait_cnt', 
    sum(prkx.singl_cycl_stop_cnt) as 'sum_singl_cycl_stop_cnt', 
    sum(prkx.chip_supp_wait_cnt) as 'sum_chip_supp_wait_cnt', 
    sum(prkx.sldr_ctr_wait_cnt) as 'sum_sldr_ctr_wait_cnt', 
    sum(prkx.sldr_snsr_wait_cnt) as 'sum_sldr_snsr_wait_cnt', 
    sum(prkx.cln_paper_wait_cnt) as 'sum_cln_paper_wait_cnt', 
    sum(prkx.start_imp_stop_cnt) as 'sum_start_imp_stop_cnt', 
    sum(prkx.singl_cycl_err_cnt) as 'sum_singl_cycl_err_cnt', 
    sum(prkx.chip_eject_err_cnt) as 'sum_chip_eject_err_cnt', 
    sum(prkx.chip_mount_err_cnt) as 'sum_chip_mount_err_cnt', 
    sum(prkx.chip_recog_err_cnt) as 'sum_chip_recog_err_cnt', 
    sum(prkx.chip_errect_err_cnt) as 'sum_chip_errect_err_cnt', 
    sum(prkx.chip_pickup_err_cnt) as 'sum_chip_pickup_err_cnt', 
    sum(prkx.transport_err_cnt) as 'sum_transport_err_cnt', 
    sum(prkx.mntpt_recog_err_cnt) as 'sum_mntpt_recog_err_cnt', 
    sum(prkx.pcb_recog_err_cnt) as 'sum_pcb_recog_err_cnt', 
    sum(prkx.pcb_elong_err_cnt) as 'sum_pcb_elong_err_cnt', 
    sum(prkx.paste_cntup_err_cnt) as 'sum_paste_cntup_err_cnt', 
    sum(prkx.mask_recog_err_cnt) as 'sum_mask_recog_err_cnt', 
    sum(prkx.feedback_err_cnt) as 'sum_feedback_err_cnt', 
    sum(prkx.bond_recog_err_cnt) as 'sum_bond_recog_err_cnt', 
    sum(prkx.other_error_cnt) as 'sum_other_error_cnt'
from
    routes r
inner join
    route_layout rl
on
    r.route_id = rl.route_id
inner join
    zones z
on
    rl.zone_id = z.zone_id
inner join
    zone_layout zl
on
    z.zone_id = zl.zone_id
inner join
    machines m
on
    zl.equipment_id = m.equipment_id
inner join
    equipment eq
on
    eq.equipment_id = m.equipment_id
inner join
    production_reports_kx_hdr prkxh
on
    prkxh.equipment_id =  zl.equipment_id
inner join
    production_reports_kx prkx
on
    prkx.report_id = prkxh.report_id
where
    r.valid_flag = 'T'
and
    z.module_id <> -1
and
    prkxh.end_time > 1422540000
and
    prkxh.end_time <= 1422626400
group by
    r.route_id,
    m.equipment_id,
    prkxh.lane_no,
    prkx.stage_no
order by
    r.route_id asc,
    m.equipment_id asc,
    prkxh.lane_no asc,
    prkx.stage_no asc
go

print N'Generate SELECT SUMs for by route_id, equipment_id, lane_no, and stage_no for given times'

select
    r.route_id,
    -- r.route_name,
    -- z.zone_id,
    -- z.zone_name,
    m.equipment_id,
    -- eq.equipment_name,
    -- m.double_feeder_mode,
    -- m.single_lane_mode,
    -- m.num_stages,
    -- prkxh.mgmt_report_id,
    -- prkxh.report_id,
    -- prkxh.product_id,
    -- prkxh.equipment_id,
    -- prkxh.start_time,
    -- prkxh.end_time,
    -- prkxh.setup_id,
    -- prkxh.nc_version,
    prkxh.lane_no,
    -- prkxh.job_id,
    -- prkxh.report_file
    -- prkx.report_id,
    sum(prkx.stage_no) as 'sum_stage_no', 
    -- sum(prkx.total_run_time) as 'sum_total_run_time', 
    sum(prkx.real_run_time) as 'sum_real_run_time', 
    sum(prkx.total_down_time) as 'sum_total_down_time', 
    sum(prkx.prev_proc_wait_time) as 'sum_prev_proc_wait_time', 
    sum(prkx.next_proc_wait_time) as 'sum_next_proc_wait_time', 
    sum(prkx.singl_cycl_stop_time) as 'sum_singl_cycl_stop_time', 
    sum(prkx.chip_supp_wait_time) as 'sum_chip_supp_wait_time', 
    sum(prkx.sldr_ctr_wait_time) as 'sum_sldr_ctr_wait_time', 
    sum(prkx.sldr_snsr_wait_time) as 'sum_sldr_snsr_wait_time', 
    sum(prkx.cln_paper_wait_time) as 'sum_cln_paper_wait_time'
from
    routes r
inner join
    route_layout rl
on
    r.route_id = rl.route_id
inner join
    zones z
on
    rl.zone_id = z.zone_id
inner join
    zone_layout zl
on
    z.zone_id = zl.zone_id
inner join
    machines m
on
    zl.equipment_id = m.equipment_id
inner join
    equipment eq
on
    eq.equipment_id = m.equipment_id
inner join
    production_reports_kx_hdr prkxh
on
    prkxh.equipment_id =  zl.equipment_id
inner join
    production_reports_kx prkx
on
    prkx.report_id = prkxh.report_id
where
    r.valid_flag = 'T'
and
    z.module_id <> -1
and
    prkxh.end_time > 1422540000
and
    prkxh.end_time <= 1422626400
group by
    r.route_id,
    m.equipment_id,
    prkxh.lane_no,
    prkx.stage_no
order by
    r.route_id asc,
    m.equipment_id asc,
    prkxh.lane_no asc,
    prkx.stage_no asc
go

print N'Generate SELECT SUMs with EXCLUDING OUTLIERS for by route_id, equipment_id, lane_no, and stage_no for given times'

select
    r.route_id,
    -- r.route_name,
    -- z.zone_id,
    -- z.zone_name,
    m.equipment_id,
    -- eq.equipment_name,
    -- m.double_feeder_mode,
    -- m.single_lane_mode,
    -- m.num_stages,
    -- prkxh.mgmt_report_id,
    -- prkxh.report_id,
    -- prkxh.product_id,
    -- prkxh.equipment_id,
    -- prkxh.start_time,
    -- prkxh.end_time,
    -- prkxh.setup_id,
    -- prkxh.nc_version,
    prkxh.lane_no,
    -- prkxh.job_id,
    -- prkxh.report_file
    -- prkx.report_id,
    sum(prkx.stage_no) as 'sum_stage_no', 
    -- sum(prkx.total_run_time) as 'sum_total_run_time', 
    sum(prkx.real_run_time) as 'sum_real_run_time', 
    sum(prkx.total_down_time) as 'sum_total_down_time', 
    sum(prkx.prev_proc_wait_time) as 'sum_prev_proc_wait_time', 
    sum(prkx.next_proc_wait_time) as 'sum_next_proc_wait_time', 
    sum(prkx.singl_cycl_stop_time) as 'sum_singl_cycl_stop_time', 
    sum(prkx.chip_supp_wait_time) as 'sum_chip_supp_wait_time', 
    sum(prkx.sldr_ctr_wait_time) as 'sum_sldr_ctr_wait_time', 
    sum(prkx.sldr_snsr_wait_time) as 'sum_sldr_snsr_wait_time', 
    sum(prkx.cln_paper_wait_time) as 'sum_cln_paper_wait_time'
from
    routes r
inner join
    route_layout rl
on
    r.route_id = rl.route_id
inner join
    zones z
on
    rl.zone_id = z.zone_id
inner join
    zone_layout zl
on
    z.zone_id = zl.zone_id
inner join
    machines m
on
    zl.equipment_id = m.equipment_id
inner join
    equipment eq
on
    eq.equipment_id = m.equipment_id
inner join
    production_reports_kx_hdr prkxh
on
    prkxh.equipment_id =  zl.equipment_id
inner join
    production_reports_kx prkx
on
    prkx.report_id = prkxh.report_id
where
    r.valid_flag = 'T'
and
    z.module_id <> -1
and
    prkxh.end_time > 1422540000
and
    prkxh.end_time <= 1422626400
and
    prkx.real_run_time <= 1000
group by
    r.route_id,
    m.equipment_id,
    prkxh.lane_no,
    prkx.stage_no
order by
    r.route_id asc,
    m.equipment_id asc,
    prkxh.lane_no asc,
    prkx.stage_no asc
go

print N'Summary Data with INCLUDING ONLY OUTLIERS for by route_id, equipment_id, lane_no, and stage_no for given times'

select
    r.route_id,
    -- r.route_name,
    -- z.zone_id,
    -- z.zone_name,
    m.equipment_id,
    -- eq.equipment_name,
    -- m.double_feeder_mode,
    -- m.single_lane_mode,
    -- m.num_stages,
    -- prkxh.mgmt_report_id,
    prkxh.report_id,
    prkxh.product_id,
    -- prkxh.equipment_id,
    prkxh.start_time,
    prkxh.end_time,
    prkxh.setup_id,
    -- prkxh.nc_version,
    prkxh.lane_no,
    -- prkxh.job_id,
    -- prkxh.report_file
    -- prkx.report_id,
    (prkx.stage_no) as 'prkx.stage_no', 
    -- sum(prkx.total_run_time) as 'prkx.total_run_time', 
    (prkx.real_run_time) as 'prkx.real_run_time', 
    (prkx.total_down_time) as 'prkx.total_down_time', 
    (prkx.prev_proc_wait_time) as 'prkx.prev_proc_wait_time', 
    (prkx.next_proc_wait_time) as 'prkx.next_proc_wait_time', 
    (prkx.singl_cycl_stop_time) as 'prkx.singl_cycl_stop_time', 
    (prkx.chip_supp_wait_time) as 'prkx.chip_supp_wait_time', 
    (prkx.sldr_ctr_wait_time) as 'prkx.sldr_ctr_wait_time', 
    (prkx.sldr_snsr_wait_time) as 'prkx.sldr_snsr_wait_time', 
    (prkx.cln_paper_wait_time) as 'prkx.cln_paper_wait_time'
from
    routes r
inner join
    route_layout rl
on
    r.route_id = rl.route_id
inner join
    zones z
on
    rl.zone_id = z.zone_id
inner join
    zone_layout zl
on
    z.zone_id = zl.zone_id
inner join
    machines m
on
    zl.equipment_id = m.equipment_id
inner join
    equipment eq
on
    eq.equipment_id = m.equipment_id
inner join
    production_reports_kx_hdr prkxh
on
    prkxh.equipment_id =  zl.equipment_id
inner join
    production_reports_kx prkx
on
    prkx.report_id = prkxh.report_id
where
    r.valid_flag = 'T'
and
    z.module_id <> -1
and
    prkxh.end_time > 1422540000
and
    prkxh.end_time <= 1422626400
and
    prkx.real_run_time > 1000
order by
    r.route_id asc,
    m.equipment_id asc,
    prkxh.lane_no asc,
    prkx.stage_no asc,
    prkxh.report_id asc
go

print N'All Raw Data with for by route_id, equipment_id, lane_no, and stage_no for given times'

select
    r.route_id,
    -- r.route_name,
    -- z.zone_id,
    -- z.zone_name,
    m.equipment_id,
    -- eq.equipment_name,
    -- m.double_feeder_mode,
    -- m.single_lane_mode,
    -- m.num_stages,
    -- prkxh.mgmt_report_id,
    prkxh.report_id,
    prkxh.product_id,
    -- prkxh.equipment_id,
    prkxh.start_time,
    prkxh.end_time,
    prkxh.setup_id,
    -- prkxh.nc_version,
    prkxh.lane_no,
    -- prkxh.job_id,
    -- prkxh.report_file
    -- prkx.report_id,
    (prkx.stage_no) as 'raw.stage_no', 
    -- sum(prkx.total_run_time) as 'raw.total_run_time', 
    (prkx.real_run_time) as 'raw.real_run_time', 
    (prkx.total_down_time) as 'raw.total_down_time', 
    (prkx.prev_proc_wait_time) as 'raw.prev_proc_wait_time', 
    (prkx.next_proc_wait_time) as 'raw.next_proc_wait_time', 
    (prkx.singl_cycl_stop_time) as 'raw.singl_cycl_stop_time', 
    (prkx.chip_supp_wait_time) as 'raw.chip_supp_wait_time', 
    (prkx.sldr_ctr_wait_time) as 'raw.sldr_ctr_wait_time', 
    (prkx.sldr_snsr_wait_time) as 'raw.sldr_snsr_wait_time', 
    (prkx.cln_paper_wait_time) as 'raw.cln_paper_wait_time'
from
    routes r
inner join
    route_layout rl
on
    r.route_id = rl.route_id
inner join
    zones z
on
    rl.zone_id = z.zone_id
inner join
    zone_layout zl
on
    z.zone_id = zl.zone_id
inner join
    machines m
on
    zl.equipment_id = m.equipment_id
inner join
    equipment eq
on
    eq.equipment_id = m.equipment_id
inner join
    production_reports_kx_hdr_raw prkxh
on
    prkxh.equipment_id =  zl.equipment_id
inner join
    production_reports_kx_raw prkx
on
    prkx.report_id = prkxh.report_id
where
    r.valid_flag = 'T'
and
    z.module_id <> -1
and
    prkxh.end_time > 1422540000
and
    prkxh.end_time <= 1422626400
-- and
    -- prkx.real_run_time > 1000
order by
    r.route_id asc,
    m.equipment_id asc,
    prkxh.lane_no asc,
    prkx.stage_no asc,
    prkxh.report_id asc
go

print N'All Summary Data with for by route_id, equipment_id, lane_no, and stage_no for given times'

select
    r.route_id,
    -- r.route_name,
    -- z.zone_id,
    -- z.zone_name,
    m.equipment_id,
    -- eq.equipment_name,
    -- m.double_feeder_mode,
    -- m.single_lane_mode,
    -- m.num_stages,
    -- prkxh.mgmt_report_id,
    prkxh.report_id,
    prkxh.product_id,
    -- prkxh.equipment_id,
    prkxh.start_time,
    prkxh.end_time,
    prkxh.setup_id,
    -- prkxh.nc_version,
    prkxh.lane_no,
    -- prkxh.job_id,
    -- prkxh.report_file
    -- prkx.report_id,
    (prkx.stage_no) as 'prkx.stage_no', 
    -- sum(prkx.total_run_time) as 'prkx.total_run_time', 
    (prkx.real_run_time) as 'prkx.real_run_time', 
    (prkx.total_down_time) as 'prkx.total_down_time', 
    (prkx.prev_proc_wait_time) as 'prkx.prev_proc_wait_time', 
    (prkx.next_proc_wait_time) as 'prkx.next_proc_wait_time', 
    (prkx.singl_cycl_stop_time) as 'prkx.singl_cycl_stop_time', 
    (prkx.chip_supp_wait_time) as 'prkx.chip_supp_wait_time', 
    (prkx.sldr_ctr_wait_time) as 'prkx.sldr_ctr_wait_time', 
    (prkx.sldr_snsr_wait_time) as 'prkx.sldr_snsr_wait_time', 
    (prkx.cln_paper_wait_time) as 'prkx.cln_paper_wait_time'
from
    routes r
inner join
    route_layout rl
on
    r.route_id = rl.route_id
inner join
    zones z
on
    rl.zone_id = z.zone_id
inner join
    zone_layout zl
on
    z.zone_id = zl.zone_id
inner join
    machines m
on
    zl.equipment_id = m.equipment_id
inner join
    equipment eq
on
    eq.equipment_id = m.equipment_id
inner join
    production_reports_kx_hdr prkxh
on
    prkxh.equipment_id =  zl.equipment_id
inner join
    production_reports_kx prkx
on
    prkx.report_id = prkxh.report_id
where
    r.valid_flag = 'T'
and
    z.module_id <> -1
and
    prkxh.end_time > 1422540000
and
    prkxh.end_time <= 1422626400
-- and
    -- prkx.real_run_time > 1000
order by
    r.route_id asc,
    m.equipment_id asc,
    prkxh.lane_no asc,
    prkx.stage_no asc,
    prkxh.report_id asc
go

print N'Delta Data generated from Raw data for by route_id, equipment_id, lane_no, and stage_no for given times'

with prod_kx_cte (
    route_id,
    equipment_id,
    report_id,
    lane_no,
    stage_no,
    setup_id,
    end_time,
    real_run_time, 
    total_down_time,
    -- prev_proc_wait_time,
    -- next_proc_wait_time,
    -- singl_cycl_stop_time,
    -- chip_supp_wait_time,
    -- sldr_ctr_wait_time,
    -- sldr_snsr_wait_time,
    -- cln_paper_wait_time,
    row
) as (
    select
        r.route_id as route_id,
        m.equipment_id as equipment_id,
        prkxh.report_id as report_id,
        prkxh.lane_no as lane_no,
        prkx.stage_no as stage_no, 
        prkxh.setup_id as setup_id,
        prkxh.end_time as end_time,
        prkx.real_run_time as real_run_time, 
        prkx.total_down_time as total_down_time, 
        -- prkx.prev_proc_wait_time as prev_proc_wait_time, 
        -- prkx.next_proc_wait_time as next_proc_wait_time, 
        -- prkx.singl_cycl_stop_time as singl_cycl_stop_time, 
        -- prkx.chip_supp_wait_time as chip_supp_wait_time, 
        -- prkx.sldr_ctr_wait_time as sldr_ctr_wait_time, 
        -- prkx.sldr_snsr_wait_time as sldr_snsr_wait_time, 
        -- prkx.cln_paper_wait_time as cln_paper_wait_time,
        row_number() over (
            partition by 
                r.route_id,
                m.equipment_id,
                prkxh.lane_no,
                prkx.stage_no,
                prkxh.setup_id
            order by
                r.route_id asc,
                m.equipment_id asc,
                prkxh.lane_no asc,
                prkx.stage_no asc,
                prkxh.setup_id asc,
                prkxh.report_id asc
        ) as row
    from
        routes r
    inner join
        route_layout rl
    on
        r.route_id = rl.route_id
    inner join
        zones z
    on
        rl.zone_id = z.zone_id
    inner join
        zone_layout zl
    on
        z.zone_id = zl.zone_id
    inner join
        machines m
    on
        zl.equipment_id = m.equipment_id
    inner join
        equipment eq
    on
        eq.equipment_id = m.equipment_id
    inner join
        production_reports_kx_hdr_raw prkxh
    on
        prkxh.equipment_id =  zl.equipment_id
    inner join
        production_reports_kx_raw prkx
    on
        prkx.report_id = prkxh.report_id
    where
        r.valid_flag = 'T'
    and
        z.module_id <> -1
    and
        prkxh.end_time > 1422540000
    and
        prkxh.end_time <= 1422626400
)
select 
    curr.route_id,
    curr.equipment_id,
    curr.report_id,
    curr.lane_no,
    curr.stage_no,
    curr.setup_id,
    curr.end_time,
    curr.row as curr_row,
    prev.row as prev_row,
    -- curr.real_run_time, 
    -- curr.total_down_time,
    -- curr.prev_proc_wait_time,
    -- curr.next_proc_wait_time,
    -- curr.singl_cycl_stop_time,
    -- curr.chip_supp_wait_time,
    -- curr.sldr_ctr_wait_time,
    -- curr.sldr_snsr_wait_time,
    -- curr.cln_paper_wait_time,
    -- prev.route_id,
    -- prev.equipment_id,
    -- prev.report_id,
    -- prev.lane_no,
    -- prev.stage_no,
    -- prev.real_run_time, 
    -- prev.total_down_time,
    -- prev.prev_proc_wait_time,
    -- prev.next_proc_wait_time,
    -- prev.singl_cycl_stop_time,
    -- prev.chip_supp_wait_time,
    -- prev.sldr_ctr_wait_time,
    -- prev.sldr_snsr_wait_time,
    -- prev.cln_paper_wait_time,
    curr.real_run_time - prev.real_run_time 
        as delta_real_run_time,
    curr.total_down_time - prev.total_down_time 
        as delta_total_down_time
    -- curr.prev_proc_wait_time - prev.prev_proc_wait_time 
        -- as delta_prev_proc_wait_time,
    -- curr.next_proc_wait_time - prev.next_proc_wait_time 
        -- as delta_next_proc_wait_time,
    -- curr.singl_cycl_stop_time - prev.singl_cycl_stop_time 
        -- as delta_singl_cycl_stop_time,
    -- curr.chip_supp_wait_time - prev.chip_supp_wait_time 
        -- as delta_chip_supp_wait_time,
    -- curr.sldr_ctr_wait_time - prev.sldr_ctr_wait_time 
        -- as delta_sldr_ctr_wait_time,
    -- curr.sldr_snsr_wait_time - prev.sldr_snsr_wait_time 
        -- as delta_sldr_snsr_wait_time,
    -- curr.cln_paper_wait_time - prev.cln_paper_wait_time 
        -- as delta_cln_paper_wait_time
from
    prod_kx_cte curr
left outer join
    prod_kx_cte prev
on
    curr.row = prev.row + 1
where
    curr.route_id = prev.route_id
and
    curr.equipment_id = prev.equipment_id
and
    curr.lane_no = prev.lane_no
and
    curr.stage_no = prev.stage_no
and
    curr.setup_id = prev.setup_id
order by
    curr.route_id asc,
    curr.equipment_id asc,
    curr.lane_no asc,
    curr.stage_no asc
go

