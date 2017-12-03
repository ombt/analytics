select
    _filename_id,
    _comment1,
    _comment2,
    _comment3,
    _lot,
    _modelid,
    _productdata,
    _side
from
    crosstab( 'select 
                   ai._filename_id, 
                   ai._name, 
                   ai._value 
               from 
                   aoi.lotinformation ai 
               order by 1,2',
              'select distinct 
                   ai._name 
               from 
                   aoi.lotinformation ai 
               order by 1')
as
    final_result(_filename_id numeric(30,0),
                 _comment1 text,
                 _comment2 text,
                 _comment3 text,
                 _lot text,
                 _modelid text,
                 _productdata text,
                 _side text )
;

