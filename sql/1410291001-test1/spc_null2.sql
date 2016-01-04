-- -- 
-- -- NOZZLE_NPM	REPORT_ID	0	108	numeric	38
-- -- NOZZLE_NPM	LOT	0	231	nvarchar	0
-- -- NOZZLE_NPM	STAGE	0	108	numeric	38
-- -- NOZZLE_NPM	TPROD	0	108	numeric	38
-- -- NOZZLE_NPM	HEAD	0	231	nvarchar	0
-- -- NOZZLE_NPM	NCADD	0	108	numeric	38
-- -- NOZZLE_NPM	NHADD	0	108	numeric	38
-- -- NOZZLE_NPM	TCNT	0	108	numeric	38
-- -- NOZZLE_NPM	TMISS	0	108	numeric	38
-- -- NOZZLE_NPM	RMISS	0	108	numeric	38
-- -- NOZZLE_NPM	HMISS	0	108	numeric	38
-- -- NOZZLE_NPM	BOARD	0	108	numeric	38
-- -- NOZZLE_NPM	NOZZLENUM	0	231	nvarchar	0
-- -- NOZZLE_NPM	NBLKCODE	0	231	nvarchar	0
-- -- NOZZLE_NPM	NBLKSERIAL	0	231	nvarchar	0
-- -- NOZZLE_NPM	FMISS	0	108	numeric	38
-- -- NOZZLE_NPM	MMISS	0	108	numeric	38
-- -- NOZZLE_NPM	PLACE_COUNT	0	108	numeric	38
-- -- NOZZLE_NPM	TRSMISS	0	108	numeric	38
-- -- NOZZLE_NPM	TIMESTAMP	0	108	numeric	38
-- --
-- -- select 
-- -- 	top 10
-- -- 	report_id, 
-- -- 	end_time, 
-- -- 	trx_productid 
-- -- from 
-- -- 	nozzle_npm_hdr_raw
-- -- where 
-- -- 	trx_productid like '20140929%'
-- -- and
-- -- 	setup_id <> -1
-- -- and
-- -- 	product_id <> -1
-- -- order by
-- -- 	report_id asc
-- -- go
-- -- 
-- -- select 
-- -- 	top 10
-- -- 	report_id, 
-- -- 	end_time, 
-- -- 	trx_productid 
-- -- from 
-- -- 	nozzle_npm_hdr_raw
-- -- where 
-- -- 	trx_productid like '20140927%'
-- -- and
-- -- 	end_time >= 1411994098
-- -- and
-- -- 	setup_id <> -1
-- -- and
-- -- 	product_id <> -1
-- -- order by
-- -- 	report_id asc
-- -- go
-- -- 
-- -- select
-- -- 	sum(d.tcnt) as 'sum(d.tcnt)',
-- -- 	sum(d.tmiss) as 'sum(d.tmiss)',
-- -- 	sum(d.rmiss) as 'sum(d.rmiss)',
-- -- 	sum(d.hmiss) as 'sum(d.hmiss)',
-- -- 	sum(d.fmiss) as 'sum(d.fmiss)',
-- -- 	sum(d.mmiss) as 'sum(d.mmiss)',
-- -- 	sum(d.place_count) as 'sum(d.place_count)',
-- -- 	sum(d.trsmiss) as 'sum(d.trsmiss)'
-- -- from
-- -- 	nozzle_npm d,
-- -- 	nozzle_npm_hdr h
-- -- where
-- -- 	h.end_time >= 1411994098
-- -- and
-- -- 	h.setup_id <> -1
-- -- and
-- -- 	h.product_id <> -1
-- -- and 
-- -- 	d.report_id = h.report_id
-- -- go
-- -- 
-- -- select
-- -- 	h.equipment_id as 'equipment_id',
-- -- 	sum(d.tcnt) as 'sum(d.tcnt)',
-- -- 	sum(d.tmiss) as 'sum(d.tmiss)',
-- -- 	sum(d.rmiss) as 'sum(d.rmiss)',
-- -- 	sum(d.hmiss) as 'sum(d.hmiss)',
-- -- 	sum(d.fmiss) as 'sum(d.fmiss)',
-- -- 	sum(d.mmiss) as 'sum(d.mmiss)',
-- -- 	sum(d.place_count) as 'sum(d.place_count)',
-- -- 	sum(d.trsmiss) as 'sum(d.trsmiss)'
-- -- from
-- -- 	nozzle_npm d,
-- -- 	nozzle_npm_hdr h
-- -- where
-- -- 	h.end_time >= 1411994098
-- -- and 
-- -- 	d.report_id = h.report_id
-- -- and
-- -- 	h.setup_id <> -1
-- -- and
-- -- 	h.product_id <> -1
-- -- group by
-- -- 	h.equipment_id
-- -- order by
-- -- 	h.equipment_id asc
-- -- go
-- -- 
-- -- select
-- -- 	h.equipment_id as 'equipment_id',
-- -- 	d.head as 'head',
-- -- 	d.ncadd as 'ncadd',
-- -- 	d.nozzlenum as 'nozzlenum',
-- -- 	sum(d.tcnt) as 'sum(d.tcnt)',
-- -- 	sum(d.tmiss) as 'sum(d.tmiss)',
-- -- 	sum(d.rmiss) as 'sum(d.rmiss)',
-- -- 	sum(d.hmiss) as 'sum(d.hmiss)',
-- -- 	sum(d.fmiss) as 'sum(d.fmiss)',
-- -- 	sum(d.mmiss) as 'sum(d.mmiss)',
-- -- 	sum(d.place_count) as 'sum(d.place_count)',
-- -- 	sum(d.trsmiss) as 'sum(d.trsmiss)'
-- -- from
-- -- 	nozzle_npm d,
-- -- 	nozzle_npm_hdr h
-- -- where
-- -- 	h.end_time >= 1411994098
-- -- and 
-- -- 	d.report_id = h.report_id
-- -- and
-- -- 	h.setup_id <> -1
-- -- and
-- -- 	h.product_id <> -1
-- -- group by
-- -- 	h.equipment_id,
-- -- 	d.head,
-- -- 	d.ncadd,
-- -- 	d.nozzlenum
-- -- order by
-- -- 	h.equipment_id asc,
-- -- 	d.head asc,
-- -- 	d.ncadd asc,
-- -- 	d.nozzlenum asc
-- -- go
-- -- 
-- -- select
-- -- 	h.equipment_id as 'equipment_id',
-- -- 	h.product_id as 'product_id',
-- -- 	sum(d.tcnt) as 'sum(d.tcnt)',
-- -- 	sum(d.tmiss) as 'sum(d.tmiss)',
-- -- 	sum(d.rmiss) as 'sum(d.rmiss)',
-- -- 	sum(d.hmiss) as 'sum(d.hmiss)',
-- -- 	sum(d.fmiss) as 'sum(d.fmiss)',
-- -- 	sum(d.mmiss) as 'sum(d.mmiss)',
-- -- 	sum(d.place_count) as 'sum(d.place_count)',
-- -- 	sum(d.trsmiss) as 'sum(d.trsmiss)'
-- -- from
-- -- 	nozzle_npm d,
-- -- 	nozzle_npm_hdr h
-- -- where
-- -- 	h.end_time >= 1411994098
-- -- and 
-- -- 	d.report_id = h.report_id
-- -- and
-- -- 	h.setup_id <> -1
-- -- and
-- -- 	h.product_id <> -1
-- -- group by
-- -- 	h.equipment_id,
-- -- 	h.product_id
-- -- order by
-- -- 	h.equipment_id asc,
-- -- 	h.product_id asc
-- -- go
-- -- 
-- select
-- 	h.equipment_id as 'equipment_id',
-- 	h.product_id as 'product_id',
-- 	d.ncadd as 'ncadd',
-- 	d.nhadd as 'nhadd',
-- 	sum(d.tcnt) as 'sum(d.tcnt)',
-- 	sum(d.tmiss+d.rmiss+d.hmiss+d.fmiss+d.mmiss) as 'total_error_counts',
-- 	sum(d.tmiss) as 'sum(d.tmiss)',
-- 	sum(d.rmiss) as 'sum(d.rmiss)',
-- 	sum(d.hmiss) as 'sum(d.hmiss)',
-- 	sum(d.fmiss) as 'sum(d.fmiss)',
-- 	sum(d.mmiss) as 'sum(d.mmiss)',
-- 	sum(d.trsmiss) as 'sum(d.trsmiss)',
-- 	sum(d.place_count) as 'sum(d.place_count)'
-- from
-- 	nozzle_npm_by_board d,
-- 	nozzle_npm_hdr_by_board h
-- where
-- 	h.trx_productid like '20141013%'
-- and 
-- 	d.report_id = h.report_id
-- and
-- 	h.setup_id <> -1
-- and
-- 	h.product_id <> -1
-- group by
-- 	h.equipment_id,
-- 	h.product_id,
-- 	d.ncadd,
-- 	d.nhadd
-- order by
-- 	h.equipment_id asc,
-- 	h.product_id asc,
-- 	d.ncadd asc,
-- 	d.nhadd asc
-- go
-- select
-- 	h.equipment_id as 'equipment_id',
-- 	d.ncadd as 'ncadd',
-- 	d.nhadd as 'nhadd',
-- 	sum(d.tcnt) as 'sum(d.tcnt)',
-- 	sum(d.tmiss+d.rmiss+d.hmiss+d.fmiss+d.mmiss) as 'total_error_counts',
-- 	sum(d.tmiss) as 'sum(d.tmiss)',
-- 	sum(d.rmiss) as 'sum(d.rmiss)',
-- 	sum(d.hmiss) as 'sum(d.hmiss)',
-- 	sum(d.fmiss) as 'sum(d.fmiss)',
-- 	sum(d.mmiss) as 'sum(d.mmiss)',
-- 	sum(d.trsmiss) as 'sum(d.trsmiss)',
-- 	sum(d.place_count) as 'sum(d.place_count)'
-- from
-- 	nozzle_npm_by_board d,
-- 	nozzle_npm_hdr_by_board h
-- where
-- 	h.trx_productid like '20141013%'
-- and 
-- 	d.report_id = h.report_id
-- and
-- 	h.setup_id <> -1
-- and
-- 	h.product_id <> -1
-- group by
-- 	h.equipment_id,
-- 	d.ncadd,
-- 	d.nhadd
-- order by
-- 	h.equipment_id asc,
-- 	d.ncadd asc,
-- 	d.nhadd asc
-- go
-- 
-- -- --
-- -- REPORT_ID	0	108	numeric	38
-- -- LOT	0	231	nvarchar	0
-- -- STAGE	0	108	numeric	38
-- -- TPROD	0	108	numeric	38
-- -- HEAD	0	231	nvarchar	0
-- -- FADD	0	108	numeric	38
-- -- FSADD	0	108	numeric	38
-- -- FBLKCODE	0	231	nvarchar	0
-- -- FBLKSERIAL	0	231	nvarchar	0
-- -- REELID	0	266	udt_reel_barcode	0
-- -- TCNT	0	108	numeric	38
-- -- TMISS	0	108	numeric	38
-- -- RMISS	0	108	numeric	38
-- -- HMISS	0	108	numeric	38
-- -- FMISS	0	108	numeric	38
-- -- MMISS	0	108	numeric	38
-- -- BOARD	0	108	numeric	38
-- -- PARTSNAME	0	231	nvarchar	0
-- -- PLACE_COUNT	0	108	numeric	38
-- -- TRSMISS	0	108	numeric	38
-- -- TIMESTAMP	0	108	numeric	38
-- -- REEL_ID	0	56	int	10
-- -- FEEDER_ID	0	56	int	10
-- -- --
-- -- select 
-- -- 	top 10
-- -- 	report_id, 
-- -- 	end_time, 
-- -- 	trx_productid 
-- -- from 
-- -- 	z_cass_npm_hdr_raw
-- -- where 
-- -- 	trx_productid like '20140929%'
-- -- and
-- -- 	setup_id <> -1
-- -- and
-- -- 	product_id <> -1
-- -- order by
-- -- 	report_id asc
-- -- go
-- -- 
-- -- select 
-- -- 	top 10
-- -- 	report_id, 
-- -- 	end_time, 
-- -- 	trx_productid 
-- -- from 
-- -- 	z_cass_npm_hdr_raw
-- -- where 
-- -- 	trx_productid like '20140927%'
-- -- and
-- -- 	end_time >= 1411994098
-- -- and
-- -- 	setup_id <> -1
-- -- and
-- -- 	product_id <> -1
-- -- order by
-- -- 	report_id asc
-- -- go
-- -- 
-- -- select
-- -- 	sum(d.tcnt) as 'sum(d.tcnt)',
-- -- 	sum(d.tmiss) as 'sum(d.tmiss)',
-- -- 	sum(d.rmiss) as 'sum(d.rmiss)',
-- -- 	sum(d.hmiss) as 'sum(d.hmiss)',
-- -- 	sum(d.fmiss) as 'sum(d.fmiss)',
-- -- 	sum(d.mmiss) as 'sum(d.mmiss)',
-- -- 	sum(d.place_count) as 'sum(d.place_count)',
-- -- 	sum(d.trsmiss) as 'sum(d.trsmiss)'
-- -- from
-- -- 	z_cass_npm_by_board d,
-- -- 	z_cass_npm_hdr_by_board h
-- -- where
-- -- 	h.trx_productid like '20140929%'
-- -- and
-- -- 	h.end_time >= 1411994098
-- -- and
-- -- 	h.setup_id <> -1
-- -- and
-- -- 	h.product_id <> -1
-- -- and 
-- -- 	d.report_id = h.report_id
-- -- go
-- -- 
-- -- select
-- -- 	h.equipment_id as 'equipment_id',
-- -- 	sum(d.tcnt) as 'sum(d.tcnt)',
-- -- 	sum(d.tmiss) as 'sum(d.tmiss)',
-- -- 	sum(d.rmiss) as 'sum(d.rmiss)',
-- -- 	sum(d.hmiss) as 'sum(d.hmiss)',
-- -- 	sum(d.fmiss) as 'sum(d.fmiss)',
-- -- 	sum(d.mmiss) as 'sum(d.mmiss)',
-- -- 	sum(d.place_count) as 'sum(d.place_count)',
-- -- 	sum(d.trsmiss) as 'sum(d.trsmiss)'
-- -- from
-- -- 	z_cass_npm d,
-- -- 	z_cass_npm_hdr h
-- -- where
-- -- 	h.end_time >= 1411994098
-- -- and 
-- -- 	d.report_id = h.report_id
-- -- and
-- -- 	h.setup_id <> -1
-- -- and
-- -- 	h.product_id <> -1
-- -- group by
-- -- 	h.equipment_id
-- -- order by
-- -- 	h.equipment_id asc
-- -- go
-- -- 
-- -- select
-- -- 	h.equipment_id as 'equipment_id',
-- -- 	d.partsname as 'd.partsname',
-- -- 	sum(d.tcnt) as 'sum(d.tcnt)',
-- -- 	sum(d.tmiss) as 'sum(d.tmiss)',
-- -- 	sum(d.rmiss) as 'sum(d.rmiss)',
-- -- 	sum(d.hmiss) as 'sum(d.hmiss)',
-- -- 	sum(d.fmiss) as 'sum(d.fmiss)',
-- -- 	sum(d.mmiss) as 'sum(d.mmiss)',
-- -- 	sum(d.place_count) as 'sum(d.place_count)',
-- -- 	sum(d.trsmiss) as 'sum(d.trsmiss)'
-- -- from
-- -- 	z_cass_npm d,
-- -- 	z_cass_npm_hdr h
-- -- where
-- -- 	h.end_time >= 1411994098
-- -- and 
-- -- 	d.report_id = h.report_id
-- -- and
-- -- 	h.setup_id <> -1
-- -- and
-- -- 	h.product_id <> -1
-- -- group by
-- -- 	h.equipment_id,
-- -- 	d.partsname
-- -- order by
-- -- 	h.equipment_id asc,
-- -- 	d.partsname asc
-- -- go
-- -- 
-- -- select
-- -- 	h.equipment_id as 'equipment_id',
-- -- 	h.product_id as 'product_id',
-- -- 	sum(d.tcnt) as 'sum(d.tcnt)',
-- -- 	sum(d.tmiss) as 'sum(d.tmiss)',
-- -- 	sum(d.rmiss) as 'sum(d.rmiss)',
-- -- 	sum(d.hmiss) as 'sum(d.hmiss)',
-- -- 	sum(d.fmiss) as 'sum(d.fmiss)',
-- -- 	sum(d.mmiss) as 'sum(d.mmiss)',
-- -- 	sum(d.place_count) as 'sum(d.place_count)',
-- -- 	sum(d.trsmiss) as 'sum(d.trsmiss)'
-- -- from
-- -- 	z_cass_npm d,
-- -- 	z_cass_npm_hdr h
-- -- where
-- -- 	h.end_time >= 1411994098
-- -- and 
-- -- 	d.report_id = h.report_id
-- -- and
-- -- 	h.setup_id <> -1
-- -- and
-- -- 	h.product_id <> -1
-- -- group by
-- -- 	h.equipment_id,
-- -- 	h.product_id
-- -- order by
-- -- 	h.equipment_id asc,
-- -- 	h.product_id asc
-- -- go
-- -- 
-- -- select
-- -- 	h.equipment_id as 'equipment_id',
-- -- 	d.fadd as 'fadd',
-- -- 	d.fsadd as 'fsadd',
-- -- 	d.partsname as 'partsname',
-- -- 	sum(d.tcnt) as 'sum(d.tcnt)',
-- -- 	sum(d.tmiss) as 'sum(d.tmiss)',
-- -- 	sum(d.rmiss) as 'sum(d.rmiss)',
-- -- 	sum(d.hmiss) as 'sum(d.hmiss)',
-- -- 	sum(d.fmiss) as 'sum(d.fmiss)',
-- -- 	sum(d.mmiss) as 'sum(d.mmiss)',
-- -- 	sum(d.place_count) as 'sum(d.place_count)',
-- -- 	sum(d.trsmiss) as 'sum(d.trsmiss)'
-- -- from
-- -- 	z_cass_npm d,
-- -- 	z_cass_npm_hdr h
-- -- where
-- -- 	h.end_time >= 1411994098,
-- -- --	trx_productid like '20141008%'
-- -- and 
-- -- 	d.report_id = h.report_id
-- -- and
-- -- 	h.setup_id <> -1
-- -- and
-- -- 	h.product_id <> -1
-- -- group by
-- -- 	h.equipment_id,
-- -- 	d.fadd,
-- -- 	d.fsadd,
-- -- 	d.partsname
-- -- order by
-- -- 	h.equipment_id asc,
-- -- 	d.fadd asc,
-- -- 	d.fsadd asc
-- -- go
-- -- select 
-- -- 	top 5
-- -- 	report_id, 
-- -- 	end_time, 
-- -- 	trx_productid 
-- -- from 
-- -- 	z_cass_npm_hdr_raw
-- -- where 
-- -- 	trx_productid like '20141008%'
-- -- and
-- -- 	setup_id <> -1
-- -- and
-- -- 	product_id <> -1
-- -- order by
-- -- 	end_time asc
-- -- go
-- -- select 
-- -- 	top 5
-- -- 	report_id, 
-- -- 	end_time, 
-- -- 	trx_productid 
-- -- from 
-- -- 	z_cass_npm_hdr_raw
-- -- where 
-- -- 	trx_productid like '20141008%'
-- -- and
-- -- 	setup_id <> -1
-- -- and
-- -- 	product_id <> -1
-- -- order by
-- -- 	end_time desc
-- -- go
-- -- select 
-- -- 	top 5
-- -- 	report_id, 
-- -- 	end_time, 
-- -- 	trx_productid 
-- -- from 
-- -- 	z_cass_npm_hdr_by_board
-- -- where 
-- -- 	trx_productid like '20141008%'
-- -- and
-- -- 	setup_id <> -1
-- -- and
-- -- 	product_id <> -1
-- -- order by
-- -- 	end_time asc
-- -- go
-- -- select 
-- -- 	top 5
-- -- 	report_id, 
-- -- 	end_time, 
-- -- 	trx_productid 
-- -- from 
-- -- 	z_cass_npm_hdr_by_board
-- -- where 
-- -- 	trx_productid like '20141008%'
-- -- and
-- -- 	setup_id <> -1
-- -- and
-- -- 	product_id <> -1
-- -- order by
-- -- 	end_time desc
-- -- go
-- -- select
-- -- 	h.equipment_id as 'equipment_id',
-- -- 	d.fadd as 'fadd',
-- -- 	d.fsadd as 'fsadd',
-- -- 	d.partsname as 'partsname',
-- -- 	sum(d.tcnt) as 'sum(d.tcnt)',
-- -- 	sum(d.tmiss) as 'sum(d.tmiss)',
-- -- 	sum(d.rmiss) as 'sum(d.rmiss)',
-- -- 	sum(d.hmiss) as 'sum(d.hmiss)',
-- -- 	sum(d.fmiss) as 'sum(d.fmiss)',
-- -- 	sum(d.mmiss) as 'sum(d.mmiss)',
-- -- 	sum(d.place_count) as 'sum(d.place_count)',
-- -- 	sum(d.trsmiss) as 'sum(d.trsmiss)'
-- -- from
-- -- 	z_cass_npm d,
-- -- 	z_cass_npm_hdr h
-- -- where
-- -- 	h.end_time >= 1412728393
-- -- and
-- -- 	h.end_time <= 1412756848	
-- -- and 
-- -- 	d.report_id = h.report_id
-- -- and
-- -- 	h.setup_id <> -1
-- -- and
-- -- 	h.product_id <> -1
-- -- group by
-- -- 	h.equipment_id,
-- -- 	d.fadd,
-- -- 	d.fsadd,
-- -- 	d.partsname
-- -- order by
-- -- 	h.equipment_id asc,
-- -- 	d.fadd asc,
-- -- 	d.fsadd asc
-- -- go
-- -- select
-- -- 	h.equipment_id as 'equipment_id',
-- -- 	h.end_time as 'end_time',
-- -- 	d.fadd as 'fadd',
-- -- 	d.fsadd as 'fsadd',
-- -- 	d.partsname as 'partsname',
-- -- 	d.tcnt as 'd.tcnt',
-- -- 	d.tmiss as 'd.tmiss',
-- -- 	d.rmiss as 'd.rmiss',
-- -- 	d.hmiss as 'd.hmiss',
-- -- 	d.fmiss as 'd.fmiss',
-- -- 	d.mmiss as 'd.mmiss',
-- -- 	d.place_count as 'd.place_count',
-- -- 	d.trsmiss as 'd.trsmiss'
-- -- from
-- -- 	z_cass_npm_raw d,
-- -- 	z_cass_npm_hdr_raw h
-- -- where
-- -- 	h.trx_productid like '20141008%'
-- -- and 
-- -- 	d.report_id = h.report_id
-- -- and
-- -- 	h.setup_id <> -1
-- -- and
-- -- 	h.product_id <> -1
-- -- order by
-- -- 	h.equipment_id asc,
-- -- 	h.end_time asc,
-- -- 	d.fadd asc,
-- -- 	d.fsadd asc,
-- -- 	d.partsname asc
-- -- go
-- -- select
-- -- 	h.equipment_id as 'equipment_id',
-- -- 	d.fadd as 'fadd',
-- -- 	d.fsadd as 'fsadd',
-- -- 	d.partsname as 'partsname',
-- -- 	sum(d.tcnt) as 'sum(d.tcnt)',
-- -- 	sum(d.tmiss) as 'sum(d.tmiss)',
-- -- 	sum(d.rmiss) as 'sum(d.rmiss)',
-- -- 	sum(d.hmiss) as 'sum(d.hmiss)',
-- -- 	sum(d.fmiss) as 'sum(d.fmiss)',
-- -- 	sum(d.mmiss) as 'sum(d.mmiss)',
-- -- 	sum(d.place_count) as 'sum(d.place_count)',
-- -- 	sum(d.trsmiss) as 'sum(d.trsmiss)'
-- -- from
-- -- 	z_cass_npm d,
-- -- 	z_cass_npm_hdr h
-- -- where
-- -- 	h.end_time >= 1412739911
-- -- and
-- -- 	h.end_time <= 1412756848	
-- -- and 
-- -- 	d.partsname = '4048345'
-- -- and 
-- -- 	d.report_id = h.report_id
-- -- and
-- -- 	h.setup_id <> -1
-- -- and
-- -- 	h.product_id <> -1
-- -- group by
-- -- 	h.equipment_id,
-- -- 	d.fadd,
-- -- 	d.fsadd,
-- -- 	d.partsname
-- -- order by
-- -- 	h.equipment_id asc,
-- -- 	d.fadd asc,
-- -- 	d.fsadd asc,
-- -- 	d.partsname asc
-- -- go
-- -- select
-- -- 	h.equipment_id as 'equipment_id',
-- -- 	d.fadd as 'fadd',
-- -- 	d.fsadd as 'fsadd',
-- -- 	d.partsname as 'partsname',
-- -- 	sum(d.tcnt) as 'sum(d.tcnt)',
-- -- 	sum(d.tmiss) as 'sum(d.tmiss)',
-- -- 	sum(d.rmiss) as 'sum(d.rmiss)',
-- -- 	sum(d.hmiss) as 'sum(d.hmiss)',
-- -- 	sum(d.fmiss) as 'sum(d.fmiss)',
-- -- 	sum(d.mmiss) as 'sum(d.mmiss)',
-- -- 	sum(d.place_count) as 'sum(d.place_count)',
-- -- 	sum(d.trsmiss) as 'sum(d.trsmiss)'
-- -- from
-- -- 	z_cass_npm_by_board d,
-- -- 	z_cass_npm_hdr_by_board h
-- -- where
-- -- 	h.trx_productid like '20141008%'
-- -- and
-- -- 	d.partsname = '4048345'
-- -- and 
-- -- 	d.report_id = h.report_id
-- -- and
-- -- 	h.setup_id <> -1
-- -- and
-- -- 	h.product_id <> -1
-- -- group by
-- -- 	h.equipment_id,
-- -- 	d.fadd,
-- -- 	d.fsadd,
-- -- 	d.partsname
-- -- order by
-- -- 	h.equipment_id asc,
-- -- 	d.fadd asc,
-- -- 	d.fsadd asc,
-- -- 	d.partsname asc
-- -- go
-- --====================================================================
-- -- select 
-- -- 	top 5
-- -- 	report_id, 
-- -- 	equipment_id,
-- -- 	end_time, 
-- -- 	trx_productid 
-- -- from 
-- -- 	z_cass_npm_hdr_by_board
-- -- where 
-- -- 	trx_productid like '20141008%'
-- -- and
-- -- 	setup_id <> -1
-- -- and
-- -- 	product_id <> -1
-- -- order by
-- -- 	end_time asc
-- -- go
-- -- select 
-- -- 	top 5
-- -- 	report_id, 
-- -- 	equipment_id,
-- -- 	end_time, 
-- -- 	trx_productid 
-- -- from 
-- -- 	z_cass_npm_hdr_by_board
-- -- where 
-- -- 	trx_productid like '20141008%'
-- -- and
-- -- 	setup_id <> -1
-- -- and
-- -- 	product_id <> -1
-- -- order by
-- -- 	end_time desc
-- -- go
-- select
-- 	h.equipment_id as 'equipment_id',
-- 	d.fadd as 'fadd',
-- 	d.fsadd as 'fsadd',
-- 	d.partsname as 'partsname',
-- 	d.tcnt as 'd.tcnt',
-- 	d.tmiss as 'd.tmiss',
-- 	d.rmiss as 'd.rmiss',
-- 	d.hmiss as 'd.hmiss',
-- 	d.fmiss as 'd.fmiss',
-- 	d.mmiss as 'd.mmiss',
-- 	d.place_count as 'd.place_count',
-- 	d.trsmiss as 'd.trsmiss'
-- from
-- 	z_cass_npm_by_board d,
-- 	z_cass_npm_hdr_by_board h
-- where
-- 	h.trx_productid like '20141013%'
-- and 
-- 	d.report_id = h.report_id
-- and
-- 	h.setup_id <> -1
-- and
-- 	h.product_id <> -1
-- order by
-- 	h.equipment_id asc,
-- 	d.fadd asc,
-- 	d.fsadd asc,
-- 	d.partsname asc
-- go
-- select
-- 	h.product_id as 'product_id',
-- 	h.equipment_id as 'equipment_id',
-- 	d.fadd as 'fadd',
-- 	d.fsadd as 'fsadd',
-- 	d.partsname as 'partsname',
-- 	sum(d.tcnt) as 'sum(d.tcnt)',
-- 	sum(d.tmiss+
-- 	    d.rmiss+
-- 	    d.hmiss+
-- 	    d.fmiss+
-- 	    d.mmiss) as 'total_error_count',
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
-- 	h.trx_productid like '20141013%'
-- and 
-- 	d.report_id = h.report_id
-- and
-- 	h.setup_id <> -1
-- and
-- 	h.product_id <> -1
-- group by
-- 	h.product_id,
-- 	h.equipment_id,
-- 	d.fadd,
-- 	d.fsadd,
-- 	d.partsname
-- order by
-- 	h.product_id asc,
-- 	h.equipment_id asc,
-- 	d.fadd asc,
-- 	d.fsadd asc,
-- 	d.partsname asc
-- go
select 
	report_id as 'report_id_nozzle_hdr_id_by_board', 
	trx_productid 
