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
    pi._filename_id,
    pi._pcbid
from
    aoi.filename_to_fid ftf
inner join
    aoi.rst_filename_data rfd
on
    rfd._filename_id = ftf._filename_id
inner join
    aoi.pivot_information pi
on
    pi._filename_id = ftf._filename_id
order by
    ftf._filename_route,
    rfd._machine,
    rfd._lane,
    ftf._filename_timestamp
;
