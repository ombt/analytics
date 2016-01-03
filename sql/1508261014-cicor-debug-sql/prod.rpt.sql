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
select 
	top 10
	report_id, 
	end_time, 
	trx_productid 
from 
	production_reports_npm_hdr_raw
where 
	trx_productid like '20140929%'
order by
	report_id asc
go

select 
	top 10
	report_id, 
	end_time, 
	trx_productid 
from 
	production_reports_npm_hdr_raw
where 
	trx_productid like '20140927%'
and
	end_time >= 1411993648
order by
	report_id asc
go

select
	sum(d.tpickup) as 'sum(d.tpickup)',
	sum(d.tpmiss) as 'sum(d.tpmiss)',
	sum(d.trmiss) as 'sum(d.trmiss)',
	sum(d.tdmiss) as 'sum(d.tdmiss)',
	sum(d.tmmiss) as 'sum(d.tmmiss)',
	sum(d.thmiss) as 'sum(d.thmiss)'
from
	production_reports_npm_by_board d,
	production_reports_npm_hdr_by_board h
where
	h.trx_productid like '20140929%'
and
	h.end_time >= 1411993648
and 
	d.report_id = h.report_id
go