from 
	nozzle_npm_hdr_by_board
where 
	trx_productid like '20141015092056996+-+03+-+1+-+1+-+354270%'
and
	setup_id <> -1
and
	product_id <> -1
go
select 
	report_id as 'report_id_z_cass_hdr_id_by_board', 
	trx_productid 
from 
	z_cass_npm_hdr_by_board
where 
	trx_productid like '20141015092056996+-+03+-+1+-+1+-+354270%'
and
	setup_id <> -1
and
	product_id <> -1
go
select 
	report_id as 'report_id_prod_rpt_hdr_id_by_board', 
	trx_productid 
from 
	production_reports_npm_hdr_by_board
where 
	trx_productid like '20141015092056996+-+03+-+1+-+1+-+354270%'
and
	setup_id <> -1
and
	product_id <> -1
go
select 
	report_id as 'report_id_nozzle_hdr_id_raw', 
	trx_productid 
from 
	nozzle_npm_hdr_raw
where 
	trx_productid like '20141015092056996+-+03+-+1+-+1+-+354270%'
and
	setup_id <> -1
and
	product_id <> -1
go
select 
	report_id as 'report_id_z_cass_hdr_id_raw', 
	trx_productid 
from 
	z_cass_npm_hdr_raw
where 
	trx_productid like '20141015092056996+-+03+-+1+-+1+-+354270%'
