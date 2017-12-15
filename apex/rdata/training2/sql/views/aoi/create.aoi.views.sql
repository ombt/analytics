
create view aoi.file_data_view
as
select
    ftf._filename,
    ftf._filename_type,
    ftf._filename_timestamp,
    ftf._filename_route,
    ftf._filename_id,
    -- afd._filename_id,
    afd._aoi_pcbid,
    afd._date_time
from
    aoi.filename_to_fid ftf
inner join
    aoi.aoi_filename_data afd
on
    afd._filename_id = ftf._filename_id
order by
    ftf._filename_timestamp asc
;

create view aoi.all_view
as
select
    ftf._filename,
    ftf._filename_type,
    ftf._filename_timestamp,
    ftf._filename_route,
    ftf._filename_id,
    -- afd._filename_id,
    afd._aoi_pcbid,
    afd._date_time,
    -- i._filename_id,
    i._cid,
    i._timestamp,
    i._crc,
    i._c2d,
    i._recipename,
    i._mid,
    -- p._filename_id,
    p._p,
    p._cmp as cmp_idx,
    p._sc,
    p._pid,
    p._fc,
    -- c._filename_id,
    -- c._p,
    c._cmp,
    c._cc,
    c._ref,
    c._type,
    -- d._filename_id,
    -- d._cmp,
    d._defect,
    d._insp_type,
    d._lead_id
from
    aoi.filename_to_fid ftf
inner join
    aoi.aoi_filename_data afd
on
    afd._filename_id = ftf._filename_id
inner join
    aoi.insp i
on
    i._filename_id = ftf._filename_id
inner join
    aoi.p p
on
    p._filename_id = ftf._filename_id
left join
    aoi.cmp c
on
    c._filename_id = ftf._filename_id
and
    c._p = p._p
left join
    aoi.defect d
on
    d._filename_id = ftf._filename_id
and
    d._cmp = c._cmp
order by
    ftf._filename_timestamp asc
;

create view aoi.all_no_view
as
select
    ftf._filename,
    ftf._filename_type,
    ftf._filename_timestamp,
    ftf._filename_route,
    ftf._filename_id,
    -- afd._filename_id,
    afd._aoi_pcbid,
    afd._date_time,
    -- i._filename_id,
    i._cid,
    i._timestamp,
    i._crc,
    i._c2d,
    i._recipename,
    i._mid,
    -- p._filename_id,
    p._p,
    p._cmp as cmp_idx,
    p._sc,
    p._pid,
    p._fc,
    -- c._filename_id,
    -- c._p,
    c._cmp,
    c._cc,
    c._ref,
    c._type,
    -- d._filename_id,
    -- d._cmp,
    d._defect,
    d._insp_type,
    d._lead_id
from
    aoi.filename_to_fid ftf
inner join
    aoi.aoi_filename_data afd
on
    afd._filename_id = ftf._filename_id
inner join
    aoi.insp i
on
    i._filename_id = ftf._filename_id
inner join
    aoi.p p
on
    p._filename_id = ftf._filename_id
left join
    aoi.cmp c
on
    c._filename_id = ftf._filename_id
and
    c._p = p._p
left join
    aoi.defect d
on
    d._filename_id = ftf._filename_id
and
    d._cmp = c._cmp
-- no - no ordering
-- order by
    -- ftf._filename_timestamp asc
;

create view aoi.no_good_view
as
select
    ftf._filename,
    ftf._filename_type,
    ftf._filename_timestamp,
    ftf._filename_route,
    ftf._filename_id,
    -- afd._filename_id,
    afd._aoi_pcbid,
    afd._date_time,
    -- i._filename_id,
    i._cid,
    i._timestamp,
    i._crc,
    i._c2d,
    i._recipename,
    i._mid,
    -- p._filename_id,
    p._p,
    p._cmp as cmp_idx,
    p._sc,
    p._pid,
    p._fc,
    -- c._filename_id,
    -- c._p,
    c._cmp,
    c._cc,
    c._ref,
    c._type,
    -- d._filename_id,
    -- d._cmp,
    d._defect,
    d._insp_type,
    d._lead_id
from
    aoi.filename_to_fid ftf
inner join
    aoi.aoi_filename_data afd
on
    afd._filename_id = ftf._filename_id
inner join
    aoi.insp i
on
    i._filename_id = ftf._filename_id
inner join
    aoi.p p
on
    p._filename_id = ftf._filename_id
and
    p._cmp > 0
