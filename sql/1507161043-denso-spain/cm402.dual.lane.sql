select 
	e.equipment_id,
	e.equipment_name,
	e.equipment_type,
	e.valid_flag,
	m.single_lane_mode
from 
	equipment e, machines m 
where
	m.equipment_id = e.equipment_id 
and
	e.equipment_type = 1 
and 
	m.single_lane_mode = 'F'
go

select * from z_cass_header where 
equipment_id in 
(
select 
	e.equipment_id
from 
	equipment e, machines m 
where
	m.equipment_id = e.equipment_id 
and
	e.equipment_type = 1 
and 
	m.single_lane_mode = 'F'
)
go

select * from z_cass_header_raw where 
equipment_id in 
(
select 
	e.equipment_id
from 
	equipment e, machines m 
where
	m.equipment_id = e.equipment_id 
and
	e.equipment_type = 1 
and 
	m.single_lane_mode = 'F'
)
go

select 
	z.zone_id,
	e.equipment_id,
	e.equipment_name,
	e.equipment_type,
	e.valid_flag,
	m.single_lane_mode,
	z.trace_level
from 
	zones z, 
	zone_layout zlo,
	equipment e,
	machines m
where 
	z.zone_id = zlo.zone_id 
and
	zlo.equipment_id = e.equipment_id
and
	m.equipment_id = e.equipment_id 
and
	e.equipment_type = 1 
and 
	m.single_lane_mode = 'F'
go