and
	setup_id <> -1
and
	product_id <> -1
go
select 
	report_id as 'report_id_prod_rpt_hdr_id_raw', 
	trx_productid 
from 
	production_reports_npm_hdr_raw
where 
	trx_productid like '20141015092056996+-+03+-+1+-+1+-+354270%'
and
	setup_id <> -1
and
	product_id <> -1
go
-- select
-- 	h.equipment_id as 'equipment_id',
-- 	h.report_id as 'report_id',
-- 	h.trx_productid as 'trx_productid',
-- 	d.ncadd as 'ncadd',
-- 	d.nhadd as 'nhadd',
-- 	d.tcnt as 'd.tcnt',
-- 	d.tmiss as 'd.tmiss',
-- 	d.rmiss as 'd.rmiss',
-- 	d.hmiss as 'd.hmiss',
-- 	d.fmiss as 'd.fmiss',
-- 	d.mmiss as 'd.mmiss',
-- 	d.place_count as 'd.place_count',
-- 	d.trsmiss as 'd.trsmiss'
-- from
-- 	nozzle_npm_by_board d,
-- 	nozzle_npm_hdr_by_board h
-- where
-- 	d.report_id = h.report_id
-- and
-- 	h.setup_id <> -1
-- and
-- 	h.product_id <> -1
-- and
-- 	h.report_id >= 1900
-- and
-- 	h.report_id <= 1905
-- order by
-- 	h.equipment_id asc,
-- 	h.report_id asc,
-- 	d.ncadd asc,
-- 	d.nhadd asc
-- go
-- select
-- 	h.equipment_id as 'equipment_id',
-- 	h.report_id as 'report_id',
-- 	h.trx_productid as 'trx_productid',
-- 	d.ncadd as 'ncadd',
-- 	d.nhadd as 'nhadd',
-- 	d.tcnt as 'd.tcnt',
-- 	d.tmiss as 'd.tmiss',
-- 	d.rmiss as 'd.rmiss',
-- 	d.hmiss as 'd.hmiss',
-- 	d.fmiss as 'd.fmiss',
-- 	d.mmiss as 'd.mmiss',
-- 	d.place_count as 'd.place_count',
-- 	d.trsmiss as 'd.trsmiss'
-- from
-- 	nozzle_npm_raw d,
-- 	nozzle_npm_hdr_raw h
-- where
-- 	d.report_id = h.report_id
-- and
-- 	h.setup_id <> -1
-- and
-- 	h.product_id <> -1
-- and
-- 	h.report_id >= 1900
-- and
-- 	h.report_id <= 1905
-- order by
-- 	h.equipment_id asc,
-- 	h.report_id asc,
-- 	d.ncadd asc,
-- 	d.nhadd asc
-- go
select
	h.equipment_id as 'equipment_id',
	h.report_id as 'report_id',
	h.trx_productid as 'trx_productid',
	d.tpickup,
	d.tpmiss,
	d.trmiss,
	d.tdmiss,
	d.tmmiss,
	d.thmiss
