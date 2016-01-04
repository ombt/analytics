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
-- routes allow_delete
-- routes bmx_zone_id
-- routes bmx_storage_unit_id
-- routes bmx_dedication_type
-- routes pt200_line_id
-- routes dgs_server_id
-- routes erp_route_id

-- route_layout route_id 
-- route_layout pos
-- route_layout zone_id
-- route_layout dos_cell_no
-- route_layout pro_module_no

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
-- zones allow_delete
-- zones pin_adjust_mode
-- zones module_id
-- zones ms_zone_id
-- zones active_status
-- zones module_type
-- zones operational_level
-- zones is_default_material_area

-- zone_layout zone_id 
-- zone_layout pos 
-- zone_layout equipment_id 

select
    r.route_id,
    -- r.route_name,
    -- r.host_name
    -- r.dos_line_no
    -- r.flow_direction
    -- r.valid_flag
    -- r.subimport_path
    -- r.stand_alone
    -- r.route_startup
    -- r.lnb_host_name,
    -- r.route_abbr
    -- r.dgs_line_id
    -- r.dgs_import_mode
    -- r.mgmt_upload_type
    -- r.sub_part_import_src
    -- r.navi_import_mode
    -- r.restricted_components_enabled
    -- r.separate_network_ip
    -- r.separate_network_enabled
    -- r.publish_mode
    -- r.linked_to_publish
    -- r.publish_route_id
    -- r.disable_tray_part_scan
    -- r.enable_tray_interlock
    -- r.allow_delete
    -- r.bmx_zone_id
    -- r.bmx_storage_unit_id
    -- r.bmx_dedication_type
    -- r.pt200_line_id
    -- r.dgs_server_id
    -- r.erp_route_id
    -- route_layout route_id 
    rl.pos,
    rl.zone_id,
    -- route_layout dos_cell_no
    -- route_layout pro_module_no
    -- zones zone_id
    -- z.zone_name,
    -- zones host_name
    -- zones control_mode
    -- zones control_level
    z.trace_level,
    -- zones queue_size
    -- z.zone_type,
    -- zones valid_flag
    -- zones zone_barcode
    -- zones mgmt_mode
    -- zones product_mode
    -- zones program_mode
    -- zones zone_startup
    -- zones allow_delete
    -- zones pin_adjust_mode
    z.module_id,
    -- zones ms_zone_id
    -- zones active_status
    -- z.module_type,
    -- zones operational_level
    -- zones is_default_material_area
    -- zl.zone_id,
    zl.pos,
    zl.equipment_id
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
left join
    zone_layout zl
on
    zl.zone_id = rl.zone_id
where
    r.valid_flag = 'T'
and
    len(r.lnb_host_name) > 0
and
    z.valid_flag = 'T'
order by
    r.route_id asc,
    rl.pos asc
go

