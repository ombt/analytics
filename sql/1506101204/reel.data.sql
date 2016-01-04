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

select
    rd.reel_id,
    count(rd.reel_id) as cnt_rid
from
    reel_data rd
group by
    rd.reel_id
having
    count(rd.reel_id) > 1
go
