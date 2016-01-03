-- 
-- zones zone_id
-- zones zone_name
-- zones host_name
-- zones control_mode
-- zones control_level
-- zones trace_level
-- zones queue_size
-- zones zone_type
-- zones valid_flag
-- zones zone_barcode
-- zones mgmt_mode
-- zones product_mode
-- zones program_mode
-- zones zone_startup
-- zones pin_adjust_mode
-- zones module_id
-- zones ms_zone_id
-- zones active_status
-- zones module_type
-- zones operational_level
-- zones allow_delete
-- 
-- select
--     z.zone_id,
--     z.zone_name,
--     z.host_name,
--     z.control_mode,
--     z.control_level,
--     z.trace_level,
--     z.queue_size,
--     z.zone_type,
--     z.valid_flag,
--     z.zone_barcode,
--     z.mgmt_mode,
--     z.product_mode,
--     z.program_mode,
--     z.zone_startup,
--     z.pin_adjust_mode,
--     z.module_id,
--     z.ms_zone_id,
--     z.active_status,
--     z.module_type,
--     z.operational_level,
--     z.allow_delete
-- from
--     zones z
-- go

select
    z.zone_id,
    z.zone_name,
    z.host_name,
    -- z.control_mode,
    -- z.control_level,
    -- z.trace_level,
    -- z.queue_size,
    z.zone_type,
    z.valid_flag,
    -- z.zone_barcode,
    -- z.mgmt_mode,
    -- z.product_mode,
    -- z.program_mode,
    -- z.zone_startup,
    -- z.pin_adjust_mode,
    z.module_id,
    z.ms_zone_id,
    z.active_status,
    z.module_type
    --
    -- z.module_type,
    -- z.operational_level,
    -- z.allow_delete
from
    zones z
where
    z.zone_startup = 'T'
and
    z.valid_flag = 'T'
and
    z.module_id <> -1
go
-- 
select
    z.zone_id,
    z.zone_name,
    z.host_name,
    -- z.control_mode,
    -- z.control_level,
    -- z.trace_level,
    -- z.queue_size,
    -- z.zone_type,
    z.valid_flag,
    -- z.zone_barcode,
    -- z.mgmt_mode,
    -- z.product_mode,
    -- z.program_mode,
    -- z.zone_startup,
    -- z.pin_adjust_mode,
    -- z.module_id,
    -- z.ms_zone_id,
    z.active_status,
    z.module_type
    --
    -- z.module_type,
    -- z.operational_level,
    -- z.allow_delete
from
    zones z
where
    z.zone_startup = 'T'
and
    z.valid_flag = 'T'
and
    z.module_id <> -1
go
