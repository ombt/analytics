--
-- will contains current size of field.
--
DECLARE @current_field_size INT
DECLARE @minimum_field_size INT
SET @current_field_size = 0
SET @minimum_field_size = 200
--
-- get current size of trx_productid field and if the size is
-- less than 100 characters (200 bytes), then set the field
-- to empty string.
--
SELECT 
    @current_field_size = max_length
FROM 
    sys.columns
WHERE
    object_id = OBJECT_ID(N'[dbo].[additional_info_npm_hdr_by_board]')
AND
    name = 'trx_productid'

IF (@current_field_size <= @minimum_field_size)
BEGIN
    PRINT 'additional_info_npm_hdr_by_board trx_productid: SIZE < 100 CHARS'
    alter table
        ADDITIONAL_INFO_NPM_HDR_BY_BOARD
    alter column
        TRX_PRODUCTID NVARCHAR(255) NULL
END
ELSE
BEGIN
    PRINT 'additional_info_npm_hdr_by_board trx_productid: SIZE > 100 CHARS'
END

SELECT 
    @current_field_size = max_length
FROM 
    sys.columns
WHERE
    object_id = OBJECT_ID(N'[dbo].[additional_info_npm_hdr]')
AND
    name = 'trx_productid'

IF (@current_field_size <= @minimum_field_size)
BEGIN
    PRINT 'additional_info_npm_hdr trx_productid: SIZE < 100 CHARS'
    alter table
        ADDITIONAL_INFO_NPM_HDR
    alter column
        TRX_PRODUCTID NVARCHAR(255) NULL
END
ELSE
BEGIN
    PRINT 'additional_info_npm_hdr trx_productid: SIZE > 100 CHARS'
END

SELECT 
    @current_field_size = max_length
FROM 
    sys.columns
WHERE
    object_id = OBJECT_ID(N'[dbo].[additional_info_npm_hdr_raw]')
AND
    name = 'trx_productid'

IF (@current_field_size <= @minimum_field_size)
BEGIN
    PRINT 'additional_info_npm_hdr_raw trx_productid: SIZE < 100 CHARS'
    alter table
        ADDITIONAL_INFO_NPM_HDR_RAW
    alter column
        TRX_PRODUCTID NVARCHAR(255) NULL
END
ELSE
BEGIN
    PRINT 'additional_info_npm_hdr_raw trx_productid: SIZE > 100 CHARS'
END

SELECT 
    @current_field_size = max_length
FROM 
    sys.columns
WHERE
    object_id = OBJECT_ID(N'[dbo].[nozzle_npm_hdr_by_board]')
AND
    name = 'trx_productid'

IF (@current_field_size <= @minimum_field_size)
BEGIN
    PRINT 'nozzle_npm_hdr_by_board trx_productid: SIZE < 100 CHARS'
    alter table
        NOZZLE_NPM_HDR_BY_BOARD
    alter column
        TRX_PRODUCTID NVARCHAR(255) NULL
END
ELSE
BEGIN
    PRINT 'nozzle_npm_hdr_by_board trx_productid: SIZE > 100 CHARS'
END

SELECT 
    @current_field_size = max_length
FROM 
    sys.columns
WHERE
    object_id = OBJECT_ID(N'[dbo].[nozzle_npm_hdr]')
AND
    name = 'trx_productid'

IF (@current_field_size <= @minimum_field_size)
BEGIN
    PRINT 'nozzle_npm_hdr trx_productid: SIZE < 100 CHARS'
    alter table
        NOZZLE_NPM_HDR
    alter column
        TRX_PRODUCTID NVARCHAR(255) NULL
END
ELSE
BEGIN
    PRINT 'nozzle_npm_hdr trx_productid: SIZE > 100 CHARS'
END

SELECT 
    @current_field_size = max_length
FROM 
    sys.columns
WHERE
    object_id = OBJECT_ID(N'[dbo].[nozzle_npm_hdr_raw]')
AND
    name = 'trx_productid'

IF (@current_field_size <= @minimum_field_size)
BEGIN
    PRINT 'nozzle_npm_hdr_raw trx_productid: SIZE < 100 CHARS'
    alter table
        NOZZLE_NPM_HDR_RAW
    alter column
        TRX_PRODUCTID NVARCHAR(255) NULL
