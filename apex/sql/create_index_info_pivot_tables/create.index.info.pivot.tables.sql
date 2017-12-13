
create table if not exists u01.pivot_index
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

create index if not exists idx_pivot_index on u01.pivot_index
(
    _filename_id
) ;

create table if not exists u03.pivot_index
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

create index if not exists idx_pivot_index on u03.pivot_index
(
    _filename_id
) ;

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

create table if not exists u01.pivot_information
(
    _filename_id numeric(30,0),
    _bcrstatus text,
    _code text,
    _lane integer,
    _lotname text,
    _lotnumber integer,
    _output integer,
    _planid text,
    _productid text,
    _rev text,
    _serial text,
    _serialstatus text,
    _stage integer
) ;

create index if not exists idx_pivot_information on u01.pivot_information
(
    _filename_id
) ;

create table if not exists u03.pivot_information
(
    _filename_id numeric(30,0),
    _bcrstatus text,
    _code text,
    _lane integer,
    _lotname text,
    _lotnumber integer,
    _output integer,
    _planid text,
    _productid text,
    _rev text,
    _serial text,
    _serialstatus text,
    _stage integer
) ;

create index if not exists idx_pivot_information on u03.pivot_information
(
    _filename_id
) ;

insert into u01.pivot_index 
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
                       ui._filename_id, 
                       ui._name, 
                       ui._value 
                   from 
                       u01.index ui
                   order by 1,2',
                  'select distinct 
                       ui._name 
                   from 
                       u01.index ui 
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

insert into u03.pivot_index 
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
                       ui._filename_id, 
                       ui._name, 
                       ui._value 
                   from 
                       u03.index ui
                   order by 1,2',
                  'select distinct 
                       ui._name 
                   from 
                       u03.index ui 
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

insert into u01.pivot_information 
(
    _filename_id,
    _bcrstatus,
    _code,
    _lane,
    _lotname,
    _lotnumber,
    _output,
    _planid,
    _productid,
    _rev,
    _serial,
    _serialstatus,
    _stage
)
    select
        _filename_id,
        _bcrstatus,
        _code,
        _lane,
        _lotname,
        _lotnumber,
        _output,
        _planid,
        _productid,
        _rev,
        _serial,
        _serialstatus,
        _stage
    from
        crosstab( 'select 
                       ui._filename_id, 
                       ui._name, 
                       ui._value 
                   from 
                       u01.information ui
                   order by 1,2',
                  'select distinct 
                       ui._name 
                   from 
                       u01.information ui 
                   order by 1')
    as
        final_result(_filename_id numeric(30,0),
                     _bcrstatus text,
                     _code text,
                     _lane integer,
                     _lotname text,
                     _lotnumber integer,
                     _output integer,
                     _planid text,
                     _productid text,
                     _rev text,
                     _serial text,
                     _serialstatus text,
                     _stage integer )
;

insert into u03.pivot_information 
(
    _filename_id,
    _bcrstatus,
    _code,
    _lane,
    _lotname,
    _lotnumber,
    _output,
    _planid,
    _productid,
    _rev,
    _serial,
    _serialstatus,
    _stage
)
    select
        _filename_id,
        _bcrstatus,
        _code,
        _lane,
        _lotname,
        _lotnumber,
        _output,
        _planid,
        _productid,
        _rev,
        _serial,
        _serialstatus,
        _stage
    from
        crosstab( 'select 
                       ui._filename_id, 
                       ui._name, 
                       ui._value 
                   from 
                       u03.information ui
                   order by 1,2',
                  'select distinct 
                       ui._name 
                   from 
                       u03.information ui 
                   order by 1')
    as
        final_result(_filename_id numeric(30,0),
                     _bcrstatus text,
                     _code text,
                     _lane integer,
                     _lotname text,
                     _lotnumber integer,
                     _output integer,
                     _planid text,
                     _productid text,
                     _rev text,
                     _serial text,
                     _serialstatus text,
                     _stage integer )
;

