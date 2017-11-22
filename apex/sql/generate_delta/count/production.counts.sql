select
    fid,
    bndrcgstop,
    bndstop,
    board,
    brcgstop,
    bwait,
    cderr,
    cmerr,
    cnvstop,
    cperr,
    crerr,
    cterr,
    cwait,
    fbstop,
    fwait,
    jointpasswait,
    judgestop,
    lotboard,
    lotmodule,
    mcfwait,
    mcrwait,
    mhrcgstop,
    module,
    otherlstop,
    othrstop,
    pwait,
    rwait,
    scestop,
    scstop,
    swait,
    tdispense,
    tdmiss,
    thmiss,
    tmmiss,
    tmount,
    tpickup,
    tpmiss,
    tpriming,
    trbl,
    trmiss,
    trserr,
    trsmiss
    row_number() over (
        partition by
            ufd._machine_order,
            ufd._lane_no,
            ufd._stage_no,
            uidx._value,
            uinf._value
            -- mpn._blkserial
        order by
            ufd._machine_order,
            ufd._lane_no,
            ufd._stage_no,
            mpn._nhadd,
            mpn._ncadd,
            fnf._filename_timestamp
    ) as row
from
    crosstab( 'select 
                   uc._filename_id, 
                   uc._name, 
                   uc._value 
               from 
                   u01.count uc 
               order by 1,2',
              'select distinct 
                   uc._name 
               from 
                   u01.count uc 
               order by 1')
as
    final_result(fid numeric(30,0),
                 bndrcgstop numeric(10,3),
                 bndstop numeric(10,3),
                 board numeric(10,3),
                 brcgstop numeric(10,3),
                 bwait numeric(10,3),
                 cderr numeric(10,3),
                 cmerr numeric(10,3),
                 cnvstop numeric(10,3),
                 cperr numeric(10,3),
                 crerr numeric(10,3),
                 cterr numeric(10,3),
                 cwait numeric(10,3),
                 fbstop numeric(10,3),
                 fwait numeric(10,3),
                 jointpasswait numeric(10,3),
                 judgestop numeric(10,3),
                 lotboard numeric(10,3),
                 lotmodule numeric(10,3),
                 mcfwait numeric(10,3),
                 mcrwait numeric(10,3),
                 mhrcgstop numeric(10,3),
                 module numeric(10,3),
                 otherlstop numeric(10,3),
                 othrstop numeric(10,3),
                 pwait numeric(10,3),
                 rwait numeric(10,3),
                 scestop numeric(10,3),
                 scstop numeric(10,3),
                 swait numeric(10,3),
                 tdispense numeric(10,3),
                 tdmiss numeric(10,3),
                 thmiss numeric(10,3),
                 tmmiss numeric(10,3),
                 tmount numeric(10,3),
                 tpickup numeric(10,3),
                 tpmiss numeric(10,3),
                 tpriming numeric(10,3),
                 trbl numeric(10,3),
                 trmiss numeric(10,3),
                 trserr numeric(10,3),
                 trsmiss numeric(10,3) )
;
