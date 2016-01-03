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
-- routes navi_import_mode
-- routes sub_part_import_src
-- routes restricted_components_enabled
-- routes separate_network_ip
-- routes separate_network_enabled
-- routes publish_mode
-- routes publish_route_id
-- routes linked_to_publish
-- routes disable_tray_part_scan
-- routes enable_tray_interlock
-- routes bmx_zone_id
-- routes bmx_storage_unit_id
-- routes bmx_dedication_type
-- routes pt200_line_id
-- routes allow_delete
-- routes dgs_server_id
-- routes erp_route_id

-- panel_placement_header panel_equipment_id
-- panel_placement_header equipment_id
-- panel_placement_header master_placement_id
-- panel_placement_header panel_placement_id
-- panel_placement_header timestamp
-- panel_placement_header trx_product_id
-- 
-- panel_placement_details panel_placement_id
-- panel_placement_details reel_id
-- panel_placement_details nc_placement_id
-- panel_placement_details pattern_no
-- panel_placement_details z_num
-- panel_placement_details pu_num
-- panel_placement_details part_no
-- panel_placement_details custom_area1
-- panel_placement_details custom_area2
-- panel_placement_details custom_area3
-- panel_placement_details custom_area4
-- panel_placement_details ref_designator

select
    r.route_id,
    r.route_name,
    r.host_name
from 
    routes r
where
    r.valid_flag = 'T'
go

select
    count(*) as 'pph_count'
from
    panel_placement_header
go

select
    count(*) as 'ppd_count'
from
    panel_placement_details
go


