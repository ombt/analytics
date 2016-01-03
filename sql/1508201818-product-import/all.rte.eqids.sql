select
    r.route_id,
    r.route_name,
    rl.pos,
    z.zone_id,
    z.zone_name,
    z.trace_level,
    m.equipment_id,
    m.spc,
    eq.equipment_name
from
    routes r
inner join
    route_layout rl
on
    r.route_id = rl.route_id
inner join
    zones z
on
    z.zone_id = rl.zone_id
inner join
    zone_layout zl
on
    zl.zone_id = z.zone_id
inner join
    machines m
on
    m.equipment_id = zl.equipment_id
inner join
    equipment eq
on
    eq.equipment_id = m.equipment_id
where
    r.valid_flag = 'T'
-- and
    -- z.module_id <> -1
order by
    r.route_id asc,
    rl.pos asc
go

