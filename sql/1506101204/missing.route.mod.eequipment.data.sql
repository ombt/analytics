
-- odd> spain.date.2.ts.sh "04/18/2015 00:00:00" "06/03/2015 23:59:59"
-- 1429308000
-- 1433368799

-- panel_barcode_map module_id
-- panel_barcode_map panel_id
-- panel_barcode_map panel_id_string
-- panel_barcode_map timestamp
-- panel_barcode_map lane_no
-- panel_barcode_map setup_id

-- tracking_data serial_no
-- tracking_data prod_model_no
-- tracking_data panel_id
-- tracking_data pattern_id
-- tracking_data barcode
-- tracking_data setup_id
-- tracking_data top_bottom
-- tracking_data timestamp
-- tracking_data import_flag

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
-- zones is_default_material_area

-- route_layout route_id
-- route_layout pos
-- route_layout zone_id
-- route_layout dos_cell_no
-- route_layout pro_module_no

-- zone_layout zone_id
-- zone_layout pos 
-- zone_layout equipment_id 

select
    min(timestamp) as actual_pbm_min_time,
    max(timestamp) as actual_pbm_max_time
from 
    panel_barcode_map pbm
where
    1429308000 <= pbm.timestamp
and
    pbm.timestamp <= 1433368799
go

-- actual times are:
-- pbm_min_time    pbm_max_time
-- 1429308025      1433368797

select
    count(*) as pbm_cnt
from 
    panel_barcode_map pbm
where
    1429308000 <= pbm.timestamp
and
    pbm.timestamp <= 1433368799
go

select
    count(*) as pbm_td_cnt
from
    panel_barcode_map pbm
inner join
    tracking_data td
on
    td.panel_id = pbm.panel_id
where
    1429308000 <= pbm.timestamp
and
    pbm.timestamp <= 1433368799
go

select
    count(*) as pmb_td_not_exists_p_count
from
    panel_barcode_map pbm
inner join
    tracking_data td
on
    td.panel_id = pbm.panel_id
where
    1429308000 <= pbm.timestamp
and
    pbm.timestamp <= 1433368799
and
    not exists (select * from panels p where p.panel_id = pbm.panel_id)
go

select
    count(*) as pmb_td_exists_p_count
from
    panel_barcode_map pbm
inner join
    tracking_data td
on
    td.panel_id = pbm.panel_id
where
    1429308000 <= pbm.timestamp
and
    pbm.timestamp <= 1433368799
and
    exists (select * from panels p where p.panel_id = pbm.panel_id)
go

-- select
--     pbm.module_id,
--     pbm.panel_id,
--     pbm.panel_id_string,
--     pbm.timestamp,
--     pbm.lane_no,
--     pbm.setup_id,
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
--     panel_barcode_map pbm
-- join
--     tracking_data td
-- on
--     td.panel_id = pbm.panel_id
-- where
--     1429308000 <= pbm.timestamp
-- and
--     pbm.timestamp <= 1433368799
-- and
--     not exists (select * from panels p where p.panel_id = pbm.panel_id)
-- order by
--     pbm.timestamp asc
-- go
-- 

select distinct 
    pbm.module_id,
    -- pbm.panel_id,
    -- pbm.panel_id_string,
    -- pbm.timestamp,
    pbm.lane_no,
    pbm.setup_id
    -- td.serial_no,
    -- td.prod_model_no,
    -- td.panel_id,
    -- td.pattern_id,
    -- td.barcode,
    -- td.setup_id,
    -- td.top_bottom,
    -- td.timestamp,
    -- td.import_flag
from
    panel_barcode_map pbm
inner join
    tracking_data td
on
    td.panel_id = pbm.panel_id
where
    1429308000 <= pbm.timestamp
and
    pbm.timestamp <= 1433368799
and
    not exists (select * from panels p where p.panel_id = pbm.panel_id)
order by
    pbm.module_id asc,
    pbm.lane_no asc,
    pbm.setup_id asc
go

select distinct 
    pbm.module_id,
    -- pbm.panel_id,
    -- pbm.panel_id_string,
    -- pbm.timestamp,
    pbm.lane_no,
    pbm.setup_id
from
    panel_barcode_map pbm
where
    1429308000 <= pbm.timestamp
and
    pbm.timestamp <= 1433368799
and
    not exists (select * from panels p where p.panel_id = pbm.panel_id)
order by
    pbm.module_id asc,
    pbm.lane_no asc,
    pbm.setup_id asc
go

select distinct 
    rl.route_id,
    pbm.setup_id,
    -- rl.zone_id,
    -- rl.dos_cell_no,
    -- rl.pro_module_no,
    -- pbm.module_id,
    pbm.lane_no,
    -- rl.pos,
    z.zone_id,
    -- z.zone_name,
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
    -- z.module_id,
    -- z.ms_zone_id,
    -- z.active_status,
    -- z.module_type,
    -- z.operational_level,
    -- z.allow_delete,
    -- z.is_default_material_area
    -- zl.zone_id
    -- zl.pos,
    zl.equipment_id 
from
    panel_barcode_map pbm
inner join
    zones z
on
    z.module_id = pbm.module_id
inner join
    route_layout rl
on
    rl.zone_id = z.zone_id
inner join
    zone_layout zl
on
    zl.zone_id = z.zone_id
where
    1429308000 <= pbm.timestamp
and
    pbm.timestamp <= 1433368799
and
    not exists (select * from panels p where p.panel_id = pbm.panel_id)
order by
    rl.route_id asc,
    pbm.setup_id asc,
    -- pbm.module_id asc,
    pbm.lane_no asc,
    zl.equipment_id asc
    -- zl.pos asc
    -- rl.pos asc
go

select distinct 
    -- rl.route_id,
    -- pbm.setup_id,
    -- rl.zone_id,
    -- rl.dos_cell_no,
    -- rl.pro_module_no,
    -- pbm.module_id,
    -- pbm.lane_no,
    -- rl.pos,
    -- z.zone_id,
    -- z.zone_name,
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
    -- z.module_id,
    -- z.ms_zone_id,
    -- z.active_status,
    -- z.module_type,
    -- z.operational_level,
    -- z.allow_delete,
    -- z.is_default_material_area
    -- zl.zone_id
    -- zl.pos,
    zl.equipment_id 
from
    panel_barcode_map pbm
inner join
    zones z
on
    z.module_id = pbm.module_id
inner join
    route_layout rl
on
    rl.zone_id = z.zone_id
inner join
    zone_layout zl
on
    zl.zone_id = z.zone_id
where
    1429308000 <= pbm.timestamp
and
    pbm.timestamp <= 1433368799
and
    not exists (select * from panels p where p.panel_id = pbm.panel_id)
order by
    -- rl.route_id asc,
    -- pbm.setup_id asc,
    -- pbm.module_id asc,
    -- pbm.lane_no asc,
    zl.equipment_id asc
    -- zl.pos asc
    -- rl.pos asc
go

