
create table if not exists crb.pivot_index
(
    _filename_id numeric(30,0),
    _author text,
    _authortype text,
    _comment text,
    _date text,
    _diff text,
    _format text,
    _machine text,
    _mjsid text,
    _version text
) ;

create index if not exists idx_pivot_index on crb.pivot_index
(
    _filename_id
) ;

insert into crb.pivot_index 
(
    _filename_id,
    _author,
    _authortype,
    _comment,
    _date,
    _diff,
    _format,
    _machine,
    _mjsid,
    _version
)
    select
        _filename_id,
        _author,
        _authortype,
        _comment,
        _date,
        _diff,
        _format,
        _machine,
        _mjsid,
        _version
    from
        crosstab( 'select 
                       ci._filename_id, 
                       ci._name, 
                       ci._value 
                   from 
                       crb.index ci
                   order by 1,2',
                  'select distinct 
                       ci._name 
                   from 
                       crb.index ci 
                   order by 1')
    as
        final_result(_filename_id numeric(30,0),
                     _author text,
                     _authortype text,
                     _comment text,
                     _date text,
                     _diff text,
                     _format text,
                     _machine text,
                     _mjsid text,
                     _version text )
;

