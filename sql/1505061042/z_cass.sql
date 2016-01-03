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
-- z_cass_header_raw mgmt_report_id
-- z_cass_header_raw report_id
-- z_cass_header_raw product_id
-- z_cass_header_raw equipment_id
-- z_cass_header_raw lane_no
-- z_cass_header_raw start_time
-- z_cass_header_raw end_time
-- z_cass_header_raw setup_id
-- z_cass_header_raw nc_version
-- z_cass_header_raw job_id
-- z_cass_header_raw report_file
--

select
    -- zhr.mgmt_report_id,
    zhr.report_id,
    zhr.product_id,
    zhr.equipment_id,
    zhr.lane_no,
    zhr.start_time,
    zhr.end_time,
    zhr.setup_id,
    zhr.nc_version,
    -- zhr.job_id,
    zhr.report_file
from
    z_cass_header_raw zhr
order by
    zhr.equipment_id asc,
    zhr.lane_no asc,
    zhr.report_id
go

select
    -- zhr.mgmt_report_id,
    zhr.report_id,
    zhr.product_id,
    zhr.equipment_id,
    zhr.lane_no,
    zhr.start_time,
    zhr.end_time,
    zhr.setup_id,
    zhr.nc_version,
    -- zhr.job_id,
    zhr.report_file,
    -- zh.mgmt_report_id,
    zh.report_id,
    zh.product_id,
    zh.equipment_id,
    zh.lane_no,
    zh.start_time,
    zh.end_time,
    zh.setup_id,
    zh.nc_version
    -- zh.job_id
from
    z_cass_header_raw zhr
-- left join
inner join
    z_cass_header zh
on
    zhr.report_id = zh.report_id
and
    zhr.equipment_id = zh.equipment_id
and
    zhr.lane_no = zh.lane_no
order by
    zhr.equipment_id asc,
    zhr.lane_no asc,
    zhr.report_id
go

select
    -- zhr.mgmt_report_id,
    -- zhr.product_id,
    zhr.equipment_id,
    zhr.lane_no,
    -- count(zhr.report_id)
    -- zhr.start_time,
    -- zhr.end_time,
    -- zhr.setup_id,
    -- zhr.nc_version,
    -- zhr.job_id,
    -- zhr.report_file,
    -- zh.mgmt_report_id,
    count(zh.report_id)
    -- zh.product_id,
    -- zh.equipment_id,
    -- zh.lane_no,
    -- zh.start_time,
    -- zh.end_time,
    -- zh.setup_id,
    -- zh.nc_version
    -- zh.job_id
from
    z_cass_header_raw zhr
-- left join
inner join
    z_cass_header zh
on
    zhr.report_id = zh.report_id
and
    zhr.equipment_id = zh.equipment_id
and
    zhr.lane_no = zh.lane_no
group by
    zhr.equipment_id,
    zhr.lane_no
go
