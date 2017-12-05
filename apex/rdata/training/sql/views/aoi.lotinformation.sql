select
    ftf._filename_route,
    rfd._machine,
    rfd._lane,
    ftf._filename_timestamp,
    ftf._filename,
    ftf._filename_type,
    ftf._filename_id,
    rfd._filename_id,
    rfd._date_time,
    rfd._serial_number,
    rfd._inspection_result,
    rfd._board_removed,
    pli._filename_id,
    pli._comment1,
    pli._comment2,
    pli._comment3,
    pli._lot,
    pli._modelid,
    pli._productdata,
    pli._side
from
    aoi.filename_to_fid ftf
inner join
    aoi.rst_filename_data rfd
on
    rfd._filename_id = ftf._filename_id
inner join
    aoi.pivot_lotinformation pli
on
    pli._filename_id = ftf._filename_id
order by
    ftf._filename_route,
    rfd._machine,
    rfd._lane,
    ftf._filename_timestamp
;
