
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
    -- i._p,
    i._cid,
    i._timestamp,
    i._crc,
    i._c2d,
    i._recipename,
    i._mid,
    -- p._filename_id,
    p._p,
    -- p._cmp,
    p._sc,
    p._pid,
    p._fc,
    -- c._filename_id,
    c._cmp,
    -- c._defect,
    c._cc,
    c._ref,
    c._type,
    -- d._filename_id,
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
    p._p = i._p
left join
    aoi.cmp c
on
    c._filename_id = ftf._filename_id
and
    p._cmp > 0
and
    c._cmp = p._cmp
left join
    aoi.defect d
on
    d._filename_id = ftf._filename_id
and
    c._defect > 0
and
    d._defect = c._defect
order by
    ftf._filename_timestamp asc
;

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
    -- i._p,
    i._cid,
    i._timestamp,
    i._crc,
    i._c2d,
    i._recipename,
    i._mid,
    -- p._filename_id,
    p._p,
    -- p._cmp,
    p._sc,
    p._pid,
    p._fc,
    -- c._filename_id,
    c._cmp,
    -- c._defect,
    c._cc,
    c._ref,
    c._type,
    -- d._filename_id,
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
    p._p = i._p
inner join
    aoi.cmp c
on
    c._filename_id = ftf._filename_id
and
    p._cmp > 0
and
    c._cmp = p._cmp
inner join
    aoi.defect d
on
    d._filename_id = ftf._filename_id
and
    c._defect > 0
and
    d._defect = c._defect
order by
    ftf._filename_timestamp asc
;

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
    -- i._p,
    i._cid,
    i._timestamp,
    i._crc,
    i._c2d,
    i._recipename,
    i._mid,
    -- p._filename_id,
    p._p,
    p._cmp,
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
    p._p = i._p
and
    p._cmp <= 0
order by
    ftf._filename_timestamp asc
;

