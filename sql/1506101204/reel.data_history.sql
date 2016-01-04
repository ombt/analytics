-- name name
-- reel_data reel_id
-- reel_data part_no
-- reel_data vendor_no
-- reel_data lot_no
-- reel_data quantity
-- reel_data user_data
-- reel_data reel_barcode
-- reel_data current_quantity
-- reel_data update_time
-- reel_data master_reel_id
-- reel_data create_time
-- reel_data part_class
-- reel_data mcid
-- reel_data material_name
-- reel_data prev_reel_id
-- reel_data next_reel_id
-- reel_data adjusted_current_quantity
-- reel_data tray_quantity
-- reel_data bulk_master_id
-- reel_data is_msd
-- 
-- name name
-- reel_data_history reel_data_history_id
-- reel_data_history reel_id
-- reel_data_history operation_type
-- reel_data_history operation_time
-- reel_data_history operator_id
-- reel_data_history data_source
-- reel_data_history operation_detail

select
    count(*) as 'rdid eq rdhid count'
from
    reel_data rd
inner join
    reel_data_history rdh
on
    rd.reel_id = rdh.reel_id
go

select
    count(*) as 'rdid neq rdhid count'
from
    reel_data rd
where
    not exists ( select * from reel_data_history rdh where rd.reel_id = rdh.reel_id )
go
