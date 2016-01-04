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
-- pt_module_layout pt200_id
-- pt_module_layout module_id
-- pt_module_layout overwrite_parts_library
-- pt_module_layout force_program_download
-- 
-- pt_config pt200_id
-- pt_config pt200_name
-- pt_config pt200_user
-- pt_config pt200_passwd
-- pt_config enabled_flag
-- 
-- select
--     z.zone_id,
--     z.zone_name,
--     z.host_name,
--     z.control_mode,
--     z.control_level,
--     z.trace_level,
--     z.queue_size,
--     z.zone_type,
--     z.valid_flag,
--     z.zone_barcode,
--     z.mgmt_mode,
--     z.product_mode,
--     z.program_mode,
--     z.zone_startup,
--     z.pin_adjust_mode,
--     z.module_id,
--     z.ms_zone_id,
--     z.active_status,
--     z.module_type,
--     z.operational_level,
--     z.allow_delete
-- from
--     zones z
-- go
-- 
-- select
--     z.zone_id,
--     z.zone_name,
--     z.host_name,
--     -- z.control_mode,
--     -- z.control_level,
--     -- z.trace_level,
--     -- z.queue_size,
--     z.zone_type,
--     z.valid_flag,
--     -- z.zone_barcode,
--     -- z.mgmt_mode,
--     -- z.product_mode,
--     -- z.program_mode,
--     -- z.zone_startup,
--     -- z.pin_adjust_mode,
--     z.module_id,
--     z.ms_zone_id,
--     z.active_status,
--     z.module_type
--     --
--     -- z.module_type,
--     -- z.operational_level,
--     -- z.allow_delete
-- from
--     zones z
-- where
--     z.zone_startup = 't'
-- and
--     z.valid_flag = 't'
-- and
--     z.module_id <> -1
-- go
-- -- 
-- select
--     z.zone_id,
--     z.zone_name,
--     z.host_name,
--     -- z.control_mode,
--     -- z.control_level,
--     -- z.trace_level,
--     -- z.queue_size,
--     -- z.zone_type,
--     z.valid_flag,
--     -- z.zone_barcode,
--     -- z.mgmt_mode,
--     -- z.product_mode,
--     -- z.program_mode,
--     -- z.zone_startup,
--     -- z.pin_adjust_mode,
--     -- z.module_id,
--     -- z.ms_zone_id,
--     z.active_status,
--     z.module_type
--     --
--     -- z.module_type,
--     -- z.operational_level,
--     -- z.allow_delete
-- from
--     zones z
-- where
--     z.zone_startup = 't'
-- and
--     z.valid_flag = 't'
-- and
--     z.module_id <> -1
-- go



select
    r.route_id,
    -- r.route_name,
    -- rl.zone_id,
    z.zone_name,
    ptc.pt200_name
from
    routes r
inner join
    route_layout rl
on
    rl.route_id = r.route_id
inner join
    zones z
on
    rl.zone_id = z.zone_id
inner join
    pt_module_layout ptml
on
    ptml.module_id = z.module_id
inner join
    pt_config ptc
on
    ptc.pt200_id = ptml.pt200_id
where
    r.valid_flag = 'T'
and
    r.route_startup = 'T'
and
    z.zone_startup = 't'
and
    z.valid_flag = 't'
and
    z.module_id <> -1
go

-- pt_module_layout pt200_id
-- pt_module_layout module_id
-- pt_config pt200_id
-- pt_config pt200_name
