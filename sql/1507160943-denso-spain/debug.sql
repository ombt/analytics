select 
    r.route_name,
    -- r.route_id,
    -- rl.pos,
    -- rl.zone_id,
    -- z.zone_name,
    -- z.trace_level,
    -- z.module_id,
    -- zl.pos,
    zl.equipment_id,
    eq.equipment_name,
    p.lane_no,
    p.stage_no,
    p.end_time,
    -- p.panel_id,
    -- p.equipment_id,
    p.nc_version,
    -- p.start_time,
    -- p.panel_equipment_id,
    -- p.panel_source,
    -- p.panel_trace,
    -- p.job_id,
    -- p.setup_id,
    -- p.trx_product_id,
    -- pph.equipment_id,
    -- pph.panel_equipment_id,
    -- pph.trx_product_id,
    -- pph.master_placement_id,
    -- pph.panel_placement_id,
    -- pph.timestamp,
    -- pph.panel_placement_id,
    count(ppd.panel_placement_id) as 'count_ppd_recs'
from
    routes r
inner join
    route_layout rl
on
    rl.route_id = r.route_id
and
    r.valid_flag = 't'
inner join
    zones z
on
    z.zone_id = rl.zone_id
and
    z.valid_flag = 't'
and
    z.module_id > 0
inner join
    zone_layout zl
on
    zl.zone_id = rl.zone_id
inner join
    equipment eq
on
    eq.equipment_id = zl.equipment_id
inner join
    panels p
on
    p.equipment_id = zl.equipment_id
and
    p.end_time >= 1434405600
and
    p.end_time < 1434491999
left join
    panel_placement_header pph
on
    pph.equipment_id = p.equipment_id
and
    pph.panel_equipment_id = p.panel_equipment_id
left join
    panel_placement_details ppd
on
    ppd.panel_placement_id = pph.master_placement_id
group by
    r.route_id,
    r.route_name,
    rl.pos,
    zl.equipment_id,
    eq.equipment_name,
    p.lane_no,
    p.stage_no,
    p.end_time,
    p.nc_version
order by
    r.route_id asc,
    rl.pos asc,
    p.lane_no asc,
    p.stage_no asc,
    p.end_time asc
go

print 'list of all placement header records with ZERO details'

select 
    r.route_name,
    -- r.route_id,
    -- rl.pos,
    -- rl.zone_id,
    -- z.zone_name,
    -- z.trace_level,
    -- z.module_id,
    -- zl.pos,
    zl.equipment_id,
    eq.equipment_name,
    p.lane_no,
    p.stage_no,
    p.end_time,
    -- p.panel_id,
    -- p.equipment_id,
    p.nc_version,
    -- p.start_time,
    -- p.panel_equipment_id,
    -- p.panel_source,
    -- p.panel_trace,
    -- p.job_id,
    -- p.setup_id,
    -- p.trx_product_id,
    td.serial_no,
    td.prod_model_no,
    td.panel_id,
    td.pattern_id,
    td.barcode,
    -- td.setup_id,
    -- td.top_bottom,
    -- td.timestamp,
    -- td.import_flag,
    -- pph.equipment_id,
    -- pph.panel_equipment_id,
    pph.trx_product_id,
    -- pph.master_placement_id,
    -- pph.panel_placement_id,
    -- pph.timestamp,
    -- pph.panel_placement_id,
    count(ppd.panel_placement_id) as 'count_ppd_recs'
from
    routes r
inner join
    route_layout rl
on
    rl.route_id = r.route_id
and
    r.valid_flag = 't'
inner join
    zones z
on
    z.zone_id = rl.zone_id
and
    z.valid_flag = 't'
and
    z.module_id > 0
inner join
    zone_layout zl
on
    zl.zone_id = rl.zone_id
inner join
    equipment eq
on
    eq.equipment_id = zl.equipment_id
inner join
    panels p
on
    p.equipment_id = zl.equipment_id
and
    p.end_time >= 1434405600
and
    p.end_time < 1434491999
inner join
    tracking_data td
on
    td.panel_id = p.panel_id
left join
    panel_placement_header pph
on
    pph.equipment_id = p.equipment_id
and
    pph.panel_equipment_id = p.panel_equipment_id
left join
    panel_placement_details ppd
on
    ppd.panel_placement_id = pph.master_placement_id
group by
    r.route_id,
    r.route_name,
    rl.pos,
    zl.equipment_id,
    eq.equipment_name,
    p.lane_no,
    p.stage_no,
    p.end_time,
    p.nc_version,
    pph.trx_product_id,
    td.serial_no,
    td.prod_model_no,
    td.panel_id,
    td.pattern_id,
    td.barcode
    -- td.setup_id,
    -- td.top_bottom,
    -- td.timestamp,
    -- td.import_flag
having
    count(ppd.panel_placement_id) = 0
order by
    r.route_id asc,
    rl.pos asc,
    p.lane_no asc,
    p.stage_no asc,
    p.end_time asc
go

print 'nc version with no placement details and count of nc details'

select
    ncs.nc_version as 'nc_version',
    count(ncpd.nc_version) as 'count'
from
    nc_summary ncs
left join
    nc_placement_detail ncpd
on
    ncpd.nc_version = ncs.nc_version
group by
    ncs.nc_version 
having
    ncs.nc_version in (
15414,
15416,
15418,
15503,
15505,
15507,
16013,
16014,
16968,
17115,
17116,
17121,
17122,
17125,
17126,
17135,
17136,
17137,
17138,
17143,
17144,
17149,
17150,
17155,
17156,
17164,
17165,
17166,
17167,
18462,
18472,
18499,
18907,
18939,
19107,
19125,
22159,
22160,
23508,
23509,
23510,
23556,
23557,
23558,
23592,
23593,
23594,
23595,
23596,
23597,
23616,
23617,
23618,
23622,
23623,
23624,
27223,
27224,
27225,
27226,
27227,
27228,
27229,
27230,
27231,
27262,
27263,
27264,
27265,
27266,
27267,
27268,
27269,
27270,
27441,
27442,
27443,
27444,
27445,
27446,
27447,
27448,
27449,
27475,
27476,
27477,
31060,
31063,
31066,
31242,
32102,
32691,
32695,
32700,
32702,
32703,
32705,
32709,
32710,
32711,
32712,
32713,
32714,
32718,
32719,
32723,
32736,
32737,
32749,
32836,
32837,
32978,
33110,
33153,
33154,
33155,
33166,
33167,
33221,
33230
)
order by
    ncs.nc_version asc
go

print 'get nc placemenet details for nc version = 33221 and 33230'

select
    *
from
    nc_placement_detail ncpd
where
    nc_version
in ( 33221, 33230 )
go
