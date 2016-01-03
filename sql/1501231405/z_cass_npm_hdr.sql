-- production_reports_npm_hdr report_id
-- production_reports_npm_hdr product_id
-- production_reports_npm_hdr equipment_id
-- production_reports_npm_hdr start_time
-- production_reports_npm_hdr end_time
-- production_reports_npm_hdr setup_id
-- production_reports_npm_hdr nc_version
-- production_reports_npm_hdr lane_no
-- production_reports_npm_hdr job_id
-- production_reports_npm_hdr trx_productid
-- production_reports_npm_hdr stage
-- production_reports_npm_hdr timestamp

select
    prnh.report_id,
    prnh.product_id,
    prnh.equipment_id,
    prnh.start_time,
    prnh.end_time,
    prnh.setup_id,
    prnh.nc_version,
    prnh.lane_no,
    prnh.job_id,
    prnh.trx_productid,
    prnh.stage,
    prnh.timestamp
from
    z_cass_npm_hdr prnh
where
    prnh.start_time >= prnh.end_time
go

select
    count(*) as 'count_equal'
from
    z_cass_npm_hdr prnh
where
    prnh.start_time = prnh.end_time
go

select
    count(*) as 'count_greater'
from
    z_cass_npm_hdr prnh
where
    prnh.start_time > prnh.end_time
go

select
    count(*) as 'count_less'
from
    z_cass_npm_hdr prnh
where
    prnh.start_time < prnh.end_time
go

