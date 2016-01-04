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

select
    r.route_id,
    r.route_name,
    r.host_name,
    -- r.dos_line_no,
    -- r.flow_direction,
    r.valid_flag
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
from
    routes r
order by
    route_id asc
go

name	name	user_type_id	name	precision	
ROUTE_LAYOUT	ROUTE_ID	108	numeric	38	
ROUTE_LAYOUT	POS	108	numeric	38	
ROUTE_LAYOUT	ZONE_ID	108	numeric	38	
ROUTE_LAYOUT	DOS_CELL_NO	108	numeric	38	
ROUTE_LAYOUT	PRO_MODULE_NO	108	numeric	38	
