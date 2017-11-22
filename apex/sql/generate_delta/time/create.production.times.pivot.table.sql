
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

create table if not exists u01.pivot_time
(
    _filename_id numeric(30,0),
    _actual numeric(10,3),
    _bndrcgstop numeric(10,3),
    _bndstop numeric(10,3),
    _brcg numeric(10,3),
    _brcgstop numeric(10,3),
    _bwait numeric(10,3),
    _cderr numeric(10,3),
    _change numeric(10,3),
    _cmerr numeric(10,3),
    _cnvstop numeric(10,3),
    _cperr numeric(10,3),
    _crerr numeric(10,3),
    _cterr numeric(10,3),
    _cwait numeric(10,3),
    _dataedit numeric(10,3),
    _fbstop numeric(10,3),
    _fwait numeric(10,3),
    _idle numeric(10,3),
    _jointpasswait numeric(10,3),
    _judgestop numeric(10,3),
    _load numeric(10,3),
    _mcfwait numeric(10,3),
    _mcrwait numeric(10,3),
    _mente numeric(10,3),
    _mhrcgstop numeric(10,3),
    _mount numeric(10,3),
    _otherlstop numeric(10,3),
    _othrstop numeric(10,3),
    _poweron numeric(10,3),
    _prdstop numeric(10,3),
    _prod numeric(10,3),
    _prodview numeric(10,3),
    _pwait numeric(10,3),
    _rwait numeric(10,3),
    _scestop numeric(10,3),
    _scstop numeric(10,3),
    _swait numeric(10,3),
    _totalstop numeric(10,3),
    _trbl numeric(10,3),
    _trserr numeric(10,3),
    _unitadjust numeric(10,3)
) ;

create index if not exists idx_pivot_time on u01.pivot_time
(
    _filename_id
) ;

insert into u01.pivot_time 
(
    _filename_id,
    _actual,
    _bndrcgstop,
    _bndstop,
    _brcg,
    _brcgstop,
    _bwait,
    _cderr,
    _change,
    _cmerr,
    _cnvstop,
    _cperr,
    _crerr,
    _cterr,
    _cwait,
    _dataedit,
    _fbstop,
    _fwait,
    _idle,
    _jointpasswait,
    _judgestop,
    _load,
    _mcfwait,
    _mcrwait,
    _mente,
    _mhrcgstop,
    _mount,
    _otherlstop,
    _othrstop,
    _poweron,
    _prdstop,
    _prod,
    _prodview,
    _pwait,
    _rwait,
    _scestop,
    _scstop,
    _swait,
    _totalstop,
    _trbl,
    _trserr,
    _unitadjust
)
select
    _filename_id,
    _actual,
    _bndrcgstop,
    _bndstop,
    _brcg,
    _brcgstop,
    _bwait,
    _cderr,
    _change,
    _cmerr,
    _cnvstop,
    _cperr,
    _crerr,
    _cterr,
    _cwait,
    _dataedit,
    _fbstop,
    _fwait,
    _idle,
    _jointpasswait,
    _judgestop,
    _load,
    _mcfwait,
    _mcrwait,
    _mente,
    _mhrcgstop,
    _mount,
    _otherlstop,
    _othrstop,
    _poweron,
    _prdstop,
    _prod,
    _prodview,
    _pwait,
    _rwait,
    _scestop,
    _scstop,
    _swait,
    _totalstop,
    _trbl,
    _trserr,
    _unitadjust
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
    final_result(_filename_id numeric(30,0),
                 _actual numeric(10,3),
                 _bndrcgstop numeric(10,3),
                 _bndstop numeric(10,3),
                 _brcg numeric(10,3),
                 _brcgstop numeric(10,3),
                 _bwait numeric(10,3),
                 _cderr numeric(10,3),
                 _change numeric(10,3),
                 _cmerr numeric(10,3),
                 _cnvstop numeric(10,3),
                 _cperr numeric(10,3),
                 _crerr numeric(10,3),
                 _cterr numeric(10,3),
                 _cwait numeric(10,3),
                 _dataedit numeric(10,3),
                 _fbstop numeric(10,3),
                 _fwait numeric(10,3),
                 _idle numeric(10,3),
                 _jointpasswait numeric(10,3),
                 _judgestop numeric(10,3),
                 _load numeric(10,3),
                 _mcfwait numeric(10,3),
                 _mcrwait numeric(10,3),
                 _mente numeric(10,3),
                 _mhrcgstop numeric(10,3),
                 _mount numeric(10,3),
                 _otherlstop numeric(10,3),
                 _othrstop numeric(10,3),
                 _poweron numeric(10,3),
                 _prdstop numeric(10,3),
                 _prod numeric(10,3),
                 _prodview numeric(10,3),
                 _pwait numeric(10,3),
                 _rwait numeric(10,3),
                 _scestop numeric(10,3),
                 _scstop numeric(10,3),
                 _swait numeric(10,3),
                 _totalstop numeric(10,3),
                 _trbl numeric(10,3),
                 _trserr numeric(10,3),
                 _unitadjust numeric(10,3) )
;

