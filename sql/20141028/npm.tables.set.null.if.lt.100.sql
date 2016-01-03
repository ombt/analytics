--
-- will contain current size of field.
--
declare @current_field_size int
declare @minimum_field_size int
set @current_field_size = 0
set @minimum_field_size = 200
--
-- get current size of trx_productid field and if the size is
-- less than 100 characters (200 bytes), then set the field
-- to empty string.
--
select 
    @current_field_size = max_length
from 
    sys.columns
where
    object_id = OBJECT_ID(N'[dbo].[nozzle_npm_hdr_by_board]')
and
    name = 'trx_productid'

if (@current_field_size <= @minimum_field_size)
begin
    print 'nozzle_npm_hdr_by_board trx_productid: size < 100 chars'
    alter table
        nozzle_npm_hdr_by_board
    alter column
        trx_productid nvarchar(255) null
    update
        nozzle_npm_hdr_by_board
    set
        trx_productid = ''
end
else
begin
    print 'nozzle_npm_hdr_by_board trx_productid: size > 100 chars'
end

select 
    @current_field_size = max_length
from 
    sys.columns
where
    object_id = OBJECT_ID(N'[dbo].[nozzle_npm_hdr]')
and
    name = 'trx_productid'

if (@current_field_size <= @minimum_field_size)
begin
    print 'nozzle_npm_hdr trx_productid: size < 100 chars'
    alter table
        nozzle_npm_hdr
    alter column
        trx_productid nvarchar(255) null
    update
        nozzle_npm_hdr
    set
        trx_productid = ''
end
else
begin
    print 'nozzle_npm_hdr trx_productid: size > 100 chars'
end

select 
    @current_field_size = max_length
from 
    sys.columns
where
    object_id = OBJECT_ID(N'[dbo].[nozzle_npm_hdr_raw]')
and
    name = 'trx_productid'

if (@current_field_size <= @minimum_field_size)
begin
    print 'nozzle_npm_hdr_raw trx_productid: size < 100 chars'
    alter table
        nozzle_npm_hdr_raw
    alter column
        trx_productid nvarchar(255) null
    update
        nozzle_npm_hdr_raw
    set
        trx_productid = ''
end
else
begin
    print 'nozzle_npm_hdr_raw trx_productid: size > 100 chars'
end

select 
    @current_field_size = max_length
from 
    sys.columns
where
    object_id = OBJECT_ID(N'[dbo].[production_reports_npm_hdr_by_board]')
and
    name = 'trx_productid'

if (@current_field_size <= @minimum_field_size)
begin
    print 'production_reports_npm_hdr_by_board trx_productid: size < 100 chars'
    alter table
        production_reports_npm_hdr_by_board
    alter column
        trx_productid nvarchar(255) null
    update
        production_reports_npm_hdr_by_board
    set
        trx_productid = ''
end
else
begin
    print 'production_reports_npm_hdr_by_board trx_productid: size > 100 chars'
end

select 
    @current_field_size = max_length
from 
    sys.columns
where
    object_id = OBJECT_ID(N'[dbo].[production_reports_npm_hdr]')
and
    name = 'trx_productid'

if (@current_field_size <= @minimum_field_size)
begin
    print 'production_reports_npm_hdr trx_productid: size < 100 chars'
    alter table
        production_reports_npm_hdr
    alter column
        trx_productid nvarchar(255) null
    update
        production_reports_npm_hdr
    set
        trx_productid = ''
end
else
begin
    print 'production_reports_npm_hdr trx_productid: size > 100 chars'
end

select 
    @current_field_size = max_length
from 
    sys.columns
where
    object_id = OBJECT_ID(N'[dbo].[production_reports_npm_hdr_raw]')
and
    name = 'trx_productid'

if (@current_field_size <= @minimum_field_size)
begin
    print 'production_reports_npm_hdr_raw trx_productid: size < 100 chars'
    alter table
        production_reports_npm_hdr_raw
    alter column
        trx_productid nvarchar(255) null
    update
        production_reports_npm_hdr_raw
    set
        trx_productid = ''
end
else
begin
    print 'production_reports_npm_hdr_raw trx_productid: size > 100 chars'
end

select 
    @current_field_size = max_length
from 
    sys.columns
where
    object_id = OBJECT_ID(N'[dbo].[z_cass_npm_hdr_by_board]')
and
    name = 'trx_productid'

if (@current_field_size <= @minimum_field_size)
begin
    print 'z_cass_npm_hdr_by_board trx_productid: size < 100 chars'
    alter table
        z_cass_npm_hdr_by_board
    alter column
        trx_productid nvarchar(255) null
    update
        z_cass_npm_hdr_by_board
    set
        trx_productid = ''
end
else
begin
    print 'z_cass_npm_hdr_by_board trx_productid: size > 100 chars'
end

select 
    @current_field_size = max_length
from 
    sys.columns
where
    object_id = OBJECT_ID(N'[dbo].[z_cass_npm_hdr]')
and
    name = 'trx_productid'

if (@current_field_size <= @minimum_field_size)
begin
    print 'z_cass_npm_hdr trx_productid: size < 100 chars'
    alter table
        z_cass_npm_hdr
    alter column
        trx_productid nvarchar(255) null
    update
        z_cass_npm_hdr
    set
        trx_productid = ''
end
else
begin
    print 'z_cass_npm_hdr trx_productid: size > 100 chars'
end

select 
    @current_field_size = max_length
from 
    sys.columns
where
    object_id = OBJECT_ID(N'[dbo].[z_cass_npm_hdr_raw]')
and
    name = 'trx_productid'

if (@current_field_size <= @minimum_field_size)
begin
    print 'z_cass_npm_hdr_raw trx_productid: size < 100 chars'
    alter table
        z_cass_npm_hdr_raw
    alter column
        trx_productid nvarchar(255) null
    update
        z_cass_npm_hdr_raw
    set
        trx_productid = ''
end
else
begin
    print 'z_cass_npm_hdr_raw trx_productid: size > 100 chars'
end

