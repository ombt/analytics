select 
    r.route_name as          'r.route_name',
    td.panel_id as           'td.panel_id',
    eq.equipment_name as     'eq.equipment_name',
    eq.equipment_id as       'eq.equipment_id',
    p.lane_no as             'p.lane_no',
    p.stage_no as            'p.stage_no',
    p.nc_version as          'p.nc_version',
    p.end_time as            'p.end_time',
    p.trx_product_id as      'p.trx_product_id',
    td.serial_no as          'td.serial_no',
    td.barcode as            'td.barcode',
    td.prod_model_no as      'td.prod_model_no',
    td.pattern_id as         'td.pattern_id',
    td.setup_id as           'td.setup_id',
    td.top_bottom as         'td.top_bottom',
    td.timestamp as          'td.timestamp',
    td.import_flag as        'td.import_flag',
    pph.panel_equipment_id as  'pph.panel_equipment_id',
    pph.equipment_id as        'pph.equipment_id',
    pph.master_placement_id as 'pph.master_placement_id',
    pph.panel_placement_id as  'pph.panel_placement_id',
    pph.timestamp as           'pph.timestamp',
    pph.trx_product_id as      'pph.trx_product_id',
    count(ppd.panel_placement_id) as 'count_ppd.panel_placement_id'
from
    routes r
inner join
    route_layout rl
on
    rl.route_id = r.route_id
inner join
    zones z
on
    z.zone_id = rl.zone_id
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
inner join
    tracking_data td
on
    td.panel_id = p.panel_id
left join
    panel_placement_header pph
on
    pph.equipment_id = zl.equipment_id
and
    pph.panel_equipment_id = p.panel_equipment_id
left join
    panel_placement_details ppd
on
    ppd.panel_placement_id = pph.master_placement_id
where
    r.valid_flag = 't'
and
    z.valid_flag = 't'
and
    z.module_id > 0
-- and
    -- START_TIME <= p.end_time
-- and
    -- p.end_time < END_TIME
group by
    r.route_id,
    r.route_name,
    td.panel_id,
    rl.pos,
    eq.equipment_name,
    eq.equipment_id,
    p.lane_no,
    p.stage_no,
    p.nc_version,
    p.end_time,
    p.trx_product_id,
    td.serial_no,
    td.barcode,
    td.prod_model_no,
    td.pattern_id,
    td.setup_id,
    td.top_bottom,
    td.timestamp,
    td.import_flag,
    pph.panel_equipment_id,
    pph.equipment_id,
    pph.master_placement_id,
    pph.panel_placement_id,
    pph.timestamp,
    pph.trx_product_id
order by
    r.route_id asc,
    td.panel_id asc,
    rl.pos asc,
    p.lane_no asc,
    p.stage_no asc
go
