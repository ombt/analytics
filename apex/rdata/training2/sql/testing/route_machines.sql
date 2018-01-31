
select distinct
    ufd._machine_order as machine
from
    u01.u0x_filename_data ufd
inner join
    u01.filename_to_fid ftf
on
    ftf._filename_route = 'compal'
and
    ufd._filename_id = ftf._filename_id
order by
    ufd._machine_order asc
;
