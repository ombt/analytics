-- 
-- NOZZLE_NPM	REPORT_ID	0	108	numeric	38
-- NOZZLE_NPM	LOT	0	231	nvarchar	0
-- NOZZLE_NPM	STAGE	0	108	numeric	38
-- NOZZLE_NPM	TPROD	0	108	numeric	38
-- NOZZLE_NPM	HEAD	0	231	nvarchar	0
-- NOZZLE_NPM	NCADD	0	108	numeric	38
-- NOZZLE_NPM	NHADD	0	108	numeric	38
-- NOZZLE_NPM	TCNT	0	108	numeric	38
-- NOZZLE_NPM	TMISS	0	108	numeric	38
-- NOZZLE_NPM	RMISS	0	108	numeric	38
-- NOZZLE_NPM	HMISS	0	108	numeric	38
-- NOZZLE_NPM	BOARD	0	108	numeric	38
-- NOZZLE_NPM	NOZZLENUM	0	231	nvarchar	0
-- NOZZLE_NPM	NBLKCODE	0	231	nvarchar	0
-- NOZZLE_NPM	NBLKSERIAL	0	231	nvarchar	0
-- NOZZLE_NPM	FMISS	0	108	numeric	38
-- NOZZLE_NPM	MMISS	0	108	numeric	38
-- NOZZLE_NPM	PLACE_COUNT	0	108	numeric	38
-- NOZZLE_NPM	TRSMISS	0	108	numeric	38
-- NOZZLE_NPM	TIMESTAMP	0	108	numeric	38
--
-- select 
-- 	top 10
-- 	report_id, 
-- 	end_time, 
-- 	trx_productid 
-- from 
-- 	nozzle_npm_hdr_raw
-- where 
-- 	trx_productid like '20140929%'
-- and
-- 	setup_id <> -1
-- and
-- 	product_id <> -1
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
-- 	nozzle_npm_hdr_raw
-- where 
-- 	trx_productid like '20140927%'
-- and
-- 	end_time >= 1411994098
-- and
-- 	setup_id <> -1
-- and
-- 	product_id <> -1
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
-- 	nozzle_npm d,
-- 	nozzle_npm_hdr h
-- where
-- 	h.end_time >= 1411994098
-- and
-- 	h.setup_id <> -1
-- and
-- 	h.product_id <> -1
-- and 
-- 	d.report_id = h.report_id
-- go
-- 
-- select
-- 	h.equipment_id as 'equipment_id',
-- 	sum(d.tcnt) as 'sum(d.tcnt)',
-- 	sum(d.tmiss) as 'sum(d.tmiss)',
-- 	sum(d.rmiss) as 'sum(d.rmiss)',
-- 	sum(d.hmiss) as 'sum(d.hmiss)',
-- 	sum(d.fmiss) as 'sum(d.fmiss)',
-- 	sum(d.mmiss) as 'sum(d.mmiss)',
-- 	sum(d.place_count) as 'sum(d.place_count)',
-- 	sum(d.trsmiss) as 'sum(d.trsmiss)'
-- from
-- 	nozzle_npm d,
-- 	nozzle_npm_hdr h
-- where
-- 	h.end_time >= 1411994098
-- and 
-- 	d.report_id = h.report_id
-- and
-- 	h.setup_id <> -1
-- and
-- 	h.product_id <> -1
-- group by
-- 	h.equipment_id
-- order by
-- 	h.equipment_id asc
-- go
-- 
-- select
-- 	h.equipment_id as 'equipment_id',
-- 	d.head as 'head',
-- 	d.ncadd as 'ncadd',
-- 	d.nozzlenum as 'nozzlenum',
-- 	sum(d.tcnt) as 'sum(d.tcnt)',
-- 	sum(d.tmiss) as 'sum(d.tmiss)',
-- 	sum(d.rmiss) as 'sum(d.rmiss)',
-- 	sum(d.hmiss) as 'sum(d.hmiss)',
-- 	sum(d.fmiss) as 'sum(d.fmiss)',
-- 	sum(d.mmiss) as 'sum(d.mmiss)',
-- 	sum(d.place_count) as 'sum(d.place_count)',
-- 	sum(d.trsmiss) as 'sum(d.trsmiss)'
-- from
-- 	nozzle_npm d,
-- 	nozzle_npm_hdr h
-- where
-- 	h.end_time >= 1411994098
-- and 
-- 	d.report_id = h.report_id
-- and
-- 	h.setup_id <> -1
-- and
-- 	h.product_id <> -1
-- group by
-- 	h.equipment_id,
-- 	d.head,
-- 	d.ncadd,
-- 	d.nozzlenum
-- order by
-- 	h.equipment_id asc,
-- 	d.head asc,
-- 	d.ncadd asc,
-- 	d.nozzlenum asc
-- go
-- 
-- select
-- 	h.equipment_id as 'equipment_id',
-- 	h.product_id as 'product_id',
-- 	sum(d.tcnt) as 'sum(d.tcnt)',
-- 	sum(d.tmiss) as 'sum(d.tmiss)',
-- 	sum(d.rmiss) as 'sum(d.rmiss)',
-- 	sum(d.hmiss) as 'sum(d.hmiss)',
-- 	sum(d.fmiss) as 'sum(d.fmiss)',
-- 	sum(d.mmiss) as 'sum(d.mmiss)',
-- 	sum(d.place_count) as 'sum(d.place_count)',
-- 	sum(d.trsmiss) as 'sum(d.trsmiss)'
-- from
-- 	nozzle_npm d,
-- 	nozzle_npm_hdr h
-- where
-- 	h.end_time >= 1411994098
-- and 
-- 	d.report_id = h.report_id
-- and
-- 	h.setup_id <> -1
-- and
-- 	h.product_id <> -1
-- group by
-- 	h.equipment_id,
-- 	h.product_id
-- order by
-- 	h.equipment_id asc,
-- 	h.product_id asc
-- go
-- 
select
	h.equipment_id as 'equipment_id',
	h.product_id as 'product_id',
	d.ncadd as 'ncadd',
	d.nhadd as 'nhadd',
	sum(d.tcnt) as 'sum(d.tcnt)',
	sum(d.tmiss+d.rmiss+d.hmiss+d.fmiss+d.mmiss) as 'total_error_counts',
	sum(d.tmiss) as 'sum(d.tmiss)',
	sum(d.rmiss) as 'sum(d.rmiss)',
	sum(d.hmiss) as 'sum(d.hmiss)',
	sum(d.fmiss) as 'sum(d.fmiss)',
	sum(d.mmiss) as 'sum(d.mmiss)',
	sum(d.trsmiss) as 'sum(d.trsmiss)',
	sum(d.place_count) as 'sum(d.place_count)'
