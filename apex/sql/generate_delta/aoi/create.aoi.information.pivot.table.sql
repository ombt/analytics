
create table if not exists aoi.pivot_information
(
    _filename_id numeric(30,0),
    _pcbid text
) ;

create index if not exists idx_pivot_information on aoi.pivot_information
(
    _filename_id
) ;

insert into aoi.pivot_information
(
    _filename_id,
    _pcbid
)
select
    _filename_id,
    _pcbid
from
    crosstab( 'select 
                   ai._filename_id, 
                   ai._name, 
                   ai._value 
               from 
                   aoi.information ai 
               order by 1,2',
              'select distinct 
                   ai._name 
               from 
                   aoi.information ai 
               order by 1')
as
    final_result(_filename_id numeric(30,0),
                 _pcbid text )
;

