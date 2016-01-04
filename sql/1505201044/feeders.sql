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

select
    r.route_id,
    r.route_name,
    r.host_name,
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
    -- rl. route_id,
    rl.pos as rl_pos,
    rl.zone_id rl_zid,
    -- rl. dos_cell_no,
    -- rl. pro_module_no
    -- z.zone_id,
    z.zone_name,
    -- z.host_name,
    -- z.control_mode,
    -- z.control_level,
    -- z.trace_level,
    -- z.queue_size,
    -- z.zone_type,
    -- z.valid_flag,
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
    -- z.allow_delete
    -- zl.zone_id,
    zl.pos as zl_pos,
    -- zl.equipment_id 
    m.equipment_id,
    -- m.model_number
    -- m.mgmt_report
    m.double_feeder_mode,
    -- m.cmd_flags
    -- m.data_flags
    -- m.mgmt_flags
    -- m.file_flags
    -- m.dir_flags
    -- m.num_files
    -- m.del_flags
    -- m.ipc
    -- m.setup_file_flags
    -- m.valid_flag
    -- m.spc
    m.single_lane_mode,
    -- m.machine_vendor
    -- m.file_order
    -- m.data_order
    m.num_stages
    -- m.simulation_mode
    -- m.cph_in_thousands
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
where
    r.valid_flag = 'T'
and
    z.module_id <> -1
order by
    r.route_id asc,
    rl.pos asc,
    zl.pos asc
go

