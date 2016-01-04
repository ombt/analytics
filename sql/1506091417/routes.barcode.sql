-- name name
-- panel_barcode_map module_id
-- panel_barcode_map panel_id
-- panel_barcode_map panel_id_string
-- panel_barcode_map timestamp
-- panel_barcode_map lane_no
-- panel_barcode_map setup_id

-- name name
-- tracking_data serial_no
-- tracking_data prod_model_no
-- tracking_data panel_id
-- tracking_data pattern_id
-- tracking_data barcode
-- tracking_data setup_id
-- tracking_data top_bottom
-- tracking_data timestamp
-- tracking_data import_flag

-- name name
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

-- name name
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

-- name name
-- route_layout route_id
-- route_layout pos
-- route_layout zone_id
-- route_layout dos_cell_no
-- route_layout pro_module_no

-- name name
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

-- name name 
-- zone_layout zone_id 
-- zone_layout pos 
-- zone_layout equipment_id 

-- name name
-- equipment equipment_id
-- equipment equipment_name
-- equipment equipment_type
-- equipment icon_filename
-- equipment valid_flag
-- equipment equipment_abbr
-- equipment pmd_priority_group_id

-- name name
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

-- name name
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

-- name name
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

-- select
--     r.route_id,
--     r.route_name,
--     -- r.host_name,
--     -- r.dos_line_no,
--     -- r.flow_direction,
--     -- r.valid_flag,
--     -- r.subimport_path,
--     -- r.stand_alone,
--     -- r.route_startup,
--     -- r.lnb_host_name,
--     -- r.route_abbr,
--     -- r.dgs_line_id,
--     -- r.dgs_import_mode,
--     -- r.mgmt_upload_type,
--     -- r.sub_part_import_src,
--     -- r.navi_import_mode,
--     -- r.restricted_components_enabled,
--     -- r.separate_network_ip,
--     -- r.separate_network_enabled,
--     -- r.publish_mode,
--     -- r.linked_to_publish,
--     -- r.publish_route_id,
--     -- r.disable_tray_part_scan,
--     -- r.enable_tray_interlock,
--     -- r.bmx_zone_id,
--     -- r.bmx_storage_unit_id,
--     -- r.bmx_dedication_type,
--     -- r.pt200_line_id,
--     -- r.allow_delete
--     -- rl. route_id,
--     -- rl.pos as rl_pos,
--     -- rl.zone_id,
--     -- rl. dos_cell_no,
--     -- rl. pro_module_no
--     z.zone_id,
--     z.zone_name,
--     -- z.host_name,
--     -- z.control_mode,
--     -- z.control_level,
--     -- z.trace_level,
--     -- z.queue_size,
--     -- z.zone_type,
--     -- z.valid_flag,
--     -- z.zone_barcode,
--     -- z.mgmt_mode,
--     -- z.product_mode,
--     -- z.program_mode,
--     -- z.zone_startup,
--     -- z.pin_adjust_mode,
--     -- z.module_id,
--     -- z.ms_zone_id,
--     -- z.active_status,
--     -- z.module_type,
--     -- z.operational_level,
--     -- z.allow_delete
--     -- zl.zone_id,
--     -- zl.pos as zl_pos,
--     -- zl.equipment_id 
--     m.equipment_id,
--     eq.equipment_name,
--     -- m.model_number
--     -- m.mgmt_report
--     m.double_feeder_mode,
--     -- m.cmd_flags
--     -- m.data_flags
--     -- m.mgmt_flags
--     -- m.file_flags
--     -- m.dir_flags
--     -- m.num_files
--     -- m.del_flags
--     -- m.ipc
--     -- m.setup_file_flags
--     -- m.valid_flag
--     -- m.spc
--     m.single_lane_mode,
--     -- m.machine_vendor
--     -- m.file_order
--     -- m.data_order
--     m.num_stages,
--     -- m.simulation_mode
--     -- m.cph_in_thousands
--     -- eq.equipment_id
--     -- eq.equipment_type
--     -- eq.icon_filename
--     -- eq.valid_flag
--     -- eq.equipment_abbr
--     -- eq.pmd_priority_group_id
--     -- fh.feeder_history_id
--     -- fh.equipment_id
--     -- fh.carriage_no
--     fh.slot,
--     fh.subslot,
--     fh.time_on,
--     fh.time_off,
--     fh.reel_id,
--     -- fh.operation_type
--     -- fh.feeder_id
--     -- fh.operator_id
--     -- fh.unmount_operator_id
--     -- fh.splice_operator_id
--     -- fh.expected_pn
--     fh.pu_number,
--     -- fh.material_name
--     -- fh.comparison_id
--     -- fh.override_reason
--     -- fh.pac_part_no
--     -- fh.pac_extra_data
--     -- fh.pac_evaluation
--     -- fh.next_reel_id
--     -- rd.reel_id
--     rd.part_no,
--     -- rd.mcid
--     -- rd.vendor_no
--     rd.lot_no,
--     -- rd.quantity
--     -- rd.user_data
--     rd.reel_barcode
--     -- rd.current_quantity
--     -- rd.update_time
--     -- rd.master_reel_id
--     -- rd.create_time
--     -- rd.part_class
--     -- rd.material_name
--     -- rd.prev_reel_id
--     -- rd.next_reel_id
--     -- rd.adjusted_current_quantity
--     -- rd.tray_quantity
--     -- rd.bulk_master_id
--     -- rd.is_msd
-- from
--     routes r
-- inner join
--     route_layout rl
-- on
--     r.route_id = rl.route_id
-- inner join
--     zones z
-- on
--     rl.zone_id = z.zone_id
-- inner join
--     zone_layout zl
-- on
--     z.zone_id = zl.zone_id
-- inner join
--     machines m
-- on
--     zl.equipment_id = m.equipment_id
-- inner join
--     feeder_history fh
-- on
--     fh.equipment_id = m.equipment_id
-- inner join
--     reel_data rd
-- on
--     rd.reel_id = fh.reel_id
-- inner join
--     equipment eq
-- on
--     eq.equipment_id = m.equipment_id
-- where
--     r.valid_flag = 'T'
-- and
--     z.module_id <> -1
-- and
--     rd.part_no like '%50104991-012%'
-- order by
--     r.route_id asc,
--     rl.pos asc,
--     zl.pos asc,
--     fh.slot asc,
--     fh.subslot asc,
--     fh.time_on asc
-- go
-- 

