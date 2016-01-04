select 
    count(*) as 'pr_bb_cnt'
from
    production_reports_npm_by_board;
go
select 
    count(*) as 'zc_bb_cnt'
from
    z_cass_npm_by_board;
go
select 
    count(*) as 'nz_bb_cnt'
from
    nozzle_npm_by_board;
go
