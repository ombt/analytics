-- value_descriptions value_type
-- value_descriptions value_id
-- value_descriptions value_desc

-- machine_models model_number
-- machine_models mach_type
-- machine_models mod_number
-- machine_models mod_name
-- machine_models carriage_type
-- machine_models description
-- machine_models cmd_flags
-- machine_models data_flags
-- machine_models mgmt_flags
-- machine_models file_flags
-- machine_models dir_flags
-- machine_models num_files
-- machine_models del_flags
-- machine_models machine_vendor
-- machine_models num_stages
-- machine_models simulation_mode
-- machine_models simulation_mode_config

--
-- value type = 1 is for carriage type
-- value type = 5 is for machine family
--
select
    vd.value_type as machine_models,
    vd.value_id as machine_model_id,
    vd.value_desc as machine_name,
    round(vd.value_id/1000,0,1)*1000 as machine_family_id,
    -- mm.model_number,
    -- mm.mach_type,
    -- mm.mod_number,
    -- mm.mod_name,
    coalesce(mm.carriage_type, -1) mm_carriage_type,
    -- mm.description,
    -- mm.cmd_flags,
    -- mm.data_flags,
    -- mm.mgmt_flags,
    -- mm.file_flags,
    -- mm.dir_flags,
    -- mm.num_files,
    -- mm.del_flags,
    -- mm.machine_vendor,
    -- mm.num_stages,
    -- mm.simulation_mode,
    -- mm.simulation_mode_config
    vd2.value_type as carriage_types,
    vd2.value_id as carriage_type,
    vd2.value_desc as carriage_name
from
    value_descriptions vd
left join
    machine_models mm
on
    mm.mach_type = round(vd.value_id/1000,0,1)*1000
left join
    value_descriptions vd2
on
    vd2.value_id = mm.carriage_type
where
    vd.value_type = 5
and
    vd2.value_type = 1
go

