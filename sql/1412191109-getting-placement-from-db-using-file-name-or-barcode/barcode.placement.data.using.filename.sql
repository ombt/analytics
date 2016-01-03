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
    panel_placement_header pph
inner join 
    panels p
on
    pph.panel_equipment_id = p.panel_equipment_id
and
    pph.equipment_id = p.equipment_id
inner join 
    tracking_data td
on
    td.panel_id = p.panel_id
right join 
    panel_placement_details ppd
on
    ppd.panel_placement_id = pph.master_placement_id
where
    pph.trx_product_id like '%1417462809-0000026227%'
or
    pph.trx_product_id like '%1417462830-0000026224%'
order by
    ppd.panel_placement_id asc,
    ppd.z_num asc,
    ppd.pu_num asc,
    ppd.part_no asc,
    ppd.reel_id asc
go

select 
    count(*)
from
    panel_placement_header pph
inner join 
    panels p
on
    pph.panel_equipment_id = p.panel_equipment_id
and
    pph.equipment_id = p.equipment_id
inner join 
    tracking_data td
on
    td.panel_id = p.panel_id
right join 
    panel_placement_details ppd
on
    ppd.panel_placement_id = pph.master_placement_id
where
    pph.trx_product_id like '%1417462809-0000026227%'
or
    pph.trx_product_id like '%1417462830-0000026224%'
go

