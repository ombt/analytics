-- 1417501145-0000026477-+03EA547D58BAE6+-01-00-4803.mlg
-- 1417501289-0000026477-+03EA547D58BAE6+-02-00-4803.mlg
-- 
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
-- 
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
    p.trx_product_id like '1417501145-0000026477-+03EA547D58BAE6+%'
or
    p.trx_product_id like '1417501289-0000026477-+03EA547D58BAE6+%'
