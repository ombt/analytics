
-- production_reports_npm tpickup
-- production_reports_npm tpmiss
-- production_reports_npm trmiss
-- production_reports_npm tdmiss
-- production_reports_npm tmmiss
-- production_reports_npm thmiss
-- product_data product_id
-- product_data product_name


select
    -- prh.report_id,
    prh.product_id,
    pd.product_name,
    -- prh.equipment_id,
    -- prh.start_time,
    -- prh.end_time,
    -- prh.setup_id,
    -- prh.nc_version,
    prh.lane_no,
    -- prh.job_id,
    -- prh.trx_productid,
    -- prh.stage,
    -- prh.timestamp,
    -- prd.report_id,
    sum(prd.tpickup) as sum_tpickup,
    sum(prd.tpmiss) as sum_tpmiss,
    sum(prd.trmiss) as sum_trmiss,
    sum(prd.tdmiss) as sum_tdmiss,
    sum(prd.tmmiss) as sum_tmmiss,
    sum(prd.thmiss) as sum_thmiss,
    sum(prd.tpickup-prd.tpmiss-prd.trmiss-prd.tdmiss-prd.tmmiss-prd.thmiss) as sum_place
    -- sum(prd.total) as sum_prd_total,
    -- sum(prd.actual) as sum_prd_actual,
    -- sum(prd.board) as sum_prd_board
    -- sum(prd.pboard) as sum_prd_pboard
from
    production_reports_npm_hdr prh
left join
    product_data pd
on
    prh.product_id = pd.product_id
left join
    production_reports_npm prd
on
    prh.report_id = prd.report_id
where
    1439096400 <= prh.end_time 
and
    prh.end_time <= 1439701200
and
    prh.equipment_id in ( 1345, 1348, 1351, 1352, 1353 )
group by
    prh.product_id,
    pd.product_name,
    -- prh.equipment_id,
    prh.lane_no
order by
    prh.product_id asc,
    -- prh.equipment_id asc,
    prh.lane_no asc
go
