
create table if not exists u01.pivot_count
(
    _filename_id numeric(30,0),
    _bndrcgstop numeric(10,3),
    _bndstop numeric(10,3),
    _board numeric(10,3),
    _brcgstop numeric(10,3),
    _bwait numeric(10,3),
    _cderr numeric(10,3),
    _cmerr numeric(10,3),
    _cnvstop numeric(10,3),
    _cperr numeric(10,3),
    _crerr numeric(10,3),
    _cterr numeric(10,3),
    _cwait numeric(10,3),
    _fbstop numeric(10,3),
    _fwait numeric(10,3),
    _jointpasswait numeric(10,3),
    _judgestop numeric(10,3),
    _lotboard numeric(10,3),
    _lotmodule numeric(10,3),
    _mcfwait numeric(10,3),
    _mcrwait numeric(10,3),
    _mhrcgstop numeric(10,3),
    _module numeric(10,3),
    _otherlstop numeric(10,3),
    _othrstop numeric(10,3),
    _pwait numeric(10,3),
    _rwait numeric(10,3),
    _scestop numeric(10,3),
    _scstop numeric(10,3),
    _swait numeric(10,3),
    _tdispense numeric(10,3),
    _tdmiss numeric(10,3),
    _thmiss numeric(10,3),
    _tmmiss numeric(10,3),
    _tmount numeric(10,3),
    _tpickup numeric(10,3),
    _tpmiss numeric(10,3),
    _tpriming numeric(10,3),
    _trbl numeric(10,3),
    _trmiss numeric(10,3),
    _trserr numeric(10,3),
    _trsmiss numeric(10,3)
) ;

create index if not exists idx_pivot_count on u01.pivot_count
(
    _filename_id
) ;

insert into u01.pivot_count 
(
    _filename_id,
    _bndrcgstop,
    _bndstop,
    _board,
    _brcgstop,
    _bwait,
    _cderr,
    _cmerr,
    _cnvstop,
    _cperr,
    _crerr,
    _cterr,
    _cwait,
    _fbstop,
    _fwait,
    _jointpasswait,
    _judgestop,
    _lotboard,
    _lotmodule,
    _mcfwait,
    _mcrwait,
    _mhrcgstop,
    _module,
    _otherlstop,
    _othrstop,
    _pwait,
    _rwait,
    _scestop,
    _scstop,
    _swait,
    _tdispense,
    _tdmiss,
    _thmiss,
    _tmmiss,
    _tmount,
    _tpickup,
    _tpmiss,
    _tpriming,
    _trbl,
    _trmiss,
    _trserr,
    _trsmiss
)
    select
        _filename_id,
        _bndrcgstop,
        _bndstop,
        _board,
        _brcgstop,
        _bwait,
        _cderr,
        _cmerr,
        _cnvstop,
        _cperr,
        _crerr,
        _cterr,
        _cwait,
        _fbstop,
        _fwait,
        _jointpasswait,
        _judgestop,
        _lotboard,
        _lotmodule,
        _mcfwait,
        _mcrwait,
        _mhrcgstop,
        _module,
        _otherlstop,
        _othrstop,
        _pwait,
        _rwait,
        _scestop,
        _scstop,
        _swait,
        _tdispense,
        _tdmiss,
        _thmiss,
        _tmmiss,
        _tmount,
        _tpickup,
        _tpmiss,
        _tpriming,
        _trbl,
        _trmiss,
        _trserr,
        _trsmiss
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
        final_result(_filename_id numeric(30,0),
                     _bndrcgstop numeric(10,3),
                     _bndstop numeric(10,3),
                     _board numeric(10,3),
                     _brcgstop numeric(10,3),
                     _bwait numeric(10,3),
                     _cderr numeric(10,3),
                     _cmerr numeric(10,3),
                     _cnvstop numeric(10,3),
                     _cperr numeric(10,3),
                     _crerr numeric(10,3),
                     _cterr numeric(10,3),
                     _cwait numeric(10,3),
                     _fbstop numeric(10,3),
                     _fwait numeric(10,3),
                     _jointpasswait numeric(10,3),
                     _judgestop numeric(10,3),
                     _lotboard numeric(10,3),
                     _lotmodule numeric(10,3),
                     _mcfwait numeric(10,3),
                     _mcrwait numeric(10,3),
                     _mhrcgstop numeric(10,3),
                     _module numeric(10,3),
                     _otherlstop numeric(10,3),
                     _othrstop numeric(10,3),
                     _pwait numeric(10,3),
                     _rwait numeric(10,3),
                     _scestop numeric(10,3),
                     _scstop numeric(10,3),
                     _swait numeric(10,3),
                     _tdispense numeric(10,3),
                     _tdmiss numeric(10,3),
                     _thmiss numeric(10,3),
                     _tmmiss numeric(10,3),
                     _tmount numeric(10,3),
                     _tpickup numeric(10,3),
                     _tpmiss numeric(10,3),
                     _tpriming numeric(10,3),
                     _trbl numeric(10,3),
                     _trmiss numeric(10,3),
                     _trserr numeric(10,3),
                     _trsmiss numeric(10,3) )
;