inner join
    aoi.cmp c
on
    c._filename_id = ftf._filename_id
and
    c._p = p._p
inner join
    aoi.defect d
on
    d._filename_id = ftf._filename_id
and
    d._cmp = c._cmp
order by
    ftf._filename_timestamp asc
;

create view aoi.no_good_no_view
as
select
    ftf._filename,
    ftf._filename_type,
    ftf._filename_timestamp,
    ftf._filename_route,
    ftf._filename_id,
    -- afd._filename_id,
    afd._aoi_pcbid,
    afd._date_time,
    -- i._filename_id,
    i._cid,
    i._timestamp,
    i._crc,
    i._c2d,
    i._recipename,
    i._mid,
    -- p._filename_id,
    p._p,
    p._cmp as cmp_idx,
    p._sc,
    p._pid,
    p._fc,
    -- c._filename_id,
    -- c._p,
    c._cmp,
    c._cc,
    c._ref,
    c._type,
    -- d._filename_id,
    -- d._cmp,
    d._defect,
    d._insp_type,
    d._lead_id
from
    aoi.filename_to_fid ftf
inner join
    aoi.aoi_filename_data afd
on
    afd._filename_id = ftf._filename_id
inner join
    aoi.insp i
on
    i._filename_id = ftf._filename_id
inner join
    aoi.p p
on
    p._filename_id = ftf._filename_id
and
    p._cmp > 0
inner join
    aoi.cmp c
on
    c._filename_id = ftf._filename_id
and
    c._p = p._p
inner join
    aoi.defect d
on
    d._filename_id = ftf._filename_id
and
    d._cmp = c._cmp
-- no - no ordering
-- order by
    -- ftf._filename_timestamp asc
;

create view aoi.good_view
as
select
    ftf._filename,
    ftf._filename_type,
    ftf._filename_timestamp,
    ftf._filename_route,
    ftf._filename_id,
    -- afd._filename_id,
    afd._aoi_pcbid,
    afd._date_time,
    -- i._filename_id,
    i._cid,
    i._timestamp,
    i._crc,
    i._c2d,
    i._recipename,
    i._mid,
    -- p._filename_id,
    p._p,
    p._cmp as cmp_idx,
    p._sc,
    p._pid,
    p._fc
from
    aoi.filename_to_fid ftf
inner join
    aoi.aoi_filename_data afd
on
    afd._filename_id = ftf._filename_id
inner join
    aoi.insp i
on
    i._filename_id = ftf._filename_id
inner join
    aoi.p p
on
    p._filename_id = ftf._filename_id
and
    p._cmp < 0
order by
    ftf._filename_timestamp asc
;

create view aoi.good_no_view
as
select
    ftf._filename,
    ftf._filename_type,
    ftf._filename_timestamp,
    ftf._filename_route,
    ftf._filename_id,
    -- afd._filename_id,
    afd._aoi_pcbid,
    afd._date_time,
    -- i._filename_id,
    i._cid,
    i._timestamp,
    i._crc,
    i._c2d,
    i._recipename,
    i._mid,
    -- p._filename_id,
    p._p,
    p._cmp as cmp_idx,
    p._sc,
    p._pid,
    p._fc
from
    aoi.filename_to_fid ftf
inner join
    aoi.aoi_filename_data afd
on
    afd._filename_id = ftf._filename_id
inner join
    aoi.insp i
on
    i._filename_id = ftf._filename_id
inner join
    aoi.p p
on
    p._filename_id = ftf._filename_id
and
    p._cmp < 0
-- no - no ordering
-- order by
    -- ftf._filename_timestamp asc
;

create view aoi.pcb_status_view
as
select
    ftf._filename,
    ftf._filename_type,
    ftf._filename_timestamp,
    ftf._filename_route,
    ftf._filename_id,
    -- afd._filename_id,
    afd._aoi_pcbid,
    afd._date_time,
    -- i._filename_id,
    i._cid,
    i._timestamp,
    i._crc,
    i._c2d,
    i._recipename,
    i._mid,
    -- p._filename_id,
    p._p,
    p._cmp as cmp_idx,
    p._sc,
    p._pid,
    p._fc
from
    aoi.filename_to_fid ftf
inner join
    aoi.aoi_filename_data afd
on
    afd._filename_id = ftf._filename_id
inner join
    aoi.insp i
on
    i._filename_id = ftf._filename_id
inner join
    aoi.p p
on
    p._filename_id = ftf._filename_id
;

