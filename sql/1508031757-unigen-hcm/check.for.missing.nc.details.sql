-- eq_equipment_name	eq_equipment_id	p_nc_version
-- L1-2-CM602-1	1000	7684
-- L2-1-CM602-1	1012	7794
-- L2-1-CM602-1	1012	9093
-- L3-1-CM602-1	1018	7544
-- L4-1-CM402-1	1030	7624
-- L4-1-CM402-1	1030	8397
-- L4-1-CM402-1	1030	8835
-- L2-2-CM602-1	1047	7691
-- L2-2-CM602-1	1047	7822
-- L3-2-CM602-1	1053	7687
-- L3-2-CM602-1	1053	9022

select 
    nc_version, 
    count(nc_version) as count
from
    nc_placement_detail
where
    nc_version in ( 7684, 7794, 9093, 7544, 7624, 8397, 8835, 7691, 7822, 7687, 9022 )
group by
    nc_version
go
