print 'routes and machines ...'
go

select
    r.route_id,
    r.route_name,
    rl.pos,
    zl.equipment_id,
    eq.equipment_name,
    z.trace_level
from
    routes r
inner join
    route_layout rl
on
    rl.route_id = r.route_id
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
    m.equipment_id = zl.equipment_id
inner join
    equipment eq
on
    eq.equipment_id = m.equipment_id
where
    r.valid_flag = 'T'
order by
    r.route_id asc,
    rl.pos asc
go

