-- tracking_data	serial_no
-- tracking_data	prod_model_no
-- tracking_data	panel_id
-- tracking_data	pattern_id
-- tracking_data	barcode
-- tracking_data	setup_id
-- tracking_data	top_bottom
-- tracking_data	timestamp
-- tracking_data	import_flag

-- panels	panel_id
-- panels	equipment_id
-- panels	nc_version
-- panels	start_time
-- panels	end_time
-- panels	panel_equipment_id
-- panels	panel_source
-- panels	panel_trace
-- panels	stage_no
-- panels	lane_no
-- panels	job_id
-- panels	setup_id
-- panels	trx_product_id

select
    td.serial_no,
    td.prod_model_no,
    td.panel_id,
    td.pattern_id,
    td.barcode,
    td.setup_id,
    td.top_bottom,
    td.timestamp,
    td.import_flag,
    p.panel_id,
    p.equipment_id,
    p.nc_version,
    p.start_time,
    p.end_time,
    p.panel_equipment_id,
    p.panel_source,
    p.panel_trace,
    p.stage_no,
    p.lane_no,
    p.job_id,
    p.setup_id,
    p.trx_product_id
from
    tracking_data td
inner join 
    panels p
on
    td.panel_id = p.panel_id
where
    td.serial_no = 'S0244800001'
order by
    td.panel_id asc
go

select
    td.serial_no,
    td.panel_id,
    td.pattern_id,
    td.barcode
from
    tracking_data td
where
    td.serial_no = 'S0244800001'
order by
    td.panel_id asc
go

select
    p.panel_id,
    p.equipment_id,
    p.nc_version,
    p.start_time,
    p.end_time,
    p.panel_equipment_id,
    p.panel_source,
    p.panel_trace,
    p.stage_no,
    p.lane_no,
    p.job_id,
    p.setup_id,
    p.trx_product_id
from
    panels p
where
    p.panel_id in ( 1211, 1212 )
go

select
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
    tracking_data td
where
    td.serial_no = 'S0244800001'
order by
    td.panel_id asc
go

