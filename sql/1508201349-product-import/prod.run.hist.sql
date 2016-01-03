
-- product_run_history product_run_history_id
-- product_run_history equipment_id
-- product_run_history lane_no
-- product_run_history setup_id
-- product_run_history start_time
-- product_run_history end_time

select
    prh.product_run_history_id,
    prh.equipment_id,
    prh.lane_no,
    prh.setup_id,
    prh.start_time,
    prh.end_time
from
    product_run_history prh
where
    prh.end_time > 2000000000
go

-- product_run_history equipment_id
-- product_run_history lane_no
-- product_run_history setup_id
-- product_run_history start_time