END
ELSE
BEGIN
    PRINT 'nozzle_npm_hdr_raw trx_productid: SIZE > 100 CHARS'
END

SELECT 
    @current_field_size = max_length
FROM 
    sys.columns
WHERE
    object_id = OBJECT_ID(N'[dbo].[production_count_reports_npm_hdr_by_board]')
AND
    name = 'trx_productid'

IF (@current_field_size <= @minimum_field_size)
BEGIN
    PRINT 'production_count_reports_npm_hdr_by_board trx_productid: SIZE < 100 CHARS'
    alter table
        PRODUCTION_COUNT_REPORTS_NPM_HDR_BY_BOARD
    alter column
        TRX_PRODUCTID NVARCHAR(255) NULL
END
ELSE
BEGIN
    PRINT 'production_count_reports_npm_hdr_by_board trx_productid: SIZE > 100 CHARS'
END

SELECT 
    @current_field_size = max_length
FROM 
    sys.columns
WHERE
    object_id = OBJECT_ID(N'[dbo].[production_count_reports_npm_hdr]')
AND
    name = 'trx_productid'

IF (@current_field_size <= @minimum_field_size)
BEGIN
    PRINT 'production_count_reports_npm_hdr trx_productid: SIZE < 100 CHARS'
    alter table
        PRODUCTION_COUNT_REPORTS_NPM_HDR
    alter column
        TRX_PRODUCTID NVARCHAR(255) NULL
END
ELSE
BEGIN
    PRINT 'production_count_reports_npm_hdr trx_productid: SIZE > 100 CHARS'
END

SELECT 
    @current_field_size = max_length
FROM 
    sys.columns
WHERE
    object_id = OBJECT_ID(N'[dbo].[production_count_reports_npm_hdr_raw]')
AND
    name = 'trx_productid'

IF (@current_field_size <= @minimum_field_size)
BEGIN
    PRINT 'production_count_reports_npm_hdr_raw trx_productid: SIZE < 100 CHARS'
    alter table
        PRODUCTION_COUNT_REPORTS_NPM_HDR_RAW
    alter column
        TRX_PRODUCTID NVARCHAR(255) NULL
END
ELSE
BEGIN
    PRINT 'production_count_reports_npm_hdr_raw trx_productid: SIZE > 100 CHARS'
END

SELECT 
    @current_field_size = max_length
FROM 
    sys.columns
WHERE
    object_id = OBJECT_ID(N'[dbo].[production_reports_npm_hdr_by_board]')
AND
    name = 'trx_productid'

IF (@current_field_size <= @minimum_field_size)
BEGIN
    PRINT 'production_reports_npm_hdr_by_board trx_productid: SIZE < 100 CHARS'
    alter table
        PRODUCTION_REPORTS_NPM_HDR_BY_BOARD
    alter column
        TRX_PRODUCTID NVARCHAR(255) NULL
END
ELSE
BEGIN
    PRINT 'production_reports_npm_hdr_by_board trx_productid: SIZE > 100 CHARS'
END

SELECT 
    @current_field_size = max_length
FROM 
    sys.columns
WHERE
    object_id = OBJECT_ID(N'[dbo].[production_reports_npm_hdr]')
AND
    name = 'trx_productid'

IF (@current_field_size <= @minimum_field_size)
BEGIN
    PRINT 'production_reports_npm_hdr trx_productid: SIZE < 100 CHARS'
    alter table
        PRODUCTION_REPORTS_NPM_HDR
    alter column
        TRX_PRODUCTID NVARCHAR(255) NULL
END
ELSE
BEGIN
    PRINT 'production_reports_npm_hdr trx_productid: SIZE > 100 CHARS'
END

SELECT 
    @current_field_size = max_length
FROM 
    sys.columns
WHERE
    object_id = OBJECT_ID(N'[dbo].[production_reports_npm_hdr_raw]')
AND
    name = 'trx_productid'

IF (@current_field_size <= @minimum_field_size)
BEGIN
    PRINT 'production_reports_npm_hdr_raw trx_productid: SIZE < 100 CHARS'
    alter table
        PRODUCTION_REPORTS_NPM_HDR_RAW
    alter column
        TRX_PRODUCTID NVARCHAR(255) NULL
