--            Table "aoi.filename_to_fid"
--        Column        |     Type      | Modifiers 
-- ---------------------+---------------+-----------
--  _filename           | text          | 
--  _filename_type      | text          | 
--  _filename_timestamp | bigint        | 
--  _filename_route     | text          | 
--  _filename_id        | numeric(30,0) | 
-- 
-- 
--       Table "aoi.aoi_filename_data"
--     Column    |     Type      | Modifiers 
-- --------------+---------------+-----------
--  _filename_id | numeric(30,0) | 
--  _aoi_pcbid   | text          | 
--  _date_time   | text          | 
-- 
--              Table "aoi.insp"
--     Column    |     Type      | Modifiers 
-- --------------+---------------+-----------
--  _filename_id | numeric(30,0) | 
--  _cid         | text          | 
--  _timestamp   | text          | 
--  _crc         | text          | 
--  _c2d         | text          | 
--  _recipename  | text          | 
--  _mid         | text          | 
-- 
--               Table "aoi.p"
--     Column    |     Type      | Modifiers 
-- --------------+---------------+-----------
--  _filename_id | numeric(30,0) | 
--  _p           | integer       | 
--  _sc          | text          | 
--  _pid         | text          | 
--  _fc          | text          | 
--              Table "aoi.cmp"
--     Column    |     Type      | Modifiers 
-- --------------+---------------+-----------
--  _filename_id | numeric(30,0) | 
--  _p           | integer       | 
--  _cmp         | integer       | 
--  _cc          | text          | 
--  _ref         | text          | 
--  _type        | text          | 
-- 
--             Table "aoi.defect"
--     Column    |     Type      | Modifiers 
-- --------------+---------------+-----------
--  _filename_id | numeric(30,0) | 
--  _cmp         | integer       | 
--  _defect      | integer       | 
--  _insp_type   | text          | 
--  _lead_id     | text          | 
-- 

-- select
--     ftf._filename,
--     ftf._filename_type,
--     ftf._filename_timestamp,
--     ftf._filename_route,
--     ftf._filename_id,
--     -- afd._filename_id,
--     afd._aoi_pcbid,
--     afd._date_time
-- from
--     aoi.filename_to_fid ftf
-- inner join
--     aoi.aoi_filename_data afd
-- on
--     afd._filename_id = ftf._filename_id
-- order by
--     ftf._filename_timestamp asc
-- ;
-- 
-- select
--     ftf._filename,
--     ftf._filename_type,
--     ftf._filename_timestamp,
--     ftf._filename_route,
--     ftf._filename_id,
--     afd._filename_id,
--     afd._aoi_pcbid,
--     afd._date_time,
--     i._filename_id,
--     i._p,
--     i._cid,
--     i._timestamp,
--     i._crc,
--     i._c2d,
--     i._recipename,
--     i._mid,
--     p._filename_id,
--     p._p,
--     p._cmp,
--     p._sc,
--     p._pid,
--     p._fc,
--     c._filename_id,
--     c._cmp,
--     c._defect,
--     c._cc,
--     c._ref,
--     c._type,
--     d._filename_id,
--     d._defect,
--     d._insp_type,
--     d._lead_id
-- from
--     aoi.filename_to_fid ftf
-- inner join
--     aoi.aoi_filename_data afd
-- on
--     afd._filename_id = ftf._filename_id
-- inner join
--     aoi.insp i
-- on
--     i._filename_id = ftf._filename_id
-- inner join
--     aoi.p p
-- on
--     p._filename_id = ftf._filename_id
-- and
--     p._p = i._p
-- left join
--     aoi.cmp c
-- on
--     c._filename_id = ftf._filename_id
-- and
--     p._cmp > 0
-- and
--     c._cmp = p._cmp
-- left join
--     aoi.defect d
-- on
--     d._filename_id = ftf._filename_id
-- and
--     c._defect > 0
-- and
--     d._defect = c._defect
-- order by
--     ftf._filename_timestamp asc
-- ;
-- 
-- select
--     ftf._filename,
--     ftf._filename_type,
--     ftf._filename_timestamp,
--     ftf._filename_route,
--     ftf._filename_id,
--     -- afd._filename_id,
--     afd._aoi_pcbid,
--     afd._date_time,
--     -- i._filename_id,
--     -- i._p,
--     i._cid,
--     i._timestamp,
--     i._crc,
--     i._c2d,
--     i._recipename,
--     i._mid,
--     -- p._filename_id,
--     p._p,
--     -- p._cmp,
--     p._sc,
--     p._pid,
--     p._fc,
--     -- c._filename_id,
--     c._cmp,
--     -- c._defect,
--     c._cc,
--     c._ref,
--     c._type,
--     -- d._filename_id,
--     d._defect,
--     d._insp_type,
--     d._lead_id
-- from
--     aoi.filename_to_fid ftf
-- inner join
--     aoi.aoi_filename_data afd
-- on
--     afd._filename_id = ftf._filename_id
-- inner join
--     aoi.insp i
-- on
--     i._filename_id = ftf._filename_id
-- inner join
--     aoi.p p
-- on
--     p._filename_id = ftf._filename_id
-- and
--     p._p = i._p
-- inner join
--     aoi.cmp c
-- on
--     c._filename_id = ftf._filename_id
-- and
--     p._cmp > 0
-- and
--     c._cmp = p._cmp
-- inner join
--     aoi.defect d
-- on
--     d._filename_id = ftf._filename_id
-- and
--     c._defect > 0
-- and
--     d._defect = c._defect
-- order by
--     ftf._filename_timestamp asc
-- ;
-- 
-- select
--     ftf._filename,
--     ftf._filename_type,
--     ftf._filename_timestamp,
--     ftf._filename_route,
--     ftf._filename_id,
--     -- afd._filename_id,
--     afd._aoi_pcbid,
--     afd._date_time,
--     -- i._filename_id,
--     -- i._p,
--     i._cid,
--     i._timestamp,
--     i._crc,
--     i._c2d,
--     i._recipename,
--     i._mid,
--     -- p._filename_id,
--     p._p,
--     p._cmp,
--     p._sc,
--     p._pid,
--     p._fc
-- from
--     aoi.filename_to_fid ftf
-- inner join
--     aoi.aoi_filename_data afd
-- on
--     afd._filename_id = ftf._filename_id
-- inner join
--     aoi.insp i
-- on
--     i._filename_id = ftf._filename_id
-- inner join
--     aoi.p p
-- on
--     p._filename_id = ftf._filename_id
-- and
--     p._p = i._p
-- and
--     p._cmp <= 0
-- order by
--     ftf._filename_timestamp asc
-- ;

