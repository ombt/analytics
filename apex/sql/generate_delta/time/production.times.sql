-- select
--     fid,
--     bndrcgstop,
--     bndstop,
--     board,
--     brcgstop,
--     bwait,
--     cderr,
--     cmerr,
--     cnvstop,
--     cperr,
--     crerr,
--     cterr,
--     cwait,
--     fbstop,
--     fwait,
--     jointpasswait,
--     judgestop,
--     lotboard,
--     lotmodule,
--     mcfwait,
--     mcrwait,
--     mhrcgstop,
--     module,
--     otherlstop,
--     othrstop,
--     pwait,
--     rwait,
--     scestop,
--     scstop,
--     swait,
--     tdispense,
--     tdmiss,
--     thmiss,
--     tmmiss,
--     tmount,
--     tpickup,
--     tpmiss,
--     tpriming,
--     trbl,
--     trmiss,
--     trserr,
--     trsmiss
--     row_number() over (
--         partition by
--             ufd._machine_order,
--             ufd._lane_no,
--             ufd._stage_no,
--             uidx._value,
--             uinf._value
--             -- mpn._blkserial
--         order by
--             ufd._machine_order,
--             ufd._lane_no,
--             ufd._stage_no,
--             mpn._nhadd,
--             mpn._ncadd,
--             fnf._filename_timestamp
--     ) as row
-- from
--     crosstab( 'select 
--                    uc._filename_id, 
--                    uc._name, 
--                    uc._value 
--                from 
--                    u01.count uc 
--                order by 1,2',
--               'select distinct 
--                    uc._name 
--                from 
--                    u01.count uc 
--                order by 1')
-- as
--     final_result(fid numeric(30,0),
--                  bndrcgstop numeric(10,3),
--                  bndstop numeric(10,3),
--                  board numeric(10,3),
--                  brcgstop numeric(10,3),
--                  bwait numeric(10,3),
--                  cderr numeric(10,3),
--                  cmerr numeric(10,3),
--                  cnvstop numeric(10,3),
--                  cperr numeric(10,3),
--                  crerr numeric(10,3),
--                  cterr numeric(10,3),
--                  cwait numeric(10,3),
--                  fbstop numeric(10,3),
--                  fwait numeric(10,3),
--                  jointpasswait numeric(10,3),
--                  judgestop numeric(10,3),
--                  lotboard numeric(10,3),
--                  lotmodule numeric(10,3),
--                  mcfwait numeric(10,3),
--                  mcrwait numeric(10,3),
--                  mhrcgstop numeric(10,3),
--                  module numeric(10,3),
--                  otherlstop numeric(10,3),
--                  othrstop numeric(10,3),
--                  pwait numeric(10,3),
--                  rwait numeric(10,3),
--                  scestop numeric(10,3),
--                  scstop numeric(10,3),
--                  swait numeric(10,3),
--                  tdispense numeric(10,3),
--                  tdmiss numeric(10,3),
--                  thmiss numeric(10,3),
--                  tmmiss numeric(10,3),
--                  tmount numeric(10,3),
--                  tpickup numeric(10,3),
--                  tpmiss numeric(10,3),
--                  tpriming numeric(10,3),
--                  trbl numeric(10,3),
--                  trmiss numeric(10,3),
--                  trserr numeric(10,3),
--                  trsmiss numeric(10,3) )
-- ;

-- Actual numeric(10,3)
-- BNDRcgStop numeric(10,3)
-- BNDStop numeric(10,3)
-- BRcg numeric(10,3)
-- BRcgStop numeric(10,3)
-- Bwait numeric(10,3)
-- CDErr numeric(10,3)
-- Change numeric(10,3)
-- CMErr numeric(10,3)
-- CnvStop numeric(10,3)
-- CPErr numeric(10,3)
-- CRErr numeric(10,3)
-- CTErr numeric(10,3)
-- Cwait numeric(10,3)
-- DataEdit numeric(10,3)
-- FBStop numeric(10,3)
-- Fwait numeric(10,3)
-- Idle numeric(10,3)
-- JointPassWait numeric(10,3)
-- JudgeStop numeric(10,3)
-- Load numeric(10,3)
-- McFwait numeric(10,3)
-- McRwait numeric(10,3)
-- Mente numeric(10,3)
-- MHRcgStop numeric(10,3)
-- Mount numeric(10,3)
-- OtherLStop numeric(10,3)
-- OthrStop numeric(10,3)
-- PowerON numeric(10,3)
-- PRDStop numeric(10,3)
-- Prod numeric(10,3)
-- ProdView numeric(10,3)
-- Pwait numeric(10,3)
-- Rwait numeric(10,3)
-- SCEStop numeric(10,3)
-- SCStop numeric(10,3)
-- Swait numeric(10,3)
-- TotalStop numeric(10,3)
-- Trbl numeric(10,3)
-- TRSErr numeric(10,3)
-- UnitAdjust numeric(10,3)

select
    fid,
    actual,
    bndrcgstop,
    bndstop,
    brcg,
    brcgstop,
    bwait,
    cderr,
    change,
    cmerr,
    cnvstop,
    cperr,
    crerr,
    cterr,
    cwait,
    dataedit,
    fbstop,
    fwait,
    idle,
    jointpasswait,
    judgestop,
    load,
    mcfwait,
    mcrwait,
    mente,
    mhrcgstop,
    mount,
    otherlstop,
    othrstop,
    poweron,
    prdstop,
    prod,
    prodview,
    pwait,
    rwait,
    scestop,
    scstop,
    swait,
    totalstop,
    trbl,
    trserr,
    unitadjust
from
    crosstab( 'select 
                   ut._filename_id, 
                   ut._name, 
                   ut._value 
               from 
                   u01.time ut 
               order by 1,2',
              'select distinct 
                   ut._name 
               from 
                   u01.time ut 
               order by 1')
as
    final_result(fid numeric(30,0),
                 actual numeric(10,3),
                 bndrcgstop numeric(10,3),
                 bndstop numeric(10,3),
                 brcg numeric(10,3),
                 brcgstop numeric(10,3),
                 bwait numeric(10,3),
                 cderr numeric(10,3),
                 change numeric(10,3),
                 cmerr numeric(10,3),
                 cnvstop numeric(10,3),
                 cperr numeric(10,3),
                 crerr numeric(10,3),
                 cterr numeric(10,3),
                 cwait numeric(10,3),
                 dataedit numeric(10,3),
                 fbstop numeric(10,3),
                 fwait numeric(10,3),
                 idle numeric(10,3),
                 jointpasswait numeric(10,3),
                 judgestop numeric(10,3),
                 load numeric(10,3),
                 mcfwait numeric(10,3),
                 mcrwait numeric(10,3),
                 mente numeric(10,3),
                 mhrcgstop numeric(10,3),
                 mount numeric(10,3),
                 otherlstop numeric(10,3),
                 othrstop numeric(10,3),
                 poweron numeric(10,3),
                 prdstop numeric(10,3),
                 prod numeric(10,3),
                 prodview numeric(10,3),
                 pwait numeric(10,3),
                 rwait numeric(10,3),
                 scestop numeric(10,3),
                 scstop numeric(10,3),
                 swait numeric(10,3),
                 totalstop numeric(10,3),
                 trbl numeric(10,3),
                 trserr numeric(10,3),
                 unitadjust numeric(10,3) )
;