from
	production_reports_npm_by_board d,
	production_reports_npm_hdr_by_board h
where
	d.report_id = h.report_id
and
	h.setup_id <> -1
and
	h.product_id <> -1
and
	h.report_id >= 1900
--and
--	h.report_id <= 1905
order by
	h.equipment_id asc,
	h.report_id asc
go
select
	h.equipment_id as 'equipment_id',
	h.report_id as 'report_id',
	h.trx_productid as 'trx_productid',
	d.tpickup,
	d.tpmiss,
	d.trmiss,
	d.tdmiss,
	d.tmmiss,
	d.thmiss
from
	production_reports_npm_raw d,
	production_reports_npm_hdr_raw h
where
	d.report_id = h.report_id
and
	h.setup_id <> -1
and
	h.product_id <> -1
and
	h.report_id >= 1900
--and
--	h.report_id <= 1905
order by
	h.equipment_id asc,
	h.report_id asc
go
select
	h.equipment_id as 'equipment_id',
	h.report_id as 'report_id',
	d.tpickup,
	d.tpmiss,
	d.trmiss,
	d.tdmiss,
	d.tmmiss,
	d.thmiss
from
	production_reports_npm_by_board d,
	production_reports_npm_hdr_by_board h
where
	d.report_id = h.report_id
