select 
    min(end_time) as 'z_cass_min_end_time',
    max(end_time) as 'z_cass_max_end_time'
from 
    z_cass_npm_hdr_raw
where 
    trx_productid like '20140929%'
and
    setup_id <> -1
and
    product_id <> -1
go
select 
    min(end_time) as 'nozzle_min_end_time',
    max(end_time) as 'nozzle_max_end_time'
from 
    nozzle_npm_hdr_raw
where 
    trx_productid like '20140929%'
and
    setup_id <> -1
and
    product_id <> -1
go
select 
    min(end_time) as 'prod_rpt_min_end_time',
    max(end_time) as 'prod_rpt_max_end_time'
from 
    production_reports_npm_hdr_raw
where 
    trx_productid like '20140929%'
and
    setup_id <> -1
and
    product_id <> -1
go
select 
    min(end_time) as 'union_min_end_time',
    max(end_time) as 'union_max_end_time'
from 
    z_cass_npm_hdr_raw
where 
    trx_productid like '20140929%'
and
    setup_id <> -1
and
    product_id <> -1
union
select 
    min(end_time) as 'min_end_time',
    max(end_time) as 'max_end_time'
from 
    nozzle_npm_hdr_raw
where 
    trx_productid like '20140929%'
and
    setup_id <> -1
and
    product_id <> -1
union
select 
    min(end_time) as 'min_end_time',
    max(end_time) as 'max_end_time'
from 
    production_reports_npm_hdr_raw
where 
    trx_productid like '20140929%'
and
    setup_id <> -1
and
    product_id <> -1
go
select
    min(t.min_end_time) as 'overall_min_end_time',
    max(t.max_end_time) as 'overall_max_end_time'
from (
    select 
        min(end_time) as 'min_end_time',
        max(end_time) as 'max_end_time'
    from 
        z_cass_npm_hdr_raw
    where 
        trx_productid like '20140929%'
    and
        setup_id <> -1
    and
        product_id <> -1
    union
    select 
        min(end_time) as 'min_end_time',
        max(end_time) as 'max_end_time'
    from 
        nozzle_npm_hdr_raw
    where 
        trx_productid like '20140929%'
    and
        setup_id <> -1
    and
        product_id <> -1
    union
    select 
        min(end_time) as 'min_end_time',
        max(end_time) as 'max_end_time'
    from 
        production_reports_npm_hdr_raw
    where 
        trx_productid like '20140929%'
    and
        setup_id <> -1
    and
        product_id <> -1
) t
go
