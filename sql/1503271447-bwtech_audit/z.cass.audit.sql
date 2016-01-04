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
--     zhr.mgmt_report_id as zhr_mgmt_report_id,
--     zhr.report_id      as zhr_report_id,
--     zhr.product_id     as zhr_product_id,
--     zhr.equipment_id   as zhr_equipment_id,
--     zhr.lane_no        as zhr_lane_no,
--     zhr.start_time     as zhr_start_time,
--     zhr.end_time       as zhr_end_time,
--     zhr.setup_id       as zhr_setup_id,
--     zhr.nc_version     as zhr_nc_version,
--     zhr.job_id         as zhr_job_id,
--     zhr.report_file    as zhr_report_file
-- from
--     z_cass_header_raw zhr
-- where
--     zhr.end_time >= 1423465200
-- and
--     zhr.end_time <= 1423551600
-- order by
--     zhr.equipment_id asc,
--     zhr.report_id asc
-- go

select
    -- zhr.mgmt_report_id            as zhr_mgmt_report_id,
    -- zhr.product_id                as zhr_product_id,
    zhr.equipment_id              as zhr_equipment_id,
    zhr.lane_no                   as zhr_lane_no,
    zhr.report_id                 as zhr_report_id,
    -- zhr.start_time                as zhr_start_time,
    zhr.end_time                  as zhr_end_time,
    -- zhr.setup_id                  as zhr_setup_id,
    -- zhr.nc_version                as zhr_nc_version,
    -- zhr.job_id                    as zhr_job_id,
    -- zhr.report_file               as zhr_report_file,
    -- zr.report_id                  as zr_report_id,
    zr.cassette                   as zr_cassette,
    zr.slot                       as zr_slot,
    zr.subslot                    as zr_subslot,
    zr.comp_id                    as zr_comp_id,
    -- zr.reel_id                    as zr_reel_id,
    -- zr.feeder_id                  as zr_feeder_id,
    -- zr.stocked                    as zr_stocked,
    -- zr.remaining                  as zr_remaining,
    -- zr.comp_exhaust               as zr_comp_exhaust,
    zr.pickup_count               as zr_pickup_count,
    zr.place_count                as zr_place_count,
    -- zr.pickup_error_count         as zr_pickup_error_count,
    zr.pickup_miss_count          as zr_pickup_miss_count,
    zr.recog_error_count          as zr_recog_error_count,
    -- zr.shape_error_count          as zr_shape_error_count,
    zr.height_miss_count          as zr_height_miss_count
    -- zr.coplanarity                as zr_coplanarity,
    -- zr.need_for_current_product   as zr_need_for_current_product,
    -- zr.other_error_count          as zr_other_error_count,
    -- zr.colinearity_count          as zr_colinearity_count,
    -- zr.pickup_attempt_count       as zr_pickup_attempt_count,
    -- zr.place_search_attempt_count as zr_place_search_attempt_count,
    -- zr.place_search_failure_count as zr_place_search_failure_count,
    -- zr.vision_failures            as zr_vision_failures,
    -- zr.initial_part_count         as zr_initial_part_count,
    -- zr.used_parts_count           as zr_used_parts_count,
    -- zr.table_no                   as zr_table_no,
    -- zr.table_slot                 as zr_table_slot,
    -- zr.table_subslot              as zr_table_subslot
    -- zr.primary_pn                 as zr_primary_pn
from
    z_cass_header_raw zhr
left join
    z_cass_raw zr
on
    zhr.report_id = zr.report_id
where
    zhr.end_time >= 1423465200
and
    zhr.end_time <= 1423551600
order by
    zhr.equipment_id asc,
    zhr.report_id asc
go

