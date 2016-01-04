select
    r.route_id,
    r.route_name,
    rl.pos,
    z.zone_id,
    z.zone_name,
    m.equipment_id,
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
    rl.zone_id = z.zone_id
inner join
    zone_layout zl
on
    z.zone_id = zl.zone_id
inner join
    machines m
on
    zl.equipment_id = m.equipment_id
inner join
    equipment eq
on
    eq.equipment_id = m.equipment_id
where
    r.valid_flag = 'T'
and
    z.module_id <> -1
order by
    r.route_id asc,
    rl.pos asc
go

