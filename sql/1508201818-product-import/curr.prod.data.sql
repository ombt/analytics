
-- product_run_history product_run_history_id
-- product_run_history equipment_id
-- product_run_history lane_no
-- product_run_history setup_id
-- product_run_history start_time
-- product_run_history end_time

-- product_run_history equipment_id
-- product_run_history lane_no
-- product_run_history setup_id
-- product_run_history start_time
-- product_run_history end_time

-- product_equipment_setup setup_id
-- product_equipment_setup equipment_id
-- product_equipment_setup machine_mode
-- product_equipment_setup double_feeder_flag
-- product_equipment_setup transfer_flag
-- product_equipment_setup pt_file_name
-- product_equipment_setup pt_mc_file_name
-- product_equipment_setup pt_version
-- product_equipment_setup pt_downloaded_flag
-- product_equipment_setup mai_substitute_support
-- product_equipment_setup cycle_time
-- product_equipment_setup pem_source_path
-- product_equipment_setup mount_mode
-- product_equipment_setup lot_comment

-- product_feeders setup_id
-- product_feeders equipment_id
-- product_feeders feeder_no
-- product_feeders slot
-- product_feeders subslot
-- product_feeders part_no
-- product_feeders supply_method
-- product_feeders master_z
-- product_feeders pu_number
-- product_feeders skip_location
-- product_feeders part_polarity

select
    -- r.route_id,
    r.route_name,
    -- rl.pos,
    -- z.zone_id,
    z.zone_name,
    m.equipment_id,
    eq.equipment_name,
    -- prh.product_run_history_id,
    -- prh.equipment_id,
    prh.lane_no,
    prh.setup_id,
    prh.start_time,
    -- prh.end_time,
    -- pf.setup_id,
    -- pf.equipment_id,
    pf.feeder_no,
    pf.slot,
    pf.subslot,
    pf.part_no,
    pf.supply_method,
    -- pf.master_z,
    pf.pu_number
    -- pf.skip_location,
    -- pf.part_polarity
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
    m.equipment_id = zl.equipment_id
inner join
    equipment eq
on
    eq.equipment_id = zl.equipment_id
left join
    product_run_history prh
on
    prh.equipment_id = zl.equipment_id
and
    prh.end_time > 2000000000
left join
    product_feeders pf
on
    pf.setup_id = prh.setup_id
and
    pf.equipment_id = zl.equipment_id
where
    r.valid_flag = 't'
-- and
    -- z.module_id <> -1
order by
    r.route_id asc,
    prh.lane_no asc,
    rl.pos asc
go

