-- 1417501145-0000026477-+03EA547D58BAE6+-01-00-4803.mlg
-- 1417501289-0000026477-+03EA547D58BAE6+-02-00-4803.mlg

select 
    p.stage_no,
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
or
    ppd.panel_placement_id = pph.panel_placement_id
where
    pph.trx_product_id like '%+03EA547D58BAE6+%'
group by
    p.stage_no
order by
    p.stage_no asc
go