from
	nozzle_npm_by_board d,
	nozzle_npm_hdr_by_board h
where
	h.trx_productid like '20141013%'
and 
	d.report_id = h.report_id
and
	h.setup_id <> -1
and
	h.product_id <> -1
group by
	h.equipment_id,
	h.product_id,
	d.ncadd,
	d.nhadd
order by
	h.equipment_id asc,
	h.product_id asc,
	d.ncadd asc,
	d.nhadd asc
go
select
	h.equipment_id as 'equipment_id',
	d.ncadd as 'ncadd',
	d.nhadd as 'nhadd',
	sum(d.tcnt) as 'sum(d.tcnt)',
	sum(d.tmiss+d.rmiss+d.hmiss+d.fmiss+d.mmiss) as 'total_error_counts',
	sum(d.tmiss) as 'sum(d.tmiss)',
	sum(d.rmiss) as 'sum(d.rmiss)',
	sum(d.hmiss) as 'sum(d.hmiss)',
	sum(d.fmiss) as 'sum(d.fmiss)',
	sum(d.mmiss) as 'sum(d.mmiss)',
	sum(d.trsmiss) as 'sum(d.trsmiss)',
	sum(d.place_count) as 'sum(d.place_count)'
from
	nozzle_npm_by_board d,
	nozzle_npm_hdr_by_board h
where
	h.trx_productid like '20141013%'
and 
	d.report_id = h.report_id
and
	h.setup_id <> -1
and
	h.product_id <> -1
group by
	h.equipment_id,
	d.ncadd,
	d.nhadd
order by
	h.equipment_id asc,
	d.ncadd asc,
	d.nhadd asc
go

