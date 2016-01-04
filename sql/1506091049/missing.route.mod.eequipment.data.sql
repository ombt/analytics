
-- odd> spain.date.2.ts.sh "04/18/2015 00:00:00" "06/03/2015 23:59:59"
-- 1429308000
-- 1433368799

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
    pbm.module_id,
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

name	name	user_type_id	name	precision	
ROUTES	ROUTE_ID	108	numeric	38	
ROUTES	ROUTE_NAME	231	nvarchar	0	
ROUTES	HOST_NAME	231	nvarchar	0	
ROUTES	DOS_LINE_NO	108	numeric	38	
ROUTES	FLOW_DIRECTION	231	nvarchar	0	
ROUTES	VALID_FLAG	231	nvarchar	0	
ROUTES	SUBIMPORT_PATH	231	nvarchar	0	
ROUTES	STAND_ALONE	231	nvarchar	0	
ROUTES	ROUTE_STARTUP	231	nvarchar	0	
ROUTES	LNB_HOST_NAME	231	nvarchar	0	
ROUTES	ROUTE_ABBR	231	nvarchar	0	
ROUTES	DGS_LINE_ID	108	numeric	38	
ROUTES	DGS_IMPORT_MODE	231	nvarchar	0	
ROUTES	MGMT_UPLOAD_TYPE	108	numeric	38	
ROUTES	NAVI_IMPORT_MODE	231	nvarchar	0	
ROUTES	SUB_PART_IMPORT_SRC	108	numeric	38	
ROUTES	RESTRICTED_COMPONENTS_ENABLED	231	nvarchar	0	
ROUTES	SEPARATE_NETWORK_IP	231	nvarchar	0	
ROUTES	SEPARATE_NETWORK_ENABLED	231	nvarchar	0	
ROUTES	PUBLISH_MODE	56	int	10	
ROUTES	PUBLISH_ROUTE_ID	56	int	10	
ROUTES	LINKED_TO_PUBLISH	231	nvarchar	0	
ROUTES	DISABLE_TRAY_PART_SCAN	231	nvarchar	0	
ROUTES	ENABLE_TRAY_INTERLOCK	231	nvarchar	0	
ROUTES	BMX_ZONE_ID	56	int	10	
ROUTES	BMX_STORAGE_UNIT_ID	56	int	10	
ROUTES	BMX_DEDICATION_TYPE	56	int	10	
ROUTES	PT200_LINE_ID	56	int	10	
ROUTES	ALLOW_DELETE	231	nvarchar	0	
ROUTES	DGS_SERVER_ID	56	int	10	
ROUTES	ERP_ROUTE_ID	231	nvarchar	0	
name	name	user_type_id	name	precision	
ZONES	ZONE_ID	108	numeric	38	
ZONES	ZONE_NAME	231	nvarchar	0	
ZONES	HOST_NAME	231	nvarchar	0	
ZONES	CONTROL_MODE	108	numeric	38	
ZONES	CONTROL_LEVEL	108	numeric	38	
ZONES	TRACE_LEVEL	108	numeric	38	
ZONES	QUEUE_SIZE	108	numeric	38	
ZONES	ZONE_TYPE	108	numeric	38	
ZONES	VALID_FLAG	231	nvarchar	0	
ZONES	ZONE_BARCODE	231	nvarchar	0	
ZONES	MGMT_MODE	108	numeric	38	
ZONES	PRODUCT_MODE	108	numeric	38	
ZONES	PROGRAM_MODE	231	nvarchar	0	
ZONES	ZONE_STARTUP	231	nvarchar	0	
ZONES	PIN_ADJUST_MODE	231	nvarchar	0	
ZONES	MODULE_ID	108	numeric	38	
ZONES	MS_ZONE_ID	108	numeric	38	
ZONES	ACTIVE_STATUS	108	numeric	38	
ZONES	MODULE_TYPE	108	numeric	38	
ZONES	OPERATIONAL_LEVEL	231	nvarchar	0	
ZONES	ALLOW_DELETE	231	nvarchar	0	
ZONES	IS_DEFAULT_MATERIAL_AREA	231	nvarchar	0	
name	name	user_type_id	name	precision	
ROUTE_LAYOUT	ROUTE_ID	108	numeric	38	
ROUTE_LAYOUT	POS	108	numeric	38	
ROUTE_LAYOUT	ZONE_ID	108	numeric	38	
ROUTE_LAYOUT	DOS_CELL_NO	108	numeric	38	
ROUTE_LAYOUT	PRO_MODULE_NO	108	numeric	38	
