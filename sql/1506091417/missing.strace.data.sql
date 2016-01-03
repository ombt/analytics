
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
    count(*) as td_count
from 
    tracking_data
go

select
    count(*) as pbm_count
from 
    panel_barcode_map
go

select
    count(*) as pbm_count
from 
    panel_barcode_map pbm
where
    1429308000 <= pbm.timestamp
and
    pbm.timestamp <= 1433368799
go

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

select
    count(*) as pbm_eq_td_count
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

-- actual times are:
-- pbm_min_time    pbm_max_time
-- 1429308025      1433368797


select
    count(*) as pbm_td_count
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

select
    pbm.module_id,
    pbm.panel_id,
    pbm.panel_id_string,
    pbm.timestamp,
    pbm.lane_no,
    pbm.setup_id,
    td.serial_no,
    td.prod_model_no,
    td.panel_id,
    td.pattern_id,
    td.barcode,
    td.setup_id,
    td.top_bottom,
    td.timestamp,
    td.import_flag
from
    panel_barcode_map pbm
join
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
    pbm.timestamp asc
go