END
ELSE
BEGIN
    PRINT 'production_reports_npm_hdr_raw trx_productid: SIZE > 100 CHARS'
END

SELECT 
    @current_field_size = max_length
FROM 
    sys.columns
WHERE
    object_id = OBJECT_ID(N'[dbo].[production_time_reports_npm_hdr_by_board]')
AND
    name = 'trx_productid'

IF (@current_field_size <= @minimum_field_size)
BEGIN
    PRINT 'production_time_reports_npm_hdr_by_board trx_productid: SIZE < 100 CHARS'
    alter table
        PRODUCTION_TIME_REPORTS_NPM_HDR_BY_BOARD
    alter column
        TRX_PRODUCTID NVARCHAR(255) NULL
END
ELSE
BEGIN
    PRINT 'production_time_reports_npm_hdr_by_board trx_productid: SIZE > 100 CHARS'
END

SELECT 
    @current_field_size = max_length
FROM 
    sys.columns
WHERE
    object_id = OBJECT_ID(N'[dbo].[production_time_reports_npm_hdr]')
AND
    name = 'trx_productid'

IF (@current_field_size <= @minimum_field_size)
BEGIN
    PRINT 'production_time_reports_npm_hdr trx_productid: SIZE < 100 CHARS'
    alter table
        PRODUCTION_TIME_REPORTS_NPM_HDR
    alter column
        TRX_PRODUCTID NVARCHAR(255) NULL
END
ELSE
BEGIN
    PRINT 'production_time_reports_npm_hdr trx_productid: SIZE > 100 CHARS'
END

SELECT 
    @current_field_size = max_length
FROM 
    sys.columns
WHERE
    object_id = OBJECT_ID(N'[dbo].[production_time_reports_npm_hdr_raw]')
AND
    name = 'trx_productid'

IF (@current_field_size <= @minimum_field_size)
BEGIN
    PRINT 'production_time_reports_npm_hdr_raw trx_productid: SIZE < 100 CHARS'
    alter table
        PRODUCTION_TIME_REPORTS_NPM_HDR_RAW
    alter column
        TRX_PRODUCTID NVARCHAR(255) NULL
END
ELSE
BEGIN
    PRINT 'production_time_reports_npm_hdr_raw trx_productid: SIZE > 100 CHARS'
END

SELECT 
    @current_field_size = max_length
FROM 
    sys.columns
WHERE
    object_id = OBJECT_ID(N'[dbo].[z_cass_npm_hdr_by_board]')
AND
    name = 'trx_productid'

IF (@current_field_size <= @minimum_field_size)
BEGIN
    PRINT 'z_cass_npm_hdr_by_board trx_productid: SIZE < 100 CHARS'
    alter table
        Z_CASS_NPM_HDR_BY_BOARD
    alter column
        TRX_PRODUCTID NVARCHAR(255) NULL
END
ELSE
BEGIN
    PRINT 'z_cass_npm_hdr_by_board trx_productid: SIZE > 100 CHARS'
END

SELECT 
    @current_field_size = max_length
FROM 
    sys.columns
WHERE
    object_id = OBJECT_ID(N'[dbo].[z_cass_npm_hdr]')
AND
    name = 'trx_productid'

IF (@current_field_size <= @minimum_field_size)
BEGIN
    PRINT 'z_cass_npm_hdr trx_productid: SIZE < 100 CHARS'
    alter table
        Z_CASS_NPM_HDR
    alter column
        TRX_PRODUCTID NVARCHAR(255) NULL
END
ELSE
BEGIN
    PRINT 'z_cass_npm_hdr trx_productid: SIZE > 100 CHARS'
END

SELECT 
    @current_field_size = max_length
FROM 
    sys.columns
WHERE
    object_id = OBJECT_ID(N'[dbo].[z_cass_npm_hdr_raw]')
AND
    name = 'trx_productid'

IF (@current_field_size <= @minimum_field_size)
BEGIN
    PRINT 'z_cass_npm_hdr_raw trx_productid: SIZE < 100 CHARS'
    alter table
        Z_CASS_NPM_HDR_RAW
    alter column
        TRX_PRODUCTID NVARCHAR(255) NULL
END
ELSE
BEGIN
    PRINT 'z_cass_npm_hdr_raw trx_productid: SIZE > 100 CHARS'
END