-- select
--     r.route_id,
--     r.route_name,
--     -- r.host_name,
--     -- r.dos_line_no,
--     -- r.flow_direction,
--     -- r.valid_flag,
--     -- r.subimport_path,
--     -- r.stand_alone,
--     -- r.route_startup,
--     -- r.lnb_host_name,
--     -- r.route_abbr,
--     -- r.dgs_line_id,
--     -- r.dgs_import_mode,
--     -- r.mgmt_upload_type,
--     -- r.sub_part_import_src,
--     -- r.navi_import_mode,
--     -- r.restricted_components_enabled,
--     -- r.separate_network_ip,
--     -- r.separate_network_enabled,
--     -- r.publish_mode,
--     -- r.linked_to_publish,
--     -- r.publish_route_id,
--     -- r.disable_tray_part_scan,
--     -- r.enable_tray_interlock,
--     -- r.bmx_zone_id,
--     -- r.bmx_storage_unit_id,
--     -- r.bmx_dedication_type,
--     -- r.pt200_line_id,
--     -- r.allow_delete
--     -- rl. route_id,
--     -- rl.pos as rl_pos,
--     -- rl.zone_id,
--     -- rl. dos_cell_no,
--     -- rl. pro_module_no
--     z.zone_id,
--     z.zone_name,
--     -- z.host_name,
--     -- z.control_mode,
--     -- z.control_level,
--     -- z.trace_level,
--     -- z.queue_size,
--     -- z.zone_type,
--     -- z.valid_flag,
--     -- z.zone_barcode,
--     -- z.mgmt_mode,
--     -- z.product_mode,
--     -- z.program_mode,
--     -- z.zone_startup,
--     -- z.pin_adjust_mode,
--     -- z.module_id,
--     -- z.ms_zone_id,
--     -- z.active_status,
--     -- z.module_type,
--     -- z.operational_level,
--     -- z.allow_delete
--     -- zl.zone_id,
--     -- zl.pos as zl_pos,
--     -- zl.equipment_id 
--     m.equipment_id,
--     eq.equipment_name,
--     -- m.model_number
--     -- m.mgmt_report
--     m.double_feeder_mode,
--     -- m.cmd_flags
--     -- m.data_flags
--     -- m.mgmt_flags
--     -- m.file_flags
--     -- m.dir_flags
--     -- m.num_files
--     -- m.del_flags
--     -- m.ipc
--     -- m.setup_file_flags
--     -- m.valid_flag
--     -- m.spc
--     m.single_lane_mode,
--     -- m.machine_vendor
--     -- m.file_order
--     -- m.data_order
--     m.num_stages
--     -- m.simulation_mode
--     -- m.cph_in_thousands
--     -- eq.equipment_id
--     -- eq.equipment_type
--     -- eq.icon_filename
--     -- eq.valid_flag
--     -- eq.equipment_abbr
--     -- eq.pmd_priority_group_id
-- from
--     routes r
-- inner join
--     route_layout rl
-- on
--     r.route_id = rl.route_id
-- inner join
--     zones z
-- on
--     rl.zone_id = z.zone_id
-- inner join
--     zone_layout zl
-- on
--     z.zone_id = zl.zone_id
-- inner join
--     machines m
-- on
--     zl.equipment_id = m.equipment_id
-- inner join
--     equipment eq
-- on
--     eq.equipment_id = m.equipment_id
-- where
--     r.valid_flag = 'T'
-- and
--     z.module_id <> -1
-- order by
--     r.route_id asc,
--     rl.pos asc,
--     zl.pos asc
-- go