select
    ftf._filename,
    ftf._filename_type,
    ftf._filename_timestamp,
    ftf._filename_route,
    ftf._filename_id,

    afd._filename_id,
    afd._aoi_pcbid,
    afd._date_time,

    i._filename_id,
    i._cid,
    i._timestamp,
    i._crc,
    i._c2d,
    i._recipename,
    i._mid,

    p._filename_id,
    p._p,
    p._cmp,
    p._sc,
    p._pid,
    p._fc,

    c._filename_id,
    c._p,
    c._cmp,
    c._cc,
    c._ref,
    c._type,

    d._filename_id,
    d._cmp,
    d._defect,
    d._insp_type,
    d._lead_id,

    null as dummy
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

select
    ftf._filename,
    ftf._filename_type,
    ftf._filename_timestamp,
    ftf._filename_route,
    ftf._filename_id,

    afd._filename_id,
    afd._aoi_pcbid,
    afd._date_time,

    i._filename_id,
    i._cid,
    i._timestamp,
    i._crc,
    i._c2d,
    i._recipename,
    i._mid,

    p._filename_id,
    p._p,
    p._cmp,
    p._sc,
    p._pid,
    p._fc,

    c._filename_id,
    c._p,
    c._cmp,
    c._cc,
    c._ref,
    c._type,

    d._filename_id,
    d._cmp,
    d._defect,
    d._insp_type,
    d._lead_id,

    null as dummy
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

select
    ftf._filename,
    ftf._filename_type,
    ftf._filename_timestamp,
    ftf._filename_route,
    ftf._filename_id,

    afd._filename_id,
    afd._aoi_pcbid,
    afd._date_time,

    i._filename_id,
    i._cid,
    i._timestamp,
    i._crc,
    i._c2d,
    i._recipename,
    i._mid,

    p._filename_id,
    p._p,
    p._cmp,
    p._sc,
    p._pid,
    p._fc,

    null as dummy
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

