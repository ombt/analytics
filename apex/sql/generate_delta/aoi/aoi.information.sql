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