and
	h.setup_id <> -1
and
	h.product_id <> -1
and
	h.report_id >= 1900
--and
--	h.report_id <= 1905
order by
	h.equipment_id asc,
	h.report_id asc
go
select
	h.equipment_id as 'equipment_id',
	h.report_id as 'report_id',
	d.tpickup,
	d.tpmiss,
	d.trmiss,
	d.tdmiss,
	d.tmmiss,
	d.thmiss
from
	production_reports_npm_raw d,
	production_reports_npm_hdr_raw h
where
	d.report_id = h.report_id
and
	h.setup_id <> -1
and
	h.product_id <> -1
and
	h.report_id >= 1900
--and
--	h.report_id <= 1905
order by
	h.equipment_id asc,
	h.report_id asc
go
select
	h.equipment_id as 'equipment_id',
	h.report_id as 'report_id',
	d.tpickup,
	d.tpmiss,
	d.trmiss,
	d.tdmiss,
	d.tmmiss,
	d.thmiss
from
	production_reports_npm_by_board d,
	production_reports_npm_hdr_by_board h
where
	d.report_id = h.report_id
and
	h.setup_id <> -1
and
	h.product_id <> -1
and
	h.report_id >= 1900
and
	d.tdmiss > 0
--	h.report_id <= 1905
order by
	h.equipment_id asc,
	h.report_id asc
go
select
	h.equipment_id as 'equipment_id',
	h.report_id as 'report_id',
	d.tpickup,
	d.tpmiss,
	d.trmiss,
	d.tdmiss,
	d.tmmiss,
	d.thmiss
from
	production_reports_npm_raw d,
	production_reports_npm_hdr_raw h
where
	d.report_id = h.report_id
and
	h.setup_id <> -1
and
	h.product_id <> -1
and
	h.report_id >= 1900
and
	d.tdmiss > 0
--	h.report_id <= 1905
order by
	h.equipment_id asc,
	h.report_id asc
go
