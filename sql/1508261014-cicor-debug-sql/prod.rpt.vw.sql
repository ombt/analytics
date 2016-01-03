-- PRODUCTION_REPORTS_NPM_HDR_RAW	REPORT_ID	
-- PRODUCTION_REPORTS_NPM_HDR_RAW	PRODUCT_ID
-- PRODUCTION_REPORTS_NPM_HDR_RAW	EQUIPMENT_ID
-- PRODUCTION_REPORTS_NPM_HDR_RAW	START_TIME
-- PRODUCTION_REPORTS_NPM_HDR_RAW	END_TIME
-- PRODUCTION_REPORTS_NPM_HDR_RAW	SETUP_ID
-- PRODUCTION_REPORTS_NPM_HDR_RAW	NC_VERSION
-- PRODUCTION_REPORTS_NPM_HDR_RAW	LANE_NO
-- PRODUCTION_REPORTS_NPM_HDR_RAW	JOB_ID
-- PRODUCTION_REPORTS_NPM_HDR_RAW	TRX_PRODUCTID
-- PRODUCTION_REPORTS_NPM_HDR_RAW	STAGE
-- PRODUCTION_REPORTS_NPM_HDR_RAW	TIMESTAMP
-- PRODUCTION_REPORTS_NPM_HDR_RAW	PREV_REPORT_ID
--
-- select 
-- 	top 10
-- 	report_id, 
-- 	end_time, 
-- 	trx_productid 
-- from 
-- 	production_reports_npm_hdr_raw
-- where 
-- 	trx_productid like '20140929%'
-- order by
-- 	report_id asc
-- go
-- 
-- select 
-- 	top 10
-- 	report_id, 
-- 	end_time, 
-- 	trx_productid 
-- from 
-- 	production_reports_npm_hdr_raw
-- where 
-- 	trx_productid like '20140927%'
-- and
-- 	end_time >= 1411993648
-- order by
-- 	report_id asc
-- go
-- 
-- select
-- 	sum(d.tpickup) as 'sum(d.tpickup)',
-- 	sum(d.cperr_time) as 'sum(d.cperr_time)',
-- 	sum(d.cperr_count) as 'sum(d.cperr_count)',
-- 	sum(d.tpmiss) as 'sum(d.tpmiss)',
-- 	sum(d.trmiss) as 'sum(d.trmiss)',
-- 	sum(d.tdmiss) as 'sum(d.tdmiss)',
-- 	sum(d.tmmiss) as 'sum(d.tmmiss)',
-- 	sum(d.thmiss) as 'sum(d.thmiss)'
-- from
-- 	production_reports_npm d,
-- 	production_reports_npm_hdr h
-- where
-- 	h.end_time >= 1411993648
-- and 
-- 	d.report_id = h.report_id
-- go
-- 
-- select
-- 	h.equipment_id as 'h.equipment_id',
-- 	sum(d.cperr_time) as 'sum(d.cperr_time)',
-- 	sum(d.cperr_count) as 'sum(d.cperr_count)',
-- 	sum(d.tpickup) as 'sum(d.tpickup)',
-- 	sum(d.tpmiss) as 'sum(d.tpmiss)',
-- 	sum(d.trmiss) as 'sum(d.trmiss)',
-- 	sum(d.tdmiss) as 'sum(d.tdmiss)',
-- 	sum(d.tmmiss) as 'sum(d.tmmiss)',
-- 	sum(d.thmiss) as 'sum(d.thmiss)'
-- from
-- 	production_reports_npm d,
-- 	production_reports_npm_hdr h
-- where
-- 	h.end_time >= 1411993648
-- and 
-- 	d.report_id = h.report_id
-- group by
-- 	h.equipment_id
-- order by
-- 	h.equipment_id asc
-- go

select
	d.equipment_id as 'd.equipment_id',
	dbo.convert_to_hhmmss(sum(d.cperr_time)) as 'sum(d.cperr_time) HHMMSS',
	sum(d.cperr_time) as 'sum(d.cperr_time)',
	sum(d.cperr_count) as 'sum(d.cperr_count)',
	sum(d.chip_pickup_err_cnt) as 'sum(d.chip_pickup_err_cnt)'
from
	production_reports_view d
where
	d.end_time >= 1411993648
group by
	d.equipment_id
order by
	d.equipment_id asc
go