select
    r.route_id,
    r.route_name,
    -- r.host_name,
    -- r.dos_line_no,
    -- r.flow_direction,
    -- r.valid_flag,
    -- r.subimport_path,
    -- r.stand_alone,
    -- r.route_startup,
    -- r.lnb_host_name,
    -- r.route_abbr,
    -- r.dgs_line_id,
    -- r.dgs_import_mode,
    -- r.mgmt_upload_type,
    -- r.sub_part_import_src,
    -- r.navi_import_mode,
    -- r.restricted_components_enabled,
    -- r.separate_network_ip,
    -- r.separate_network_enabled,
    -- r.publish_mode,
    -- r.linked_to_publish,
    -- r.publish_route_id,
    -- r.disable_tray_part_scan,
    -- r.enable_tray_interlock,
    -- r.bmx_zone_id,
    -- r.bmx_storage_unit_id,
    -- r.bmx_dedication_type,
    -- r.pt200_line_id,
    -- r.allow_delete
    -- rl.route_id
    rl.pos,
    rl.zone_id,
    -- rl.dos_cell_no,
    -- rl.pro_module_no,
    -- z.zone_id,
    z.zone_name,
    -- z.host_name,
    -- z.control_mode,
    -- z.control_level,
    -- z.trace_level,
    -- z.queue_size,
    z.zone_type,
    z.valid_flag,
    -- z.zone_barcode,
    -- z.mgmt_mode,
    -- z.product_mode,
    -- z.program_mode,
    -- z.zone_startup,
    -- z.pin_adjust_mode,
    z.module_id,
    -- z.ms_zone_id,
    -- z.active_status,
    -- z.module_type,
    -- z.operational_level,
    -- z.allow_delete,
    -- zl.zone_id,
    zl.pos,
    zl.equipment_id,
    -- e.equipment_id,
    e.equipment_name,
    e.equipment_type,
    -- e.icon_filename,
    -- e.valid_flag,
    -- e.equipment_abbr,
    -- e.pmd_priority_group_id,
    -- m.equipment_id,
    -- m.model_number,
    -- m.mgmt_report,
    -- m.double_feeder_mode,
    -- m.cmd_flags,
    -- m.data_flags,
    -- m.mgmt_flags,
    -- m.file_flags,
    -- m.dir_flags,
    -- m.num_files,
    -- m.del_flags,
    -- m.ipc,
    -- m.setup_file_flags,
    -- m.valid_flag,
    -- m.spc,
    -- m.single_lane_mode,
    -- m.machine_vendor,
    -- m.file_order,
    -- m.data_order,
    -- m.num_stages,
    -- m.simulation_mode,
    -- m.cph_in_thousands
    pbm.module_id,
    pbm.panel_id,
    pbm.panel_id_string,
    pbm.timestamp,
    pbm.lane_no,
    pbm.setup_id
from
    routes r
inner join
    route_layout rl
on
    rl.route_id = r.route_id
inner join
    zones z
on
    z.zone_id = rl.zone_id
inner join
    zone_layout zl
on
    zl.zone_id = rl.zone_id
left join
    equipment e
on
    e.equipment_id = zl.equipment_id 
inner join
    panel_barcode_map pbm
on
    pbm.module_id = z.module_id
where
    r.valid_flag = 'T'
and
    z.module_id <> -1
and
    e.equipment_type = 1
and
    1429308000 <= pbm.timestamp
and
    pbm.timestamp <= 1433368799
and
    pbm.timestamp in
    ( 
        1431105684,
        1431105542,
        1431105578,
        1431105585,
        1431105614,
        1431105649,
        1431105663,
        1431105684,
        1431105720,
        1431105724,
        1431105755,
        1431105784,
        1431105834,
        1431105877,
        1431105898,
        1431105928,
        1431105930,
        1431105933,
        1431105949,
        1431105976,
        1431103202
    )
and
    not exists (select * from panels p where p.panel_id = pbm.panel_id)
order by
    pbm.timestamp asc,
    r.route_id asc,
    rl.pos asc,
    zl.pos asc
go

