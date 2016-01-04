-- 
-- z_cass_header mgmt_report_id
-- z_cass_header report_id
-- z_cass_header product_id
-- z_cass_header equipment_id
-- z_cass_header lane_no
-- z_cass_header start_time
-- z_cass_header end_time
-- z_cass_header setup_id
-- z_cass_header nc_version
-- z_cass_header job_id
-- z_cass_header report_file
-- 
select 
    zh.mgmt_report_id,
    zh.report_id,
    zh.product_id,
    zh.equipment_id,
    zh.lane_no,
    zh.start_time,
    zh.end_time,
    zh.setup_id,
    zh.nc_version,
    zh.job_id,
    zh.report_file
from
    z_cass_header zh
-- where
    -- zh.end_time >= 1428502042
-- and
    -- zh.end_time <= 1428516667
order by
    -- zh.report_id asc
    zh.end_time asc
go
