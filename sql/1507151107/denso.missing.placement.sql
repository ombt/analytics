
-- + TZ=Europe/Madrid
-- + export TZ
-- + date -d '2015/06/16 04:13:00' +%s
-- 1434420780
-- + date -d '2015/06/16 04:20:00' +%s
-- 1434421200

select 
    r.route_id,
    -- rl.pos,
    ph.equipment_id,
    p.stage_no,
    p.lane_no,
    p.setup_id,
    ph.panel_equipment_id,
    td.serial_no,
    p.nc_version,
    count(pd.panel_placement_id) as 'count_pd_panel_placement_id'
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
    panel_placement_header ph
on
    ph.equipment_id = zl.equipment_id
left join
    panels p
on
    p.panel_equipment_id = ph.panel_equipment_id
left join
    tracking_data td
on
    td.panel_id = p.panel_id
left join
    panel_placement_details pd
on
    pd.panel_placement_id = ph.master_placement_id
where
    r.valid_flag = 't'
and
    r.route_id = 1003
and
    z.valid_flag = 't'
and
    z.module_id > 0
and
    zl.pos = 1
and
    p.end_time >= 1434420780
and
    p.end_time < 1434421200
group by
    r.route_id,
    rl.pos,
    ph.equipment_id,
    p.stage_no,
    p.lane_no,
    p.setup_id,
    ph.panel_equipment_id,
    td.serial_no,
    p.nc_version
order by
    r.route_id asc,
    rl.pos asc,
    ph.equipment_id asc,
    p.stage_no asc,
    p.lane_no asc,
    ph.panel_equipment_id asc,
    td.serial_no asc
go

select 
    r.route_id,
    -- rl.pos,
    ph.equipment_id,
    p.stage_no,
    p.lane_no,
    p.setup_id,
    ph.panel_equipment_id,
    td.serial_no,
    p.nc_version,
    count(ncpd.nc_version) as 'count_ncpd_ref_designators'
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
    panel_placement_header ph
on
    ph.equipment_id = zl.equipment_id
left join
    panels p
on
    p.panel_equipment_id = ph.panel_equipment_id
left join
    tracking_data td
on
    td.panel_id = p.panel_id
left join
    panel_placement_details pd
on
    pd.panel_placement_id = ph.master_placement_id
left join
    nc_placement_detail ncpd
on
    ncpd.nc_version = p.nc_version
where
    r.valid_flag = 't'
and
    r.route_id = 1003
and
    z.valid_flag = 't'
and
    z.module_id > 0
and
    zl.pos = 1
and
    p.end_time >= 1434420780
and
    p.end_time < 1434421200
group by
    r.route_id,
    rl.pos,
    ph.equipment_id,
    p.stage_no,
    p.lane_no,
    p.setup_id,
    ph.panel_equipment_id,
    td.serial_no,
    p.nc_version,
    ncpd.nc_version
having
    count(ncpd.nc_version) = 0
order by
    r.route_id asc,
    rl.pos asc,
    ph.equipment_id asc,
    p.stage_no asc,
    p.lane_no asc,
    ph.panel_equipment_id asc,
    td.serial_no asc
go
