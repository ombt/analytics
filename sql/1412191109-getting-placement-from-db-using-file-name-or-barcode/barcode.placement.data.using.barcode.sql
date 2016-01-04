select 
    td.serial_no,
    td.barcode,
    p.nc_version,
    p.stage_no,
    p.lane_no,
    p.trx_product_id,
    ppd.pattern_no,
    ppd.z_num,
    ppd.pu_num,
    ppd.ref_designator
from
    tracking_data td
inner join 
    panels p
on
    td.panel_id = p.panel_id
inner join 
    panel_placement_header pph
on
    pph.panel_equipment_id = p.panel_equipment_id
and
    pph.equipment_id = p.equipment_id
inner join 
    panel_placement_details ppd
on
    ppd.panel_placement_id = pph.master_placement_id
where
    td.barcode = 'GG1547-19-T-00809569'
order by
    ppd.panel_placement_id asc,
    ppd.z_num asc,
    ppd.pu_num asc,
    ppd.part_no asc,
    ppd.reel_id asc
go

