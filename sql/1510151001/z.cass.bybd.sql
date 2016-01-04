--
-- REPORT_ID	0	108	numeric	38
-- LOT	0	231	nvarchar	0
-- STAGE	0	108	numeric	38
-- TPROD	0	108	numeric	38
-- HEAD	0	231	nvarchar	0
-- FADD	0	108	numeric	38
-- FSADD	0	108	numeric	38
-- FBLKCODE	0	231	nvarchar	0
-- FBLKSERIAL	0	231	nvarchar	0
-- REELID	0	266	udt_reel_barcode	0
-- TCNT	0	108	numeric	38
-- TMISS	0	108	numeric	38
-- RMISS	0	108	numeric	38
-- HMISS	0	108	numeric	38
-- FMISS	0	108	numeric	38
-- MMISS	0	108	numeric	38
-- BOARD	0	108	numeric	38
-- PARTSNAME	0	231	nvarchar	0
-- PLACE_COUNT	0	108	numeric	38
-- TRSMISS	0	108	numeric	38
-- TIMESTAMP	0	108	numeric	38
-- REEL_ID	0	56	int	10
-- FEEDER_ID	0	56	int	10
--

-- select 
-- 	top 10
-- 	report_id, 
-- 	end_time, 
-- 	trx_productid 
-- from 
-- 	z_cass_npm_hdr_raw
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
-- 	z_cass_npm_hdr_raw
-- where 
-- 	trx_productid like '20140927%'
-- and
-- 	end_time >= 1411993648
-- order by
-- 	report_id asc
-- go
-- 
-- select
-- 	sum(d.tcnt) as 'sum(d.tcnt)',
-- 	sum(d.tmiss) as 'sum(d.tmiss)',
-- 	sum(d.rmiss) as 'sum(d.rmiss)',
-- 	sum(d.hmiss) as 'sum(d.hmiss)',
-- 	sum(d.fmiss) as 'sum(d.fmiss)',
-- 	sum(d.mmiss) as 'sum(d.mmiss)',
-- 	sum(d.place_count) as 'sum(d.place_count)',
-- 	sum(d.trsmiss) as 'sum(d.trsmiss)'
-- from
-- 	z_cass_npm_by_board d,
-- 	z_cass_npm_hdr_by_board h
-- where
-- 	h.trx_productid like '20140929%'
-- and
-- 	h.end_time >= 1411994098
-- and 
-- 	d.report_id = h.report_id
-- go

select
	h.equipment_id as 'equipment_id',
	sum(d.tcnt) as 'sum(d.tcnt)',
	sum(d.tmiss) as 'sum(d.tmiss)',
	sum(d.rmiss) as 'sum(d.rmiss)',
	sum(d.hmiss) as 'sum(d.hmiss)',
	sum(d.fmiss) as 'sum(d.fmiss)',
	sum(d.mmiss) as 'sum(d.mmiss)',
	sum(d.place_count) as 'sum(d.place_count)',
	sum(d.trsmiss) as 'sum(d.trsmiss)'
from
	z_cass_npm_by_board d,
	z_cass_npm_hdr_by_board h
where
	h.end_time >= 1442941200
and
	h.end_time >= 1443027600
and 
	d.report_id = h.report_id
group by
	h.equipment_id
order by
	h.equipment_id asc
go

