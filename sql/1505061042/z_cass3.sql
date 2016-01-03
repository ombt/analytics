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
-- z_cass report_id
-- z_cass cassette
-- z_cass slot
-- z_cass subslot
-- z_cass comp_id
-- z_cass reel_id
-- z_cass feeder_id
-- z_cass stocked
-- z_cass remaining
-- z_cass comp_exhaust
-- z_cass pickup_count
-- z_cass place_count
-- z_cass pickup_error_count
-- z_cass pickup_miss_count
-- z_cass recog_error_count
-- z_cass shape_error_count
-- z_cass height_miss_count
-- z_cass coplanarity
-- z_cass need_for_current_product
-- z_cass other_error_count
-- z_cass colinearity_count
-- z_cass pickup_attempt_count
-- z_cass place_search_attempt_count
-- z_cass place_search_failure_count
-- z_cass vision_failures
-- z_cass initial_part_count
-- z_cass used_parts_count
-- z_cass table_no
-- z_cass table_slot
-- z_cass table_subslot
-- z_cass primary_pn
--

-- select
--     -- zhr.mgmt_report_id,
--     zhr.report_id,
--     zhr.product_id,
--     zhr.equipment_id,
--     zhr.lane_no,
--     zhr.start_time,
--     zhr.end_time,
--     zhr.setup_id,
--     zhr.nc_version,
--     -- zhr.job_id,
--     zhr.report_file
-- from
--     z_cass_header_raw zhr
-- order by
--     zhr.equipment_id asc,
--     zhr.lane_no asc,
--     zhr.report_id
-- go
-- 
-- select
--     -- zhr.mgmt_report_id,
--     zhr.report_id,
--     zhr.product_id,
--     zhr.equipment_id,
--     zhr.lane_no,
--     zhr.start_time,
--     zhr.end_time,
--     zhr.setup_id,
--     zhr.nc_version,
--     -- zhr.job_id,
--     zhr.report_file,
--     -- zh.mgmt_report_id,
--     zh.report_id,
--     zh.product_id,
--     zh.equipment_id,
--     zh.lane_no,
--     zh.start_time,
--     zh.end_time,
--     zh.setup_id,
--     zh.nc_version
--     -- zh.job_id
-- from
--     z_cass_header_raw zhr
-- -- left join
-- inner join
--     z_cass_header zh
-- on
--     zhr.report_id = zh.report_id
-- and
--     zhr.equipment_id = zh.equipment_id
-- and
--     zhr.lane_no = zh.lane_no
-- order by
--     zhr.equipment_id asc,
--     zhr.lane_no asc,
--     zhr.report_id
-- go

select
    -- zhr.mgmt_report_id,
    -- zhr.product_id,
    zhr.equipment_id as zhr_eqid,
    zhr.lane_no as zhr_lnno,
    zhr.report_id as zhr_rptid,
    zhr.start_time as zhr_st,
    zhr.end_time as zhr_et,
    zh.start_time as zh_st,
    zh.end_time as zh_et,
    -- zhr.setup_id,
    -- zhr.nc_version,
    -- zhr.job_id,
    zhr.report_file as zhr_file,
    -- zh.mgmt_report_id,
    -- zh.report_id,
    -- zh.product_id,
    -- zh.equipment_id,
    -- zh.lane_no,
    -- zh.start_time,
    -- zh.end_time,
    -- zh.setup_id,
    -- zh.nc_version
    -- zh.job_id
    z.report_id,
    z.cassette,
    z.slot,
    z.subslot,
    z.comp_id,
    z.reel_id,
    z.feeder_id,
    z.stocked,
    z.remaining,
    z.comp_exhaust,
    z.pickup_count,
    z.place_count,
    z.pickup_error_count,
    z.pickup_miss_count,
    z.recog_error_count,
    z.shape_error_count,
    z.height_miss_count,
    -- z.coplanarity,
    -- z.need_for_current_product,
    -- z.other_error_count,
    -- z.colinearity_count,
    -- z.pickup_attempt_count,
    -- z.place_search_attempt_count,
    -- z.place_search_failure_count,
    -- z.vision_failures,
    -- z.initial_part_count,
    -- z.used_parts_count,
    z.table_no,
    z.table_slot,
    z.table_subslot,
    z.primary_pn
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
-- left join
inner join
    z_cass z
on
    z.report_id = zh.report_id
order by
    zhr.equipment_id asc,
    zhr.lane_no asc,
    zhr.report_id asc
go

