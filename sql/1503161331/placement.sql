select 
    -- top(5000)
    r.route_id as            'r.route_id',
    r.route_name as          'r.route_name',
    rl.pos as                'rl.pos',
    rl.zone_id as            'rl.zone_id',
    z.zone_name as           'z.zone_name',
    z.trace_level as         'z.trace_level',
    z.module_id as           'z.module_id',
    zl.pos as                'zl.pos',
    zl.equipment_id as       'zl.equipment_id',
    sh.equipment_id as       'sh.equipment_id',
    sh.panel_equipment_id as 'sh.panel_equipment_id',
    sh.trx_product_id as     'sh.trx_product_id',
    sh.master_strace_id as   'sh.master_strace_id',
    sh.panel_strace_id as    'sh.panel_strace_id',
    sh.timestamp as          'sh.timestamp',
    p.panel_id as            'p.panel_id',
    p.equipment_id as        'p.equipment_id',
    p.nc_version as          'p.nc_version',
    p.start_time as          'p.start_time',
    p.end_time as            'p.end_time',
    p.panel_equipment_id as  'p.panel_equipment_id',
    p.panel_source as        'p.panel_source',
    p.panel_trace as         'p.panel_trace',
    p.stage_no as            'p.stage_no',
    p.lane_no as             'p.lane_no',
    p.job_id as              'p.job_id',
    p.setup_id as            'p.setup_id',
    p.trx_product_id as      'p.trx_product_id',
    td.serial_no as          'td.serial_no',
    td.barcode as            'td.barcode',
    td.prod_model_no as      'td.prod_model_no',
    td.panel_id as           'td.panel_id',
    td.pattern_id as         'td.pattern_id',
    td.setup_id as           'td.setup_id',
    td.top_bottom as         'td.top_bottom',
    td.timestamp as          'td.timestamp',
    td.import_flag as        'td.import_flag'
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
left join
    zone_layout zl
on
    zl.zone_id = rl.zone_id
left join
    panel_strace_header sh
on
    sh.equipment_id = zl.equipment_id
left join
    panels p
on
    p.panel_equipment_id = sh.panel_equipment_id
left join
    tracking_data td
on
    td.panel_id = p.panel_id
where
    r.valid_flag = 'T'
and
    len(r.lnb_host_name) > 0
and
    z.valid_flag = 'T'
and
    z.module_id > 0
order by
    r.route_id asc,
    rl.pos asc,
    sh.equipment_id asc,
    td.serial_no asc,
    p.stage_no asc,
    p.lane_no asc,
    sh.panel_equipment_id asc
go
EOF
