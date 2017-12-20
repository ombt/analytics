
create view crb.lot_position_data_view
as
select
    ftf._filename_route,
    ftf._filename_timestamp,
    ftf._filename,
    ftf._filename_type,
    ftf._filename_id,
    -- cfd._filename_id,
    cfd._history_id,
    cfd._time_stamp,
    cfd._crb_file_name,
    cfd._product_name,
    -- cl._filename_id,
    cl._idnum as lot_idnum,
    cl._lotnum,
    cl._lot,
    cl._mcfilename,
    cl._filter,
    cl._autochg,
    cl._basechg,
    cl._lane,
    cl._productionid,
    cl._simproduct,
    cl._dgspcbname,
    cl._dgspcbrev,
    cl._dgspcbside,
    cl._dgsrefpin,
    cl._c as lot_c,
    cl._datagenmode,
    cl._mounthead,
    cl._vstpath,
    cl._targettact,
    cl._order,
    -- cp._filename_id,
    cp._lot_number,
    cp._idnum as pos_idnum,
    cp._cadid,
    cp._x,
    cp._y,
    cp._a,
    cp._parts,
    cp._brm,
    cp._turn,
    cp._dturn,
    cp._ts,
    cp._ms,
    cp._ds,
    cp._np,
    cp._dnp,
    cp._pu,
    cp._side,
    cp._dpu,
    cp._head,
    cp._dhead,
    cp._ihead,
    cp._b,
    cp._pg,
    cp._s,
    cp._rid,
    cp._c as pos_c,
    cp._m,
    cp._mb,
    cp._f,
    cp._pr,
    cp._priseq,
    cp._p,
    cp._pad,
    cp._vw,
    cp._stdpos,
    cp._land,
    cp._depend,
    cp._chkflag,
    cp._exchk,
    cp._grand,
    cp._marea,
    cp._rmset,
    cp._sh,
    cp._scandir1,
    cp._scandir2,
    cp._ohl,
    cp._ohr,
    cp._apcctrl,
    cp._wg,
    cp._skipnumber
from
    crb.filename_to_fid ftf
inner join
    crb.crb_filename_data cfd
on
    cfd._filename_id = ftf._filename_id
inner join
    crb.lotnames cl
on
    cl._filename_id = ftf._filename_id
inner join
    crb.positiondata cp
on
    cp._filename_id = ftf._filename_id
and
    cp._lot_number = cl._lotnum
-- order by
    -- ftf._filename_route,
    -- ftf._filename_timestamp,
    -- cl._lotnum,
    -- cp._idnum
;

create view crb.lot_view
as
select
    ftf._filename_route,
    ftf._filename_timestamp,
    ftf._filename,
    ftf._filename_type,
    ftf._filename_id,
    -- cfd._filename_id,
    cfd._history_id,
    cfd._time_stamp,
    cfd._crb_file_name,
    cfd._product_name,
    -- cl._filename_id,
    cl._idnum as lot_idnum,
    cl._lotnum,
    cl._lot,
    cl._mcfilename,
    cl._filter,
    cl._autochg,
    cl._basechg,
    cl._lane,
    cl._productionid,
    cl._simproduct,
    cl._dgspcbname,
    cl._dgspcbrev,
    cl._dgspcbside,
    cl._dgsrefpin,
    cl._c as lot_c,
    cl._datagenmode,
    cl._mounthead,
    cl._vstpath,
    cl._targettact,
    cl._order
from
    crb.filename_to_fid ftf
inner join
    crb.crb_filename_data cfd
on
    cfd._filename_id = ftf._filename_id
inner join
    crb.lotnames cl
on
    cl._filename_id = ftf._filename_id
-- order by
    -- ftf._filename_route,
    -- ftf._filename_timestamp,
    -- cl._lotnum
;

