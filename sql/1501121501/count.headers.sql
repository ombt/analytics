
-- panel_placement_header panel_equipment_id 
-- panel_placement_header equipment_id
-- panel_placement_header master_placement_id
-- panel_placement_header panel_placement_id
-- panel_placement_header timestamp
-- panel_placement_header trx_product_id

-- panel_placement_details panel_placement_id
-- panel_placement_details reel_id
-- panel_placement_details nc_placement_id
-- panel_placement_details pattern_no
-- panel_placement_details z_num
-- panel_placement_details pu_num
-- panel_placement_details part_no
-- panel_placement_details custom_area1
-- panel_placement_details custom_area2
-- panel_placement_details custom_area3
-- panel_placement_details custom_area4
-- panel_placement_details ref_designator

-- select 
--     panel_equipment_id,
--     equipment_id,
--     master_placement_id,
--     panel_placement_id,
--     timestamp,
--     trx_product_id
-- from
--     panel_placement_header
-- where
--     trx_product_id like '%1417462809-0000026227%'
--     or
--     trx_product_id like '%1417462830-0000026224%'
-- go
-- 
-- select 
--     panel_placement_id,
--     z_num,
--     pu_num,
--     part_no,
--     reel_id,
--     nc_placement_id,
--     pattern_no,
--     custom_area1,
--     custom_area2,
--     custom_area3,
--     custom_area4,
--     ref_designator
-- from
--     panel_placement_details
-- where
--     panel_placement_id in ( 1085935, 1085964, 1085967 )
-- order by
--     panel_placement_id asc,
--     z_num asc,
--     pu_num asc,
--     part_no asc,
--     reel_id asc
-- go
-- 
-- --
-- -- panel_placement_header panel_equipment_id 
-- -- panel_placement_header equipment_id 
-- -- panel_placement_header master_placement_id 
-- -- panel_placement_header panel_placement_id 
-- -- panel_placement_header timestamp 
-- -- panel_placement_header trx_product_id 
-- -- 
-- -- 
-- -- panels panel_id
-- -- panels equipment_id
-- -- panels nc_version
-- -- panels start_time
-- -- panels end_time
-- -- panels panel_equipment_id
-- -- panels panel_source
-- -- panels panel_trace
-- -- panels stage_no
-- -- panels lane_no
-- -- panels job_id
-- -- panels setup_id
-- -- panels trx_product_id
-- -- 
-- 
-- -- select
-- --     p.panel_id,
-- --     p.equipment_id,
-- --     p.nc_version,
-- --     p.start_time,
-- --     p.end_time,
-- --     p.panel_equipment_id,
-- --     p.panel_source,
-- --     p.panel_trace,
-- --     p.stage_no,
-- --     p.lane_no,
-- --     p.job_id,
-- --     p.setup_id,
-- --     p.trx_product_id
-- -- from
-- --     panels p
-- -- where
-- --     p.trx_product_id like '1417501289-0000026477-+03EA547D58BAE6+-02-00-4803'
-- -- or
-- --     p.trx_product_id like '1417501145-0000026477-+03EA547D58BAE6+-01-00-4803'
-- 
-- select 
--     pph.panel_equipment_id,
--     pph.equipment_id,
--     pph.master_placement_id,
--     pph.panel_placement_id,
--     pph.timestamp,
--     pph.trx_product_id
-- from
--     panel_placement_header pph
-- where
--     pph.trx_product_id like '1417501289-0000026477-+03EA547D58BAE6+-02-00-4803'
-- or
--     pph.trx_product_id like '1417501145-0000026477-+03EA547D58BAE6+-01-00-4803'
-- go
-- 
-- select 
--     pph.panel_equipment_id,
--     pph.equipment_id,
--     pph.master_placement_id,
--     pph.panel_placement_id,
--     pph.timestamp,
--     pph.trx_product_id
-- from
--     panel_placement_header pph
-- where
--     pph.trx_product_id like '1417501289-0000026477-%'
-- or
--     pph.trx_product_id like '1417501145-0000026477-%'
-- go
-- 
-- select 
--     pph.panel_equipment_id,
--     pph.equipment_id,
--     pph.master_placement_id,
--     pph.panel_placement_id,
--     pph.timestamp,
--     pph.trx_product_id
-- from
--     panel_placement_header pph
-- where
--     pph.trx_product_id like '%1417501289-%'
-- or
--     pph.trx_product_id like '%1417501145-%'
-- go
-- 
-- select 
--     count(*)
-- from
--     panel_placement_details ppd
-- inner join
--     panel_placement_header pph
-- on
--     ppd.panel_placement_id = pph.master_placement_id
-- where
--     pph.trx_product_id like '1417501289-0000026477-+03EA547D58BAE6+-02-00-4803'
-- or
--     pph.trx_product_id like '1417501145-0000026477-+03EA547D58BAE6+-01-00-4803'
-- go
-- 
-- select 
--     count(*)
-- from
--     panel_placement_details ppd
-- inner join
--     panel_placement_header pph
-- on
--     ppd.panel_placement_id = pph.master_placement_id
-- where
--     pph.trx_product_id like '1417501289-0000026477-%'
-- or
--     pph.trx_product_id like '1417501145-0000026477-%'
-- go
-- 
-- select 
--     count(*)
-- from
--     panel_placement_details ppd
-- inner join
--     panel_placement_header pph
-- on
--     ppd.panel_placement_id = pph.master_placement_id
-- where
--     pph.trx_product_id like '%1417501289-%'
-- or
--     pph.trx_product_id like '%1417501145-%'
-- go
-- 
-- -- 1417501145-0000026477-+03EA547D58BAE6+-01-00-4803.mlg
-- -- 1417501289-0000026477-+03EA547D58BAE6+-02-00-4803.mlg
-- -- 
-- -- panels panel_id
-- -- panels equipment_id
-- -- panels nc_version
-- -- panels start_time
-- -- panels end_time
-- -- panels panel_equipment_id
-- -- panels panel_source
-- -- panels panel_trace
-- -- panels stage_no
-- -- panels lane_no
-- -- panels job_id
-- -- panels setup_id
-- -- panels trx_product_id
-- -- 
-- select
--     p.panel_id,
--     p.equipment_id,
--     p.nc_version,
--     p.start_time,
--     p.end_time,
--     p.panel_equipment_id,
--     p.panel_source,
--     p.panel_trace,
--     p.stage_no,
--     p.lane_no,
--     p.job_id,
--     p.setup_id,
--     p.trx_product_id
-- from
--     panels p
-- where
--     p.trx_product_id like '1417501145-0000026477-+03EA547D58BAE6+%'
-- or
--     p.trx_product_id like '1417501289-0000026477-+03EA547D58BAE6+%'

select 
    count(*) as 'slave counts'
from
    panel_placement_header pph
where
    pph.panel_placement_id <> pph.master_placement_id
go

select 
    count(*) as 'master counts'
from
    panel_placement_header pph
where
    pph.panel_placement_id = pph.master_placement_id
go
