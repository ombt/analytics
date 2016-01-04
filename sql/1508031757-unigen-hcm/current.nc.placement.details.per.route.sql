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
-- 
-- product_run_history product_run_history_id
-- product_run_history equipment_id
-- product_run_history lane_no
-- product_run_history setup_id
-- product_run_history start_time
-- product_run_history end_time
--
-- nc_detail nc_version
-- nc_detail cassette
-- nc_detail slot
-- nc_detail subslot
-- nc_detail tva
-- 
-- nc_placement_detail nc_placement_id
-- nc_placement_detail idnum
-- nc_placement_detail ref_designator
-- nc_placement_detail part_name
-- nc_placement_detail pattern_number
-- nc_placement_detail nc_version
-- 
-- nc_summary setup_id
-- nc_summary equipment_id
-- nc_summary nc_version
-- nc_summary tva
-- nc_summary double_feeder_flag
-- nc_summary glue_total
-- nc_summary solder_total
-- name name
-- system_config attribute_name
-- system_config attribute_value
-- name name
-- product_setup product_id
-- product_setup route_id
-- product_setup mix_name
-- product_setup setup_id
-- product_setup ldf_file_name
-- product_setup machine_file_name
-- product_setup setup_valid_flag
-- product_setup last_modified_time
-- product_setup dos_file_name
-- product_setup model_string
-- product_setup top_bottom
-- product_setup pt_group_name
-- product_setup pt_lot_name
-- product_setup pt_mc_file_name
-- product_setup pt_downloaded_flag
-- product_setup pt_needs_download
-- product_setup sub_parts_flag
-- product_setup barcode_side
-- product_setup cycle_time
-- product_setup import_source
-- product_setup modified_import_source
-- product_setup theoretical_xover_time
-- product_setup publish_mode
-- product_setup master_mjs_id
-- product_setup pcb_name
-- name name
-- product_data product_id
-- product_data product_name
-- product_data dos_product_name
-- product_data patterns_per_panel
-- product_data panel_width
-- product_data panel_length
-- product_data panel_thickness
-- product_data camera_xaxis_top
-- product_data camera_yaxis_top
-- product_data camera_xaxis_bottom
-- product_data camera_yaxis_bottom
-- product_data tooling_pin_distance
-- product_data barcodes_per_panel
-- product_data product_valid_flag
-- product_data tooling_pin
-- product_data conveyor_speed
-- product_data use_brd_file
-- product_data base_product_id
--
-- equipment equipment_id 
-- equipment equipment_name 
-- equipment equipment_type 
-- equipment icon_filename 
-- equipment valid_flag 
-- equipment equipment_abbr 
-- equipment pmd_priority_group_id 
-- 

select 
    r.route_name as 'r.route_name',
    -- r.route_id as 'r.route_id',
    -- rl.pos as 'rl.pos',
    -- rl.zone_id as 'rl.zone_id',
    -- z.zone_name as 'z.zone_name',
    -- z.trace_level as 'z.trace_level',
    -- z.module_id as 'z.module_id',
    -- zl.pos as 'zl.pos',
    -- zl.equipment_id as 'zl.equipment_id',
    eq.equipment_name as 'eq.equipment_name',
    -- prh. product_run_history_id
    -- prh. equipment_id
    prh.lane_no as 'prh.lane_no',
    prh.setup_id as 'prh.setup_id',
    -- prh.start_time
    -- prh.end_time
    -- ncs.setup_id
    -- ncs.equipment_id
    ncs.nc_version as 'ncs.nc_version',
    -- ncs.tva
    -- ncs.double_feeder_flag
    -- ncs.glue_total
    -- ncs.solder_total
    count(ncpd.nc_placement_id) as 'count_ncpd.nc_placement_id'
    -- nc_placement_detail nc_placement_id
    -- nc_placement_detail idnum
    -- nc_placement_detail ref_designator
    -- nc_placement_detail part_name
    -- nc_placement_detail pattern_number
    -- nc_placement_detail nc_version
from
    routes r
inner join
    route_layout rl
on
    rl.route_id = r.route_id
and
    r.valid_flag = 't'
inner join
    zones z
on
    z.zone_id = rl.zone_id
and
    z.valid_flag = 't'
and
    z.module_id > 0
inner join
    zone_layout zl
on
    zl.zone_id = rl.zone_id
inner join
    equipment eq
on
    eq.equipment_id = zl.equipment_id
inner join
    product_run_history prh
on
    prh.equipment_id = zl.equipment_id
and
    prh.end_time > 2000000000
inner join
    nc_summary ncs
on
    ncs.setup_id = prh.setup_id
and
    ncs.equipment_id = prh.equipment_id
left join
    nc_placement_detail ncpd
on
    ncpd.nc_version = ncs.nc_version
group by
    r.route_id,
    rl.pos,
    prh.start_time,
    ncs.nc_version,
    r.route_name,
    eq.equipment_name,
    prh.lane_no,
    prh.setup_id,
    ncs.nc_version
order by
    r.route_id asc,
    rl.pos asc,
    prh.start_time asc,
    ncs.nc_version asc
go

