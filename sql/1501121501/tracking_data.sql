--
-- tracking_data serial_no
-- tracking_data prod_model_no
-- tracking_data panel_id
-- tracking_data pattern_id
-- tracking_data barcode
-- tracking_data setup_id
-- tracking_data top_bottom
-- tracking_data timestamp
-- tracking_data import_flag
--

select
    td.serial_no,
    td.prod_model_no,
    td.panel_id,
    td.pattern_id,
    td.barcode,
    td.setup_id,
    td.top_bottom,
    td.timestamp,
    td.import_flag
from
    tracking_data td
order by
    td.panel_id
go

