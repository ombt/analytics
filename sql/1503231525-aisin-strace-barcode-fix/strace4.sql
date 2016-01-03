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
    r.route_id,
    -- r.route_name,
    rl.pos,
    rl.zone_id,
    -- z.zone_name,
    -- z.trace_level,
    z.module_id,
    -- zl.pos,
    zl.equipment_id,
    -- sh.equipment_id,
    -- sh.panel_equipment_id,
    sh.trx_product_id,
    -- sh.master_strace_id,
    -- sh.panel_strace_id,
    -- sh.timestamp,
    p.panel_id,
    -- p.equipment_id,
    -- p.nc_version,
    -- p.start_time,
    -- p.end_time,
    -- p.panel_equipment_id,
    -- p.panel_source,
    -- p.panel_trace,
    -- p.stage_no,
    -- p.lane_no,
    -- p.job_id,
    -- p.setup_id,
    -- p.trx_product_id,
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
left join
    panel_strace_header sh
on
    sh.equipment_id = zl.equipment_id
left join
    panels p
on
    p.panel_equipment_id = sh.panel_equipment_id
left join
    tracking_data td
on
    td.panel_id = p.panel_id
where
    r.valid_flag = 'T'
and
    len(r.lnb_host_name) > 0
and
    z.valid_flag = 'T'
and
    z.module_id > 0
order by
    r.route_id asc,
    rl.pos asc,
    sh.equipment_id asc,
    td.serial_no asc,
    sh.panel_equipment_id asc
go
