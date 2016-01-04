
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

-- nc_summary setup_id
-- nc_summary equipment_id
-- nc_summary nc_version
-- nc_summary tva
-- nc_summary double_feeder_flag
-- nc_summary glue_total
-- nc_summary solder_total

-- nc_detail nc_version
-- nc_detail cassette
-- nc_detail slot
-- nc_detail subslot
-- nc_detail tva

-- nc_placement_detail nc_placement_id
-- nc_placement_detail idnum
-- nc_placement_detail ref_designator
-- nc_placement_detail nc_version
-- nc_placement_detail part_name
-- nc_placement_detail pattern_number

select
    -- r.route_id as r_route_id,
    r.route_name as r_route_name,
    -- rl.pos as rl_pos,
    -- z.zone_id as z_zone_id,
    z.zone_name as z_zone_name,
    -- m.equipment_id as m_equipment_id,
    eq.equipment_name as eq_equipment_name,
    -- prh.product_run_history_id as prh_product_run_history_id,
    -- prh.equipment_id as prh_equipment_id,
    prh.lane_no as prh_lane_no,
    prh.setup_id as prh_setup_id,
    prh.start_time as prh_start_time,
    -- prh.end_time,
    ncs.setup_id as ncs_setup_id,
    ncs.equipment_id as ncs_equipment_id,
    ncs.nc_version as ncs_nc_version,
    ncs.tva as ncs_tva,
    ncs.double_feeder_flag as ncs_double_feeder_flag,
    ncs.glue_total as ncs_glue_total,
    ncs.solder_total as ncs_solder_total,
    ncd.nc_version as ncd_nc_version,
    ncd.cassette as ncd_cassette,
    ncd.slot as ncd_slot,
    ncd.subslot as ncd_subslot,
    ncd.tva as ncd_tva,
    -- pf.setup_id as pf_setup_id,
    -- pf.equipment_id as pf_equipment_id,
    pf.feeder_no as pf_feeder_no,
    -- pf.slot as pf_slot,
    -- pf.subslot as pf_subslot,
    pf.part_no as pf_part_no,
    pf.supply_method as pf_supply_method,
    -- pf.master_z as pf_master_z,
    pf.pu_number as pf_pu_number
    -- pf.skip_location as pf_skip_location,
    -- pf.part_polarity as pf_part_polarity
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
    nc_summary ncs
on
    ncs.setup_id = prh.setup_id
and
    ncs.equipment_id = zl.equipment_id
left join
    nc_detail ncd
on
    ncd.nc_version = ncs.nc_version
left join
    product_feeders pf
on
    pf.setup_id = prh.setup_id
and
    pf.equipment_id = zl.equipment_id
and
    pf.slot = ncd.slot
and
    pf.subslot = ncd.subslot
where
    r.valid_flag = 't'
-- and
    -- z.module_id <> -1
order by
    r.route_id asc,
    prh.lane_no asc,
    rl.pos asc
go


