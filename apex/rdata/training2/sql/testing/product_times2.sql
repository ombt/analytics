-- 
-- select distinct
--     ufd._machine_order as machine
-- from
--     u01.u0x_filename_data ufd
-- inner join
--     u01.filename_to_fid ftf
-- on
--     ftf._filename_route = 'compal'
-- and
--     ufd._filename_id = ftf._filename_id
-- order by
--     ufd._machine_order asc
-- ;

select distinct
    ftf._filename_route,
    px._mjsid,
    pi._lotname,
    pi._lotnumber,
    pi._lane,
    min(ufd._date) as min_date,
    max(ufd._date) as max_date
from
    u01.filename_to_fid ftf
inner join
    u01.u0x_filename_data ufd
on
    ufd._filename_id = ftf._filename_id
and
    ufd._output_no in ( 3, 4 )
inner join
    u01.pivot_index px
on
    px._filename_id = ftf._filename_id
and
    px._mjsid = '%s'
inner join
    u01.pivot_information pi
on
    pi._filename_id = ftf._filename_id
and
    pi._lotname = '%s'
and
    pi._lotnumber = '%s'
and
    pi._lane = '%s'
where
    ftf._filename_route = '%s'
group by
    ftf._filename_route,
    px._mjsid,
    pi._lotname,
    pi._lotnumber,
    pi._lane
;
