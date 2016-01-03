--*****************************************************************************
--       COPYRIGHT 2008-2010 PANASONIC FACTORY SOLUTIONS COMPANY OF AMERICA
--             DIVISION OF PANASONIC CORPORATION OF NORTH AMERICA
--         909 ASBURY DR, BUFFALO GROVE,IL, 60089. ALL RIGHTS RESERVED
--*****************************************************************************
--
-- CIMCS fine the equipment ID's
-- Select * from EQUIPMENT where EQUIPMENT_NAME like 'Brown-CM%' -- equipment_ID 1006, 1008
--
-- Name Of File      %M%
--
-- Version           %I%
--
-- Last Modified     %G%
--
-- Type Of File      sql Source File
--
-- Defined Procedures  
--
-- Defined Functions  
--
-- Author            Shankaranand S
--
-- Description       Stored procedures and Functions under Trace reports
--
--*****************************************************************************

-------------------------------------------------------------------------------
-- Stored Procedure :  strace_barcode_trace
--
-- Description      :   Procedure to get the trace report information for STRACE
--                      based trace.
--                      **** This is NOT called directly. Called using the wrapper
--                      **** barcode_trace SP
--                      **** This is ONLY for modular CM style machines
--
-- Parameters       :       @p_barcode_list     -- Panel Barcodes
--                          @p_model_no_list    -- Model numbers
--                          @p_part_no_list     -- Part numbers
--                          @p_vendor_list      -- Vendor numbers
--                          @p_lot_list         -- Lot numbers
--                          @p_user_data_list   -- User data
--                          @p_operator         -- Operator barcodes
--                          @p_reel_barcode     -- Reel barcodes
--                          @p_work_order_list  -- Work Orders
--                          @p_start_time       -- Start time
--                          @p_end_time         -- End time
--                          @p_equip_id_list    -- Equipment ID
--                          @p_serial_no_list   -- Panel Serial Numbers
--                          @p_NA_order_by      -- Not used
--                          @p_NA_is_PM         -- Not used
--                          @p_NA_include_userdata  -- Not used
--                          @p_NA_temp_tab_name     -- Not used--
-- Returns :
-------------------------------------------------------------------------------
EXEC usp_dropProcedure 'epv_admin.strace_barcode_trace'
GO
-------------------------------------------------------------------------------
CREATE PROCEDURE epv_admin.strace_barcode_trace(
    @p_barcode_list         NVARCHAR(MAX)  = NULL,
    @p_model_no_list        NVARCHAR(MAX)  = NULL,
    @p_part_no_list         NVARCHAR(MAX)  = NULL,
    @p_vendor_list          NVARCHAR(MAX)  = NULL,
    @p_lot_list             NVARCHAR(MAX)  = NULL,
    @p_user_data_list       NVARCHAR(MAX)  = NULL,
    @p_operator             NVARCHAR(MAX)  = NULL,
    @p_reel_barcode         NVARCHAR(MAX)  = NULL,
    @p_work_order_list      NVARCHAR(MAX)  = NULL,
    @p_start_time           NUMERIC(18,0)   = NULL,
    @p_end_time             NUMERIC(18,0)   = NULL,
    @p_equip_id_list        NVARCHAR(MAX)  = NULL,
    @p_serial_no_list       NVARCHAR(MAX)  = NULL,
    @p_NA_order_by          NVARCHAR(MAX)  = NULL,
    @p_NA_is_PM             NUMERIC(18,0)   = NULL,
    @p_NA_include_userdata  NUMERIC(18,0)   = NULL,
    @p_NA_temp_tab_name     NVARCHAR        = NULL
    ) 
WITH ENCRYPTION
AS
BEGIN

    SET NOCOUNT ON
    --
    -- Due the number of tables that are joined, SQL Server is not doing a 
    -- correct optimization. For the query to go based on the tables listed
    --
--    SET FORCEPLAN ON
    DECLARE @base_select_stmt    Epv_admin.BigVarchar2
    DECLARE @track_select_stmt    Epv_admin.BigVarchar2
    DECLARE @pattern_select_stmt    Epv_admin.BigVarchar2

    SET @base_select_stmt = ''

    -- The select statement is exceeding 4000 character. Due to the SQL Server restriction, 
    -- if we assign length of more than 4000, it silently truncates to 4000 chars even though 
    -- the variable is declared as VARCHAR(MAX). To work around this, we are initializing this 
    -- and then adding the string to the variable which is a VARCHAR(MAX)

    --
    -- In panel_strace_details we store the primary part number and substitute 
    -- part number. If there is any substitute part used, then the part_number 
    -- column will contain the substitute part number and the custom_area_4 
    -- will contain the expected / primary part number.
    -- 
    SET @base_select_stmt = @base_select_stmt + 'INSERT INTO #barcode_rep_table' + CHAR(13) +
                    ' SELECT   R.route_name,' + CHAR(13) +
                    '          Z.zone_name,' + CHAR(13) +
                    '          E.equipment_name,' + CHAR(13) +
                    '          PD.product_name, ' + CHAR(13) +
                    '          PRS.mix_name,' + CHAR(13) +
                    '          TD.prod_model_no, ' + CHAR(13) +
                    '          TD.barcode, ' + CHAR(13) +
                    '          PRS.top_bottom prod_side,' + CHAR(13) +
                    '          TD.serial_no, ' + CHAR(13) +
                    '          PTD.serial_no,' + CHAR(13) + -- Pattern serial #
                    '          P.end_time, ' + CHAR(13) +
                    '          PSD.pu_num, ' + CHAR(13) +
                    '          COALESCE(NCD.slot, MPU.slot),' + CHAR(13) +
                    '          dbo.udf_pu_subslot_to_hr_subslot(PSD.pu_num, COALESCE(NCD.subslot, MPU.subslot)),' + CHAR(13) +
                    '          RD.reel_barcode,' + CHAR(13) +
                    '          COALESCE(RD.part_no, PSD.part_no),' + CHAR(13) +
                    '          CASE WHEN PSD.custom_area4 IS NOT NULL THEN PSD.part_no ELSE NULL END expected_pn,' + CHAR(13) +
                    '          COALESCE(RD.lot_no, PSD.custom_area1),' + CHAR(13) +
                    '          COALESCE(RD.vendor_no,PSD.custom_area2),' + CHAR(13) +
                    '          PSD.feeder_bc, ' + CHAR(13) +
                    '          RD.quantity, ' + CHAR(13) +
                    '          P.start_time,' + CHAR(13) +
                    '          P.end_time,' + CHAR(13) +
                    '          O.operator_name, ' + CHAR(13) +
                    '          RD.user_data, ' + CHAR(13) +
                    '          JD.job_name,' + CHAR(13) +
                    '          RD.part_class,' + CHAR(13) +
                    '          RD.MCID,' + CHAR(13) +
                    '          PSH.equipment_id ' + CHAR(13)

    SET @base_select_stmt = @base_select_stmt + 
                    '    FROM tracking_data TD' + CHAR(13) +
                    ' JOIN  panels P ' + CHAR(13) +
                    ' ON   P.panel_id = TD.panel_id ' + CHAR(13) +
                    ' JOIN panel_strace_header  PSH' + CHAR(13) +
                    ' ON   PSH.panel_equipment_id = P.panel_equipment_id ' + CHAR(13) +
                    ' JOIN panel_strace_details PSD' + CHAR(13) +
                    ' ON PSD.panel_strace_id = PSH.master_strace_id ' + CHAR(13) +
                    ' LEFT OUTER JOIN  panel_details PAD' + CHAR(13) +
                    ' ON   PAD.barcode = TD.barcode' + CHAR(13) +
                    ' LEFT OUTER JOIN  pattern_details PTD' + CHAR(13) +
                    ' ON   PTD.panel_pattern_id = PAD.panel_pattern_id' + CHAR(13) +
                    ' LEFT OUTER JOIN  nc_summary           NCS' + CHAR(13) +
                    ' ON   NCS.nc_version = P.nc_version ' + CHAR(13) +
                    ' LEFT OUTER JOIN    nc_detail            NCD' + CHAR(13) +
                    ' ON   NCD.nc_version = P.nc_version ' + CHAR(13) +
                    ' AND   NCD.cassette = PSD.z_num  ' + CHAR(13) +
                    ' LEFT OUTER JOIN  product_setup        PRS' + CHAR(13) +
                    ' ON   PRS.setup_id = P.setup_id ' + CHAR(13) +
                    ' LEFT OUTER JOIN  product_data         PD' + CHAR(13) +
                    ' ON   PD.product_id = PRS.product_id ' + CHAR(13) +
                    ' JOIN  all_equipment_view E' + CHAR(13) +
                    ' ON   E.equipment_id = PSH.equipment_id ' + CHAR(13) +
                    ' JOIN all_zones_view Z' + CHAR(13) +
                    ' ON   Z.zone_id = E.zone_id ' + CHAR(13) +
                    ' JOIN all_routes_view R' + CHAR(13) +
                    ' ON   R.route_id      = E.route_id ' + CHAR(13) +
                    ' LEFT OUTER JOIN   reel_data            RD' + CHAR(13) +
                    ' ON   RD.reel_id = PSD.reel_id ' + CHAR(13) +
                    ' LEFT OUTER JOIN    job_detail          JD' + CHAR(13) +
                    ' ON JD.job_id = P.job_id' + CHAR(13) +
                    ' LEFT OUTER JOIN all_machine_slot_to_pu_view MPU ' + CHAR(13) +
                    ' ON MPU.equipment_id = PSH.equipment_id' + CHAR(13) +
                    ' AND MPU.z_number = PSD.z_num' + CHAR(13) +
                    ' LEFT OUTER JOIN operator O' + CHAR(13) +
                    ' ON CAST(O.operator_id AS NVARCHAR(20)) = PSD.custom_area3' + CHAR(13) +
                    ' WHERE 1 = 1 ' + CHAR(13) +
                        epv_admin.build_time_filter('P.end_time',       '>=',    @p_start_time) +
                        epv_admin.build_time_filter('P.start_time',     '<= ',  @p_end_time) +
                        epv_admin.build_where_clause('P.equipment_id',          @p_equip_id_list) + 
                        epv_admin.build_char_where_clause('RD.part_no',         @p_part_no_list ) +
                        epv_admin.build_char_where_clause('RD.vendor_no',       @p_vendor_list ) +
                        epv_admin.build_char_where_clause('RD.lot_no',          @p_lot_list ) +
                        epv_admin.build_char_where_clause('RD.user_data',       @p_user_data_list ) +
                        epv_admin.build_char_where_clause('O.operator_name',    @p_operator ) +
                        epv_admin.build_char_where_clause('RD.reel_barcode',    @p_reel_barcode ) +
                        epv_admin.build_char_where_clause('JD.job_name',        @p_work_order_list )
        -- 
        -- The given model / model + serial which is the barcode / serial_no can be in the tracking data or
        -- pattern_details or both. The simple way to do this is do an "OR" for example like
        -- AND (TD.serial_no IN (<input>) OR PTD.serial_no IN (<input>).
        -- But this is taking extremely long time
        -- Hence we get the details based on tracking data and then based on pattern_details
        --
        SET @track_select_stmt = @base_select_stmt + CHAR(13) +
                        epv_admin.build_char_where_clause('TD.prod_model_no',   @p_model_no_list ) + CHAR(13) +
                        epv_admin.build_char_where_clause('TD.prod_model_no+TD.serial_no',         @p_barcode_list ) + CHAR(13) +
                        epv_admin.build_char_where_clause('TD.serial_no',       @p_serial_no_list) 
        --  
        -- For the pattern details, we are doing a left outer join in the base query. So here ensure that
        -- we select only the records that has a barcode in the pattern details table as this is for
        -- patterns only
        --
        SET @pattern_select_stmt = @base_select_stmt + CHAR(13) +
                        epv_admin.build_char_where_clause('TD.prod_model_no',   @p_model_no_list ) + CHAR(13) +
                        epv_admin.build_char_where_clause('PTD.barcode',        @p_barcode_list ) + CHAR(13) +
                        epv_admin.build_char_where_clause('PTD.serial_no',      @p_serial_no_list) + CHAR(13) +
                        ' AND PTD.barcode IS NOT NULL ' + CHAR(13) +
                        ' AND NOT EXISTS (SELECT 1 ' + CHAR(13) +
                        '                 FROM   #barcode_rep_table T ' + CHAR(13) +
                        '                 WHERE   T.pattern_serial_no = PTD.serial_no) '

--print substring(@track_select_stmt,1,4000)
--print substring(@track_select_stmt,4001,4000)
    EXEC (@track_select_stmt)
--print substring(@pattern_select_stmt,1,4000)
--print substring(@pattern_select_stmt,4001,4000)
    EXEC (@pattern_select_stmt)
END 
GO

-------------------------------------------------------------------------------
-- Stored Procedure :  strack_barcode_trace
--
-- Description      :   Procedure to get the trace report information for STRACK
--                      based trace.
--                      **** This is NOT called directly. Called using the wrapper
--                      **** barcode_trace SP
--                      **** This is NM style machines (category 1 panasert) and 
--                      **** CM Style screen printer machines
--
-- Parameters       :       @p_barcode_list     -- Panel Barcodes
--                          @p_model_no_list    -- Model numbers
--                          @p_part_no_list     -- Part numbers
--                          @p_vendor_list      -- Vendor numbers
--                          @p_lot_list         -- Lot numbers
--                          @p_user_data_list   -- User data
--                          @p_operator         -- Operator barcodes
--                          @p_reel_barcode     -- Reel barcodes
--                          @p_work_order_list  -- Work Orders
--                          @p_start_time       -- Start time
--                          @p_end_time         -- End time
--                          @p_equip_id_list    -- Equipment ID
--                          @p_serial_no_list   -- Panel Serial Numbers
--                          @p_NA_order_by      -- Not used
--                          @p_NA_is_PM         -- Not used
--                          @p_NA_include_userdata  -- Not used
--                          @p_NA_temp_tab_name     -- Not used--
--                          @p_panel_equipment_id -- Panel Equipment ID
--                          *****  panel_equipment_id is NOT for EPV. *****
--                          ***** This same SP is used by ELInk also *****
-------------------------------------------------------------------------------
EXEC usp_dropProcedure 'epv_admin.strack_barcode_trace'
GO
-------------------------------------------------------------------------------
CREATE PROCEDURE epv_admin.strack_barcode_trace(
    @p_barcode_list         NVARCHAR(4000)  = NULL,
    @p_model_no_list        NVARCHAR(4000)  = NULL,
    @p_part_no_list         NVARCHAR(4000)  = NULL,
    @p_vendor_list          NVARCHAR(4000)  = NULL,
    @p_lot_list             NVARCHAR(4000)  = NULL,
    @p_user_data_list       NVARCHAR(4000)  = NULL,
    @p_operator             NVARCHAR(4000)  = NULL,
    @p_reel_barcode         NVARCHAR(4000)  = NULL,
    @p_work_order_list      NVARCHAR(4000)  = NULL,
    @p_start_time           NUMERIC(18,0)   = NULL,
    @p_end_time             NUMERIC(18,0)   = NULL,
    @p_equip_id_list        NVARCHAR(4000)  = NULL,
    @p_serial_no_list       NVARCHAR(4000)  = NULL,
    @p_NA_order_by          NVARCHAR(4000)  = NULL,
    @p_NA_is_PM             NUMERIC(18,0)   = NULL,
    @p_NA_include_userdata  NUMERIC(18,0)   = NULL,
    @p_NA_temp_tab_name     NVARCHAR        = NULL,
    @p_is_screen_printer    NVARCHAR(1)     = NULL,
    @p_panel_equipment_id   INT = NULL
    ) 
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON
    --
    -- Declare variables for holding the cursor statements
    --
    DECLARE @track_data_stmt NVARCHAR(MAX)
    DECLARE @ach_sql_stmt    NVARCHAR(MAX)
    DECLARE @ncd_sql_stmt   NVARCHAR(MAX)
    DECLARE @fh_sql_stmt    NVARCHAR(MAX)

    --
    -- Variables retrived using the track data cursor
    --
    DECLARE @v_route_name           NVARCHAR(20)
    DECLARE @v_zone_name            NVARCHAR(20)
    DECLARE @v_barcode              NVARCHAR(512)
    DECLARE @v_model_no             NVARCHAR(128)
    DECLARE @v_serial_no            NVARCHAR(128)
    DECLARE @v_panel_id             NUMERIC(18,0)
    DECLARE @v_equipment_id         NUMERIC(18,0)
    DECLARE @v_nc_version           NUMERIC(18,0)
    DECLARE @v_panel_start_time     NUMERIC(18,0)
    DECLARE @v_panel_end_time       NUMERIC(18,0)
    DECLARE @v_panel_equipment_id   NUMERIC(18,0)
    DECLARE @v_equipment_name       NVARCHAR(20)
    DECLARE @v_double_feeder_flag   NVARCHAR(1)
    DECLARE @v_mix_name             NVARCHAR(200)
    DECLARE @v_product_name         NVARCHAR(20)
    DECLARE @v_product_side         NVARCHAR(1)
    DECLARE @v_job_name             NVARCHAR(40)

    --
    -- Variables retrieved from active carriage history
    --
    DECLARE @ach_carriage_no NUMERIC(18,0)
    DECLARE @ach_slot_offset NUMERIC(18,0)
    --
    -- Variables retrieved from feeder history and reel data
    --
    DECLARE @v_reel_id          NUMERIC(18,0)
    DECLARE @v_reel_barcode     NVARCHAR(40)
    DECLARE @v_part_no          NVARCHAR(40)
    DECLARE @v_vendor_no        NVARCHAR(40)
    DECLARE @v_lot_no           NVARCHAR(40)
    DECLARE @v_quantity         NUMERIC(18,0)
    DECLARE @v_user_data        NVARCHAR(40)
    DECLARE @v_exp_part_no      NVARCHAR(40)
    DECLARE @v_operator_id      NUMERIC(18,0)
    DECLARE @v_feeder_barcode   VARCHAR(20)
    DECLARE @v_fh_slot          NUMERIC(18,0)
    DECLARE @v_fh_subslot       NUMERIC(18,0)
    DECLARE @v_fh_time_on       NUMERIC(18,0)
    DECLARE @v_fh_time_off      NUMERIC(18,0)
    DECLARE @v_operator_name    VARCHAR(20)
    DECLARE @v_part_class       VARCHAR(20)
    DECLARE @v_MCID             VARCHAR(30)
    DECLARE @v_material_name    VARCHAR(20)

    -- Drop Temporary Tables if exists
    EXEC epv_admin.drop_temp_table '#track_data_cur_table'
    EXEC epv_admin.drop_temp_table '#ach_cursor_table'
    EXEC epv_admin.drop_temp_table '#feeder_cur_table'

    -- Create Tables begins
        CREATE TABLE #track_data_cur_table
        (
            route_name  nvarchar(20),
            zone_name   nvarchar(20),
            prod_model_no   nvarchar(128),
            barcode nvarchar(400),
            serial_no   nvarchar(128),
            panel_id    numeric(18,0),
            equipment_id    numeric(18,0),
            panel_equipment_id  numeric(18,0),
            nc_version  numeric(18,0),
            start_time  numeric(18,0),
            end_time    numeric(18,0),
            equipment_name  nvarchar(20),
            double_feeder_mode  nvarchar(1),
            mix_name    nvarchar(40),
            product_name    nvarchar(20),
            top_bottom  nvarchar(1),
            job_name    nvarchar(40)
        )

        CREATE TABLE #ach_cursor_table
        (
            carriage_no NUMERIC(18,0),
            slot_offset NUMERIC(18,0)
        )



        CREATE TABLE #feeder_cur_table
        (
            reel_id numeric(18,0),
            reel_barcode_1  nvarchar(30),
            part_no nvarchar(30),
            reel_barcode    nvarchar(30),
            vendor_no   nvarchar(30),
            lot_no  nvarchar(30),
            quantity    numeric(18,0),
            user_data   nvarchar(30),
            expected_pn nvarchar(30),
            operator_id numeric(18,0),
            feeder_barcode  nvarchar(20),
            slot    numeric(18,0),
            subslot numeric(18,0),
            time_on numeric(18,0),
            time_off    numeric(18,0),
            operator_name   nvarchar(20),
            part_class  nvarchar(20),
            MCID    nvarchar(30),
            material_name   nvarchar(20),
        )
    -- Create Table Ends

    DECLARE @v_fh_z_no NUMERIC(18,0)
    SET @track_data_stmt = 'INSERT INTO #track_data_cur_table
                            SELECT R.route_name,
                                    Z.zone_name,
                                    TD.prod_model_no,
                                    TD.barcode,
                                    TD.serial_no,
                                    TD.panel_id,
                                    P.equipment_id,
                                    P.panel_equipment_id,
                                    P.nc_version,
                                    P.start_time,
                                    P.end_time,
                                    E.equipment_name,
                                    M.double_feeder_mode,
                                    PRS.mix_name,
                                    PD.product_name,
                                    PRS.top_bottom,
                                    JD.job_name
                            FROM    tracking_data TD
                            JOIN    panels P
                                ON P.panel_id = TD.panel_id
                            JOIN    all_equipment_view E
                                ON E.equipment_id = P.equipment_id
                            JOIN    all_machines_view M
                                ON M.equipment_id = P.equipment_id
                            LEFT OUTER JOIN    product_setup PRS
                                ON  PRS.setup_id = P.setup_id
                            LEFT OUTER JOIN nc_summary NCS
                                ON NCS.nc_version = P.nc_version
                            LEFT OUTER JOIN product_data PD
                                ON PD.product_id = PRS.product_id
                            LEFT OUTER JOIN job_detail JD
                                ON JD.job_id = P.job_id
                            JOIN all_zones_view Z
                                ON Z.zone_id = E.zone_id
                            JOIN all_routes_view R
                                ON R.route_id = E.route_id
                            WHERE 1 = 1 ' +
                            epv_admin.build_where_clause('P.equipment_id',  @p_equip_id_list) + 
                            epv_admin.build_time_filter('P.start_time', '>',    @p_start_time) +
                            epv_admin.build_time_filter('P.end_time',   '<= ',  @p_end_time) +
                            epv_admin.build_char_where_clause('TD.barcode',     @p_barcode_list) + 
                            epv_admin.build_char_where_clause('TD.prod_model_no',   @p_model_no_list) +
                            epv_admin.build_char_where_clause('TD.serial_no',   @p_serial_no_list) +
                            epv_admin.build_char_where_clause('JD.job_name',   @p_work_order_list) +
                            epv_admin.build_where_clause('P.panel_equipment_id',  @p_panel_equipment_id)

    EXEC SP_EXECUTESQL @track_data_stmt
--Print @track_data_stmt

    DECLARE track_data_cur CURSOR FOR SELECT * FROM #track_data_cur_table
    
    OPEN track_data_cur
    WHILE (1 = 1)  -- { Track Data Cursor
    BEGIN
        FETCH track_data_cur
        INTO  @v_route_name,
                @v_zone_name,
                @v_model_no,
                @v_barcode,
                @v_serial_no,
                @v_panel_id,
                @v_equipment_id,
                @v_panel_equipment_id,
                @v_nc_version,
                @v_panel_start_time,
                @v_panel_end_time,
                @v_equipment_name,
                @v_double_feeder_flag,
                @v_mix_name,
                @v_product_name,
                @v_product_side,
                @v_job_name

        IF @@FETCH_STATUS <> 0 
            BREAK

        -- For each track_data_cur loop, clean ach_cursor Table
        TRUNCATE TABLE #ach_cursor_table

        SET @ach_sql_stmt = 
                          ' INSERT INTO #ach_cursor_table 
                            SELECT  DISTINCT carriage_no,
                                    slot_offset
                            FROM    active_carriage_history ACH
                            WHERE   1 = 1 ' +
                          ' AND ACH.equipment_id = ' +  CAST(@v_equipment_id      AS NVARCHAR(15)) + 
                          ' AND ACH.end_time >= '        +  CAST(@v_panel_start_time  AS NVARCHAR(15)) +
                          ' AND ACH.start_time <= '      +  CAST( @v_panel_end_time   AS NVARCHAR(15))

        EXEC SP_EXECUTESQL @ach_sql_stmt
--print @ach_sql_stmt

        DECLARE ach_cursor CURSOR FOR SELECT * FROM #ach_cursor_table

        OPEN ach_cursor
        WHILE (1 = 1)
        BEGIN   -- { Active Carriage Cursor
            FETCH ach_cursor
            INTO  @ach_carriage_no,
                  @ach_slot_offset

            IF @@FETCH_STATUS <> 0 
                BREAK
            DECLARE @nc_join NVARCHAR(2000)
            --
            -- In the case of screen printers, we don't create nc_details. So join the table
            -- only in the case on NON-Screen Printers
            --
            IF @p_is_screen_printer = 'T'
            BEGIN
                SET @nc_join = ' WHERE 1 = 1 '
            END
            ELSE
            BEGIN
                SET @nc_join = 'JOIN  nc_detail NCD 
                                ON NCD.nc_version = ' + CAST(@v_nc_version AS NVARCHAR(15))  +
                            ' WHERE FH.slot = NCD.slot + ' + CAST(@ach_slot_offset AS NVARCHAR(15)) +
                            ' AND   FH.subslot = NCD.subslot ' 

            END 

            -- For each ach_cursor loop, clean feeder_cur Table
            TRUNCATE TABLE #feeder_cur_table

            SET @fh_sql_stmt = 
                            ' INSERT INTO #feeder_cur_table
                              SELECT  FH.reel_id,
                                        RD.reel_barcode AS reel_barcode_1,
                                        RD.part_no,
                                        RD.reel_barcode,
                                        RD.vendor_no,
                                        RD.lot_no,
                                        RD.quantity,
                                        RD.user_data,
                                        FH.expected_pn,
                                        FH.operator_id,
                                        F.feeder_barcode,
                                        FH.slot,
                                        FH.subslot,
                                        FH.time_on,
                                        FH.time_off,
                                        O.operator_name,
                                        RD.part_class,
                                        RD.MCID,
                                        FH.material_name
                            FROM feeder_history  FH
                            JOIN reel_data       RD 
                                ON RD.reel_id      = FH.reel_id
                            LEFT OUTER JOIN feeders F
                                ON F.feeder_id = FH.feeder_id
                            LEFT OUTER JOIN operator O
                                ON O.operator_id = FH.operator_id ' +
                            @nc_join +
                            ' AND   FH.equipment_id = ' + CAST(@v_equipment_id  AS NVARCHAR(15)) +
                            ' AND   FH.carriage_no = '  + CAST(@ach_carriage_no AS NVARCHAR(15)) +
                            ' AND   FH.time_off  >= '   + CAST( @v_panel_start_time AS NVARCHAR(15)) +
                            ' AND   FH.time_on <= '     + CAST( @v_panel_end_time AS NVARCHAR(15)) +
                            epv_admin.build_char_where_clause('RD.part_no',     @p_part_no_list ) +
                            epv_admin.build_char_where_clause('RD.vendor_no',   @p_vendor_list ) +
                            epv_admin.build_char_where_clause('RD.lot_no',      @p_lot_list ) +
                            epv_admin.build_char_where_clause('RD.user_data',   @p_user_data_list ) +
                            epv_admin.build_char_where_clause('O.operator_name',@p_operator ) +
                            epv_admin.build_char_where_clause('RD.reel_barcode',@p_reel_barcode ) +
                            ' ORDER  BY RD.part_no'

            EXEC SP_EXECUTESQL @fh_sql_stmt
            --print @fh_sql_stmt

             DECLARE feeder_cur CURSOR FOR SELECT * FROM #feeder_cur_table
            --print @fh_sql_stmt

            OPEN feeder_cur
            WHILE (1 = 1)
                BEGIN   -- { Feeder HistoryCursor
                    FETCH feeder_cur 
                    INTO  @v_reel_id, 
                            @v_reel_barcode,
                            @v_part_no,
                            @v_reel_barcode,
                            @v_vendor_no,
                            @v_lot_no,
                            @v_quantity,
                            @v_user_data,
                            @v_exp_part_no,
                            @v_operator_id,
                            @v_feeder_barcode,
                            @v_fh_slot,
                            @v_fh_subslot,
                            @v_fh_time_on,
                            @v_fh_time_off,
                            @v_operator_name,
                            @v_part_class,
                            @v_MCID,
                            @v_material_name

                IF @@FETCH_STATUS <> 0 
                    BREAK

                SET @v_fh_z_no = CASE @v_double_feeder_flag WHEN 'T' THEN ((@v_fh_slot*2) + @v_fh_subslot - 1) ELSE @v_fh_slot END
                DECLARE @z_no_str   NVARCHAR(20)
                --
                -- FOR SP machines, we have to print the material name in the z_no column
                --
                SET @z_no_str = COALESCE(@v_material_name, dbo.to_char100(@v_fh_z_no))
                INSERT INTO #barcode_rep_table
                VALUES
                (
                    @v_route_name,
                    @v_zone_name,
                    @v_equipment_name,
                    @v_product_name,
                    @v_mix_name,
                    @v_model_no,
                    @v_barcode,
                    @v_product_side,
                    @v_serial_no,
                    null, -- Pattern serial
                    @v_panel_start_time,
                    @z_no_str,
                    @v_fh_slot,
                    dbo.udf_NM_subslot_to_hr_subslot(@v_fh_subslot),
                    @v_reel_barcode,
                    @v_part_no,
                    @v_exp_part_no,
                    @v_lot_no,
                    @v_vendor_no,
                    @v_feeder_barcode,
                    @v_quantity,
                    @v_fh_time_on,
                    @v_fh_time_off,
                    @v_operator_name,
                    @v_user_data,
                    @v_job_name,
                    @v_part_class,
                    @v_MCID,
                    @v_equipment_id
                )
            END   -- } Feeder HistoryCursor
            CLOSE feeder_cur
            DEALLOCATE feeder_cur
        END   -- } Active Carriage Cursor
        CLOSE ach_cursor
        DEALLOCATE ach_cursor
    END   -- } Track Data Cursor
    CLOSE track_data_cur
    DEALLOCATE track_data_cur
    
    -- Drop all temporary tables
    EXEC epv_admin.drop_temp_table '#track_data_cur_table'
    EXEC epv_admin.drop_temp_table '#ach_cursor_table'
    EXEC epv_admin.drop_temp_table '#feeder_cur_table'
END
GO

-------------------------------------------------------------------------------
-- Stored Procedure :  strack_component_trace
--
-- Description      :   Procedure to get the trace report information for STRACK
--                      based trace.
--                      **** This is NOT called directly. Called using the wrapper
--                      **** barcode_trace SP
--                      **** This is NM style machines (category 1 panasert) and 
--                      **** CM Style screen printer machines
--                      **** This is used only if a component based information
--                      **** (part, vendor, lot...) only is given
--
-- Parameters       :       @p_barcode_list     -- Panel Barcodes
--                          @p_model_no_list    -- Model numbers
--                          @p_part_no_list     -- Part numbers
--                          @p_vendor_list      -- Vendor numbers
--                          @p_lot_list         -- Lot numbers
--                          @p_user_data_list   -- User data
--                          @p_operator         -- Operator barcodes
--                          @p_reel_barcode     -- Reel barcodes
--                          @p_work_order_list  -- Work Orders
--                          @p_start_time       -- Start time
--                          @p_end_time         -- End time
--                          @p_equip_id_list    -- Equipment ID
--                          @p_serial_no_list   -- Panel Serial Numbers
--                          @p_NA_order_by      -- Not used
--                          @p_NA_is_PM         -- Not used
--                          @p_NA_include_userdata  -- Not used
--                          @p_NA_temp_tab_name     -- Not used--
-------------------------------------------------------------------------------
EXEC usp_dropProcedure 'epv_admin.strack_component_trace'
GO
-------------------------------------------------------------------------------
CREATE PROCEDURE epv_admin.strack_component_trace(
    @p_barcode_list         NVARCHAR(4000)  = NULL,
    @p_model_no_list        NVARCHAR(4000)  = NULL,
    @p_part_no_list         NVARCHAR(4000)  = NULL,
    @p_vendor_list          NVARCHAR(4000)  = NULL,
    @p_lot_list             NVARCHAR(4000)  = NULL,
    @p_user_data_list       NVARCHAR(4000)  = NULL,
    @p_operator             NVARCHAR(4000)  = NULL,
    @p_reel_barcode         NVARCHAR(4000)  = NULL,
    @p_work_order_list      NVARCHAR(4000)  = NULL,
    @p_start_time           NUMERIC(18,0)   = NULL,
    @p_end_time             NUMERIC(18,0)   = NULL,
    @p_equip_id_list        NVARCHAR(4000)  = NULL,
    @p_serial_no_list       NVARCHAR(4000)  = NULL,
    @p_NA_order_by          NVARCHAR(4000)  = NULL,
    @p_NA_is_PM             NUMERIC(18,0)   = NULL,
    @p_NA_include_userdata  NUMERIC(18,0)   = NULL,
    @p_NA_temp_tab_name     NVARCHAR        = NULL,
    @p_is_screen_printer    NVARCHAR(1)     = NULL
)
WITH ENCRYPTION
AS
BEGIN
-- BOSE Update the @p_part_no_list / @p_barcode_list / @p_lot_list as needed
--CIMCS EDIT
-- remove comment if wish to search by part number and barcode
--
-- set @p_part_no_list = '310651-001,288449-002'
-- set @p_barcode_list = 'N0112104501323402000050,
-- N0113040401323402000050,
-- N0113066201323402000050,
-- N0091136301323402000050,
-- N0113051401323402000050,
-- N0113064201323402000050,
-- N0113066301323402000050,
-- N0112110001323402000050,
-- N0113024901323402000050,
-- N0112103001323402000050,
-- N0113062901323402000050,
-- N0113048901323402000050,
-- N0113055001323402000050,
-- N0112109801323402000050,
-- N0113042501323402000050'

--
-- search by lot number
--

--set @p_lot_list = '1024IG57Z'

    --
    -- Declare variables for holding the cursor statements
    --
    DECLARE @track_data_stmt NVARCHAR(MAX)
    DECLARE @ach_sql_stmt NVARCHAR(MAX)
    DECLARE @ncd_sql_stmt NVARCHAR(MAX)
    DECLARE @fh_sql_stmt  NVARCHAR(MAX)
    DECLARE @panel_sql_stmt NVARCHAR(MAX)

    --
    -- Variables retrieved from feeder history and reel data
    --
    DECLARE @v_reel_id          NUMERIC(18,0)
    DECLARE @v_reel_barcode     NVARCHAR(40)
    DECLARE @v_part_no          NVARCHAR(40)
    DECLARE @v_vendor_no        NVARCHAR(40)
    DECLARE @v_lot_no           NVARCHAR(40)
    DECLARE @v_quantity         NUMERIC(18,0)
    DECLARE @v_user_data        NVARCHAR(40)
    DECLARE @v_exp_part_no      NVARCHAR(40)
    DECLARE @v_operator_id      NUMERIC(18,0)
    DECLARE @v_feeder_barcode   VARCHAR(20)
    DECLARE @v_fh_carriage_no   NUMERIC(18,0)
    DECLARE @v_fh_slot          NUMERIC(18,0)
    DECLARE @v_fh_subslot       NUMERIC(18,0)
    DECLARE @v_fh_time_on       NUMERIC(18,0)
    DECLARE @v_fh_time_off      NUMERIC(18,0)
    DECLARE @v_org_fh_time_on       NUMERIC(18,0)
    DECLARE @v_org_fh_time_off      NUMERIC(18,0)
    DECLARE @v_operator_name    VARCHAR(20)
    DECLARE @v_route_name       NVARCHAR(20)
    DECLARE @v_zone_name        NVARCHAR(20)
    DECLARE @v_equipment_id     NUMERIC(18,0)
    DECLARE @v_equipment_name   NVARCHAR(20)
    DECLARE @v_part_class       NVARCHAR(20)
    DECLARE @v_MCID             NVARCHAR(20)
    DECLARE @v_material_name    NVARCHAR(20)

    DECLARE     @v_fh_z_no NUMERIC(18,0)
    --
    -- Variables retrieved from active carriage history
    --
    DECLARE     @v_ach_slot_offset NUMERIC(18,0)
    DECLARE     @v_ach_start_time NUMERIC(18,0)
    DECLARE     @v_ach_end_time NUMERIC(18,0)
    --
    -- Variables retrived using the track data cursor
    --
    DECLARE @v_panel_id             NUMERIC(18,0)
    DECLARE @v_panel_equipment_id   NUMERIC(18,0)
    DECLARE @v_lane_no              NUMERIC(18,0)
    DECLARE @v_stage_no             NUMERIC(18,0)
    DECLARE @v_nc_version           NUMERIC(18,0)
    DECLARE @v_panel_end_time       NUMERIC(18,0)
    DECLARE @v_barcode              NVARCHAR(512)
    DECLARE @v_model_no             NVARCHAR(128)
    DECLARE @v_serial_no            NVARCHAR(128)
    DECLARE @v_job_name             NVARCHAR(40)

    DECLARE @v_product_name     NVARCHAR(20)
    DECLARE @v_product_side     NVARCHAR(1)
    DECLARE @v_mix_name     NVARCHAR(200)
    DECLARE @v_panel_start_time      NUMERIC(18,0)
    DECLARE @v_double_feeder_flag NVARCHAR(1)

    DECLARE @module_id NUMERIC(18,0) -- ADDED BOSE

    -- Drop Temporary Tables if exists
    EXEC epv_admin.drop_temp_table '#feeder_cur_table'
    EXEC epv_admin.drop_temp_table '#ach_cursor_table'
    EXEC epv_admin.drop_temp_table '#panel_cur_table'

    -- Create Tables begins
        CREATE TABLE #feeder_cur_table
        (   
            reel_id NUMERIC(18,0),
            reel_barcode    NVARCHAR(30),
            part_no NVARCHAR(30),
            vendor_no   NVARCHAR(30),
            lot_no  NVARCHAR(30),
            quantity    NUMERIC(18,0),
            user_data   NVARCHAR(30),
            expected_pn NVARCHAR(30),
            operator_id NUMERIC(18,0),
            feeder_barcode  NVARCHAR(20),
            carriage_no NUMERIC(18,0),
            slot    NUMERIC(18,0),
            subslot NUMERIC(18,0),
            time_on NUMERIC(18,0),
            time_off    NUMERIC(18,0),
            operator_name   NVARCHAR(20),
            route_name  NVARCHAR(20),
            zone_name   NVARCHAR(20),
            equipment_name  NVARCHAR(20),
            part_class  NVARCHAR(20),
            MCID    NVARCHAR(30),
            material_name   NVARCHAR(20),
            equipment_id    NUMERIC(18,0)
        )

        CREATE TABLE #ach_cursor_table
        (   
            slot_offset NUMERIC(18,0),
            start_time  NUMERIC(18,0),
            end_time    NUMERIC(18,0)
        )

        CREATE TABLE #panel_cur_table
        (   
            panel_id    NUMERIC(18,0),
            panel_equipment_id  NUMERIC(18,0),
            lane_no NUMERIC(18,0),
            stage_no    NUMERIC(18,0),
            nc_version  NUMERIC(18,0),
            end_time    NUMERIC(18,0),
            prod_model_no   NVARCHAR(128),
            barcode NVARCHAR(400),
            serial_no   NVARCHAR(128),
            job_name    NVARCHAR(40),
            product_name    NVARCHAR(20),
            mix_name    NVARCHAR(40),
            prod_side   NVARCHAR(1),
            start_time  NUMERIC(18,0)
        )

    -- Create Tables Ends


    SET NOCOUNT ON

    SET @fh_sql_stmt = 
                    '    INSERT INTO #feeder_cur_table
                         SELECT  FH.reel_id,
                                RD.reel_barcode,
                                RD.part_no,
                                RD.vendor_no,
                                RD.lot_no,
                                RD.quantity,
                                RD.user_data,
                                FH.expected_pn,
                                FH.operator_id,
                                F.feeder_barcode,
                                FH.carriage_no,
                                FH.slot,
                                FH.subslot,
                                FH.time_on,
                                FH.time_off,
                                O.operator_name,
                                R.route_name,
                                Z.zone_name,
                                E.equipment_name,
                                RD.part_class,
                                null, 
                                FH.material_name,
                                FH.equipment_id
                    FROM feeder_history  FH
                    JOIN reel_data       RD 
                        ON RD.reel_id      = FH.reel_id
                    LEFT OUTER JOIN feeders F
                        ON F.feeder_id = FH.feeder_id
                    LEFT OUTER JOIN operator O
                        ON O.operator_id = FH.operator_id
                    JOIN all_equipment_view E
                        ON E.equipment_id = FH.equipment_id
                    JOIN all_zones_view Z
                        ON Z.zone_id = E.zone_id
                    JOIN all_routes_view R
                        ON R.route_id = E.route_id
                     WHERE 1 = 1'+
                    epv_admin.build_where_clause('FH.equipment_id',   @p_equip_id_list) + 
                    epv_admin.build_time_filter('FH.time_off ','>= ', @p_start_time) +
                    epv_admin.build_time_filter('FH.time_on',' <= ', @p_end_time ) +
                    epv_admin.build_char_where_clause('RD.part_no',@p_part_no_list ) +
                    epv_admin.build_char_where_clause('RD.vendor_no',@p_vendor_list ) +
                    epv_admin.build_char_where_clause('RD.lot_no',@p_lot_list ) +
                    epv_admin.build_char_where_clause('RD.user_data',@p_user_data_list ) +
                    epv_admin.build_char_where_clause('O.operator_name',@p_operator ) +
                    epv_admin.build_char_where_clause('RD.reel_barcode',@p_reel_barcode ) +
                    ' ORDER  BY RD.part_no '
    EXEC SP_EXECUTESQL @fh_sql_stmt
 --print @fh_sql_stmt

    DECLARE feeder_cur CURSOR FOR SELECT * FROM #feeder_cur_table

    OPEN feeder_cur
    WHILE (1 = 1)
    BEGIN   -- { Feeder HistoryCursor
        FETCH feeder_cur 
        INTO  @v_reel_id,
                @v_reel_barcode,
                @v_part_no,
                @v_vendor_no,
                @v_lot_no,
                @v_quantity,
                @v_user_data,
                @v_exp_part_no,
                @v_operator_id,
                @v_feeder_barcode,
                @v_fh_carriage_no,
                @v_fh_slot,
                @v_fh_subslot,
                @v_fh_time_on,
                @v_fh_time_off,
                @v_operator_name,
                @v_route_name,
                @v_zone_name,
                @v_equipment_name,
                @v_part_class,
                @v_MCID,
                @v_material_name,
                @v_equipment_id
        IF @@FETCH_STATUS <> 0 
            BREAK

		-- ADDED FOR BOSE
		SELECT @module_id = z2.zone_id 
			FROM all_equipment_view e
		LEFT OUTER JOIN zones z1 ON z1.zone_id = e.zone_id
		LEFT OUTER JOIN zones z2 ON z2.zone_id = z1.module_id
		WHERE equipment_id = @v_equipment_id

        SET @v_org_fh_time_on = @v_fh_time_on
        SET @v_org_fh_time_off = @v_fh_time_off
        IF COALESCE(@p_start_time, 0) > 0 
        BEGIN
            IF @v_fh_time_on < @p_start_time
               SET @v_fh_time_on = @p_start_time;
        END

        IF COALESCE(@p_end_time, 0) > 0 
        BEGIN
            IF @v_fh_time_off > @p_end_time 
               SET @v_fh_time_off = @p_end_time
        END

        TRUNCATE TABLE #ach_cursor_table
--print 'ach'
        SET @ach_sql_stmt = 
                            ' INSERT INTO #ach_cursor_table
                              SELECT ACH.slot_offset,
                                    ACH.start_time,
                                    ACH.end_time
                             FROM   active_carriage_history ACH
                             WHERE  1 = 1 ' +
                            ' AND ACH.start_time <=  ' + CAST( @v_fh_time_off  AS NVARCHAR(10)) +
                            ' AND  ACH.end_time >= '   + CAST(@v_fh_time_on AS NVARCHAR(10)) +
                            ' AND  ACH.carriage_no = '  + CAST(@v_fh_carriage_no AS NVARCHAR(10)) +
                            ' AND ACH.equipment_id = '  + CAST(@v_equipment_id AS NVARCHAR(10)) +
                            ' ORDER BY end_time, carriage_no '
--print @ach_sql_stmt
        EXEC SP_EXECUTESQL @ach_sql_stmt

        DECLARE ach_cursor CURSOR FOR SELECT * FROM #ach_cursor_table

        OPEN ach_cursor

        WHILE (1 = 1)
        BEGIN   -- { Active carriage History Cursor
            FETCH ach_cursor 
            INTO  @v_ach_slot_offset, 
                  @v_ach_start_time,
                  @v_ach_end_time
            IF @@FETCH_STATUS <> 0 
                BREAK

            IF @v_ach_start_time < @v_fh_time_on 
               SET @v_ach_start_time = @v_fh_time_on
 
            IF  @v_ach_end_time > @v_fh_time_off 
                SET @v_ach_end_time = @v_fh_time_off
            --
            -- In the case of screen printers, we don't create nc_details. So join the table
            -- only in the case on NON-Screen Printers
            --
            DECLARE @nc_join NVARCHAR(2000)
            IF @p_is_screen_printer = 'T'
            BEGIN
                SET @nc_join = ' '
            END
            ELSE
            BEGIN
                SET @nc_join = ' JOIN    nc_detail NCD ' +
                                    ' ON NCD.nc_version = NCS.nc_version ' +
                                   ' AND NCD.slot = ' + CAST(@v_fh_slot AS NVARCHAR(10)) +
                                   ' AND NCD.subslot = ' +  CAST(@v_fh_subslot AS NVARCHAR(10)) 

            END 

            TRUNCATE TABLE #panel_cur_table

            SET @panel_sql_stmt = 
                                  ' INSERT INTO #panel_cur_table
                                    SELECT P.panel_id,
                                            P.module_id,
                                            dbo.udf_Get_Display_Lane_No(P.lane_no) as [lane_no],
                                            0, '+ -- P.stage_no,
                                            '-1, ' + -- 'P.nc_version,
                                            'P.timestamp,
                                            TD.prod_model_no,
                                            TD.barcode,
                                            TD.serial_no,
                                            null,
                                            PD.product_name,
                                            PRS.mix_name,
                                            PRS.top_bottom prod_side,
                                            P.timestamp
                                    FROM   panel_barcode_map P
                                    JOIN   tracking_data TD
                                        ON  TD.panel_id = P.panel_id ' +
--                                    JOIN    nc_summary NCS
--                                        ON NCS.nc_version = P.nc_version '+
--                                    @nc_join +
--                                    ' LEFT OUTER JOIN job_detail JD
--                                        ON JD.job_id = P.job_id 
                                      'LEFT OUTER JOIN  product_setup        PRS
                                          ON   PRS.setup_id = P.setup_id 
                                      LEFT OUTER JOIN  product_data         PD
                                          ON   PD.product_id = PRS.product_id ' +
                                    ' WHERE  P.module_id = ' + CAST(@module_id AS NVARCHAR(20)) + --+ CAST(@v_equipment_id AS NVARCHAR(10)) + -- MODIFIED FOR BOSE
                                    ' AND    P.timestamp    >= ' +  CAST(@v_ach_start_time AS NVARCHAR(10)) +
                                    ' AND    P.timestamp <= ' +  CAST(@v_ach_end_time AS NVARCHAR(10)) +
                                    epv_admin.build_char_where_clause('JD.job_name',   @p_work_order_list) 

            EXEC SP_EXECUTESQL @panel_sql_stmt
-- print @panel_sql_stmt

            DECLARE panel_cur CURSOR FOR SELECT * FROM #panel_cur_table

            OPEN panel_cur

            WHILE (1 = 1)
            BEGIN   -- { Panel Cursor
                FETCH panel_cur 
                INTO  @v_panel_id,
                        @v_panel_equipment_id,
                        @v_lane_no,
                        @v_stage_no,
                        @v_nc_version,
                        @v_panel_end_time,
                        @v_model_no,
                        @v_barcode,
                        @v_serial_no,
                        @v_job_name,
                        @v_product_name,
                        @v_mix_name,
                        @v_product_side,
                        @v_panel_start_time
            IF @@FETCH_STATUS <> 0 
                BREAK
            SET @v_fh_z_no = CASE @v_double_feeder_flag WHEN 'T' THEN ((@v_fh_slot*2) + @v_fh_subslot - 1) ELSE @v_fh_slot END
            DECLARE @z_no_str   NVARCHAR(20)
            --
            -- FOR SP machines, we have to print the material name in the z_no column
            --
            SET @z_no_str = COALESCE(@v_material_name, dbo.to_char100(@v_fh_z_no))
                INSERT INTO #barcode_rep_table
                VALUES
                (
                    @v_route_name,
                    @v_zone_name,
                    @v_equipment_name,
                    @v_product_name,
                    @v_mix_name,
                    @v_model_no,
                    @v_barcode,
                    @v_product_side,
                    @v_serial_no,
                    null, -- Pattern serial no
                    @v_panel_start_time,
                    @z_no_str,
                    @v_fh_slot,
                    dbo.udf_NM_subslot_to_hr_subslot(@v_fh_subslot),
                    @v_reel_barcode,
                    @v_part_no,
                    @v_exp_part_no,
                    @v_lot_no,
                    @v_vendor_no,
                    @v_feeder_barcode,
                    @v_quantity,
                    @v_org_fh_time_on,
                    @v_org_fh_time_off,
                    @v_operator_name,
                    @v_user_data,
                    @v_job_name,
                    @v_part_class,
                    @v_MCID,
                    @v_equipment_id
                )
            END
            CLOSE panel_cur
            DEALLOCATE panel_cur
        END   -- }  Active carriage History Cursor
        CLOSE ach_cursor
        DEALLOCATE ach_cursor
    END
    CLOSE feeder_cur
    DEALLOCATE feeder_cur

    -- Drop Temporary Tables if exists
    EXEC epv_admin.drop_temp_table '##feeder_cur_table'
    EXEC epv_admin.drop_temp_table '##ach_cursor_table'
    EXEC epv_admin.drop_temp_table '##panel_cur_table'
END
GO

-------------------------------------------------------------------------------
-- Stored Procedure :  special_aoi_trace
--
-- Description      :   Procedure to get the AOI Repairinformation 
--                      **** This is NOT called directly. Called using the wrapper
--                      **** barcode_trace SP
--                      **** This is ONLY for AOI Repair data
--
-- Parameters       :       @p_barcode_list     -- Panel Barcodes
--                          @p_model_no_list    -- Model numbers
--                          @p_part_no_list     -- Part numbers
--                          @p_vendor_list      -- Vendor numbers
--                          @p_lot_list         -- Lot numbers
--                          @p_user_data_list   -- User data
--                          @p_operator         -- Operator barcodes
--                          @p_reel_barcode     -- Reel barcodes
--                          @p_work_order_list  -- Work Orders
--                          @p_start_time       -- Start time
--                          @p_end_time         -- End time
--                          @p_equip_id_list    -- Equipment ID
--                          @p_serial_no_list   -- Panel Serial Numbers
--                          @p_NA_order_by      -- Not used
--                          @p_NA_is_PM         -- Not used
--                          @p_NA_include_userdata  -- Not used
--                          @p_NA_temp_tab_name     -- Not used--
-- Returns :
-------------------------------------------------------------------------------
EXEC usp_dropProcedure 'epv_admin.special_aoi_trace'
GO
-------------------------------------------------------------------------------
CREATE PROCEDURE epv_admin.special_aoi_trace(
    @p_barcode_list         NVARCHAR(MAX)  = NULL,
    @p_model_no_list        NVARCHAR(MAX)  = NULL,
    @p_part_no_list         NVARCHAR(MAX)  = NULL,
    @p_vendor_list          NVARCHAR(MAX)  = NULL,
    @p_lot_list             NVARCHAR(MAX)  = NULL,
    @p_user_data_list       NVARCHAR(MAX)  = NULL,
    @p_operator             NVARCHAR(MAX)  = NULL,
    @p_reel_barcode         NVARCHAR(MAX)  = NULL,
    @p_work_order_list      NVARCHAR(MAX)  = NULL,
    @p_start_time           NUMERIC(18,0)   = NULL,
    @p_end_time             NUMERIC(18,0)   = NULL,
    @p_equip_id_list        NVARCHAR(MAX)  = NULL,
    @p_serial_no_list       NVARCHAR(MAX)  = NULL,
    @p_NA_order_by          NVARCHAR(MAX)  = NULL,
    @p_NA_is_PM             NUMERIC(18,0)   = NULL,
    @p_NA_include_userdata  NUMERIC(18,0)   = NULL,
    @p_NA_temp_tab_name     NVARCHAR        = NULL
    ) 
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @base_select_stmt    Epv_admin.BigVarchar2

    --
    SET @base_select_stmt ='INSERT INTO #barcode_rep_table
                            SELECT      R.route_name,
                                     Z.zone_name,
                                     AE.aoi_equipment_name,
                                     PD.product_name, 
                                     PRS.mix_name,
                                     TD.prod_model_no, 
                                     TD.barcode, 
                                     PRS.top_bottom prod_side,
                                     TD.serial_no, 
                                    PTD.serial_no, -- Pattern serial #
                                     P.end_time, 
                                     NULL AS pu_num, 
                                     NULL AS slot,
                                     NULL AS subslot,
                                     NULL AS reel_barcode,
                                     ARD.part_no,
                                     null expected_pn, 
                                     ARD.lot_no,
                                     NULL AS vendor_no,
                                     NULL AS feeder_bc, 
                                     NULL AS quantity, 
                                     ARH.repair_time start_time,
                                     NULL end_time,
                                     AO.aoi_operator_name, 
                                     NULL AS user_data, 
                                     JD.job_name AS job_name, 
                                     NULL AS part_class,
                                     NULL AS MCID,
                                     P.equipment_id
                          FROM tracking_data TD
                          JOIN  aoi_repair_hdr ARH
                              ON ARH.panel_id = TD.panel_id
                          JOIN  aoi_repair_dtl ARD
                              ON ARD.aoi_repair_id = ARH.aoi_repair_id
                          JOIN  panels P 
                              ON   P.panel_id = TD.panel_id 
                          LEFT OUTER JOIN aoi_equipments AE
                                ON AE.aoi_equipment_code = ARH.aoi_equipment_code
                          LEFT OUTER JOIN  panel_details PAD
                              ON   PAD.barcode = TD.barcode
                          LEFT OUTER JOIN  pattern_details PTD
                              ON   PTD.panel_pattern_id = PAD.panel_pattern_id
                          LEFT OUTER JOIN  product_setup        PRS
                              ON   PRS.setup_id = P.setup_id 
                          LEFT OUTER JOIN  product_data         PD
                              ON   PD.product_id = PRS.product_id 
                          JOIN  all_equipment_view E
                              ON   E.equipment_id = P.equipment_id 
                          JOIN all_zones_view Z
                              ON   Z.zone_id = E.zone_id 
                          JOIN all_routes_view R
                              ON   R.route_id      = E.route_id 
                        LEFT OUTER JOIN    job_detail          JD
                            ON JD.job_id = P.job_id
                        LEFT OUTER JOIN aoi_operators AO
                            ON AO.aoi_operator_code = ARH.aoi_operator_code
                        WHERE 1 = 1 
                        AND ARD.part_no IS NOT NULL AND ARD.part_no != '''' ' +
                        epv_admin.build_time_filter('ARH.repair_time',       '>', @p_start_time) +
                        epv_admin.build_time_filter('ARH.repair_time',     '<= ', @p_end_time) +
                        epv_admin.build_where_clause('P.equipment_id',   @p_equip_id_list) + 
                        epv_admin.build_char_where_clause('ARD.part_no',         @p_part_no_list ) +
--                        epv_admin.build_char_where_clause('RD.vendor_no',       @p_vendor_list ) +
                        epv_admin.build_char_where_clause('ARD.lot_no',          @p_lot_list ) +
--                        epv_admin.build_char_where_clause('RD.user_data',       @p_user_data_list ) +
--                        epv_admin.build_char_where_clause('O.operator_name',    @p_operator ) +
--                        epv_admin.build_char_where_clause('RD.reel_barcode',    @p_reel_barcode )
                        epv_admin.build_char_where_clause('TD.prod_model_no',   @p_model_no_list ) +
                        epv_admin.build_char_where_clause('TD.prod_model_no+TD.serial_no',         @p_barcode_list ) +
                        epv_admin.build_char_where_clause('TD.serial_no',       @p_serial_no_list) +
                        epv_admin.build_char_where_clause('JD.job_name',        @p_work_order_list) 
-- Please note the where clause statements that are NOT applicable are intentionally commented
-- out intead of removing it. In case if we support this in the future, we can just uncomment it
--print @base_select_stmt
    EXEC (@base_select_stmt)
END 
GO

-------------------------------------------------------------------------------
EXEC usp_dropProcedure 'epv_admin.barcode_trace'
GO
-------------------------------------------------------------------------------
-- Stored Procedure :   barcode_trace
--
-- Description      :   SP for the barcode trace report procedure. This is the
--                      Entry point for the following reports
--                      -- Panel To component trace
--                      -- Component to Panel trace
--
-- Parameters       :       @p_barcode_list     -- Panel Barcodes
--                          @p_model_no_list    -- Model numbers
--                          @p_part_no_list     -- Part numbers
--                          @p_vendor_list      -- Vendor numbers
--                          @p_lot_list         -- Lot numbers
--                          @p_user_data_list   -- User data
--                          @p_operator         -- Operator barcodes
--                          @p_reel_barcode     -- Reel barcodes
--                          @p_work_order_list  -- Work Orders
--                          @p_start_time       -- Start time
--                          @p_end_time         -- End time
--                          @p_equip_id_list    -- Equipment ID
--                          @p_serial_no_list   -- Panel Serial Numbers
--                          @p_NA_order_by      -- Not used
--                          @p_NA_is_PM         -- Not used
--                          @p_NA_include_userdata  -- Not used
--                          @p_NA_temp_tab_name     -- Not used
--
-- Returns          :   None
-------------------------------------------------------------------------------
EXEC usp_dropProcedure 'epv_admin.barcode_trace'
GO
-------------------------------------------------------------------------------
CREATE PROCEDURE epv_admin.barcode_trace(
    @p_barcode_list         NVARCHAR(4000)  = NULL,
    @p_model_no_list        NVARCHAR(4000)  = NULL,
    @p_part_no_list         NVARCHAR(4000)  = NULL,
    @p_vendor_list          NVARCHAR(4000)  = NULL,
    @p_lot_list             NVARCHAR(4000)  = NULL,
    @p_user_data_list       NVARCHAR(4000)  = NULL,
    @p_operator             NVARCHAR(4000)  = NULL,
    @p_reel_barcode         NVARCHAR(4000)  = NULL,
    @p_work_order_list      NVARCHAR(4000)  = NULL,
    @p_start_time           NUMERIC(18,0)   = NULL,
    @p_end_time             NUMERIC(18,0)   = NULL,
    @p_equip_id_list        NVARCHAR(4000)  = NULL,
    @p_serial_no_list       NVARCHAR(4000)  = NULL,
    @p_NA_order_by          NVARCHAR(4000)  = NULL,
    @p_NA_is_PM             NUMERIC(18,0)   = NULL,
    @p_NA_include_userdata  NUMERIC(18,0)   = NULL,
    @p_NA_temp_tab_name     NVARCHAR        = NULL
)
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON
    CREATE TABLE #barcode_rep_table
    (
        route_name      VARCHAR(200),
        zone_name       VARCHAR(200),
        equipment_name  VARCHAR(200),
        pcb_name        VARCHAR(200),
        setup_name      VARCHAR(200),
        prod_model_no   VARCHAR(128),
        barcode         VARCHAR(512),
        prod_side       VARCHAR(200),
        serial_no       VARCHAR(128),
        pattern_serial_no VARCHAR(128),
        release_time    NUMERIC(18,0),
        z_no            VARCHAR(200),
        slot            NUMERIC(18,0),
        subslot         VARCHAR(200),
        reel_barcode    VARCHAR(200), 
        part_no         VARCHAR(200),
        expected_pn     VARCHAR(200),
        lot_no          VARCHAR(200),
        vendor_no       VARCHAR(200),
        feeder_barcode  VARCHAR(200),
        quantity        NUMERIC(18,0),
        time_on         NUMERIC(18,0),
        time_off        NUMERIC(18,0),
        operator_name   VARCHAR(200),
        user_data       VARCHAR(200),
        job_name        VARCHAR(400),
        part_class      VARCHAR(200),
        MCID            VARCHAR(200),
        EQUIP_ID        NUMERIC(18,0)
    )
    --
    -- Flag to indicate if we have to do track based (barcode or 
    -- model or serial) OR part based (part, vendor, lot....)
    --
    DECLARE @tracking_based VARCHAR(1)
    SET @tracking_based  = 'T'
    --
    --  The report accepts both track info as well as reel info. Based on the
    --  input we have to different procs to get the best performance.
    --  Component trace is very slow as it has to go through the feeder history
    --  and depending on the input can scan the complete table. So avoid this
    --  as far as possible
    --  If no track info is given and reel info is given, then call the
    --  comp trace. Otherwise always call the barcode trace
    --
    IF COALESCE(@p_barcode_list,'') <> '' OR
        COALESCE(@p_model_no_list ,'') <> '' OR
        COALESCE(@p_serial_no_list,'') <> '' 
    BEGIN
        SET @tracking_based = 'T'
    END
    ELSE IF COALESCE(@p_part_no_list,'') <> '' OR
        COALESCE(@p_vendor_list,'') <> '' OR
        COALESCE(@p_lot_list,'') <> '' OR
        COALESCE(@p_user_data_list,'') <> '' OR 
        COALESCE(@p_reel_barcode,'') <> '' 
    BEGIN
        SET @tracking_based = 'F'
    END

    DECLARE @v_nm_equip_ids VARCHAR(MAX)
    DECLARE @v_cm_modular_equip_ids VARCHAR(MAX)
    DECLARE @v_cm_screen_printer_equip_ids VARCHAR(MAX)
    --
    -- Based on the given list of equipment IDs extract the various kinds of machines
    -- For each of the following kinds, we have to do things differently
    --  NM machines (Category 1) - This is based on the STRACK mechanism where the data is
    --                              retrived based on active carriage history
    --  CM modular machines (Category 2) -- This is based on STRACE 
    --
    EXEC epv_admin.get_NM_equip_ids @p_equip_id_list,  @v_nm_equip_ids  OUTPUT
    EXEC epv_admin.get_CM_modular_equip_ids @p_equip_id_list, @v_cm_modular_equip_ids OUTPUT
    EXEC epv_admin.get_CM_screen_printer_equip_ids @p_equip_id_list, @v_cm_screen_printer_equip_ids OUTPUT
    DECLARE @use_tracking_base INT
SET @use_tracking_base= dbo.C_TRUE()
set @v_nm_equip_ids = @v_cm_modular_equip_ids
EXEC epv_admin.strack_component_trace
             @p_barcode_list,
             @p_model_no_list,
             @p_part_no_list,
             @p_vendor_list,
             @p_lot_list,
             @p_user_data_list,
             @p_operator,
             @p_reel_barcode,
             @p_work_order_list,
             @p_start_time,
             @p_end_time,
             @v_nm_equip_ids,
             @p_serial_no_list,
             @p_NA_order_by,
             @p_NA_is_PM,
             @p_NA_include_userdata,
             @p_NA_temp_tab_name,
             'F' -- @p_is_screen_printer 
    SELECT * FROM #barcode_rep_table

return
    IF COALESCE(@v_cm_modular_equip_ids,'') != '' 
    BEGIN
        PRINT 'Calling strace_barcode_trace for Modular machines: ' +  @v_cm_modular_equip_ids
        EXEC epv_admin.strace_barcode_trace
                        @p_barcode_list,
                        @p_model_no_list,
                        @p_part_no_list,
                        @p_vendor_list,
                        @p_lot_list,
                        @p_user_data_list,
                        @p_operator,
                        @p_reel_barcode,
                        @p_work_order_list,
                        @p_start_time,
                        @p_end_time,
                        @v_cm_modular_equip_ids,
                        @p_serial_no_list,
                        @p_NA_order_by,
                        @p_NA_is_PM,
                        @p_NA_include_userdata,
                        @p_NA_temp_tab_name 
    END

    IF @tracking_based = 'T' 
    BEGIN
        IF @v_cm_screen_printer_equip_ids IS NOT NULL
        BEGIN
            PRINT 'Calling strack_barcode_trace for CM Screen Printer Style machines: ' + @v_cm_screen_printer_equip_ids
            EXEC epv_admin.strack_barcode_trace
                         @p_barcode_list,
                         @p_model_no_list,
                         @p_part_no_list,
                         @p_vendor_list,
                         @p_lot_list,
                         @p_user_data_list,
                         @p_operator,
                         @p_reel_barcode,
                         @p_work_order_list,
                         @p_start_time,
                         @p_end_time,
                         @v_cm_screen_printer_equip_ids,
                         @p_serial_no_list,
                         @p_NA_order_by,
                         @p_NA_is_PM,
                         @p_NA_include_userdata,
                         @p_NA_temp_tab_name,
                         'T' -- @p_is_screen_printer
        END
        IF @v_nm_equip_ids IS NOT NULL
        BEGIN
            PRINT 'Calling strack_barcode_trace for Traditional machines: '+ @v_nm_equip_ids
            EXEC epv_admin.strack_barcode_trace
                         @p_barcode_list,
                         @p_model_no_list,
                         @p_part_no_list,
                         @p_vendor_list,
                         @p_lot_list,
                         @p_user_data_list,
                         @p_operator,
                         @p_reel_barcode,
                         @p_work_order_list,
                         @p_start_time,
                         @p_end_time,
                         @v_nm_equip_ids,
                         @p_serial_no_list,
                         @p_NA_order_by,
                         @p_NA_is_PM,
                         @p_NA_include_userdata,
                         @p_NA_temp_tab_name,
                         'F' -- @p_is_screen_printer
        END
    END
    ELSE    -- @tracking_based = 'F'
    BEGIN
        IF COALESCE(@v_nm_equip_ids,'') != '' 
        BEGIN
            PRINT 'Calling strack_component_trace for NM Style machines: ' + @v_nm_equip_ids
            EXEC epv_admin.strack_component_trace
                         @p_barcode_list,
                         @p_model_no_list,
                         @p_part_no_list,
                         @p_vendor_list,
                         @p_lot_list,
                         @p_user_data_list,
                         @p_operator,
                         @p_reel_barcode,
                         @p_work_order_list,
                         @p_start_time,
                         @p_end_time,
                         @v_nm_equip_ids,
                         @p_serial_no_list,
                         @p_NA_order_by,
                         @p_NA_is_PM,
                         @p_NA_include_userdata,
                         @p_NA_temp_tab_name,
                         'F' -- @p_is_screen_printer 
        END
        ELSE IF @v_cm_screen_printer_equip_ids IS NOT NULL
        BEGIN
            PRINT 'Calling strack_barcode_trace for CM Screen Printer machines: '+ @v_cm_screen_printer_equip_ids
            EXEC epv_admin.strack_component_trace
                         @p_barcode_list,
                         @p_model_no_list,
                         @p_part_no_list,
                         @p_vendor_list,
                         @p_lot_list,
                         @p_user_data_list,
                         @p_operator,
                         @p_reel_barcode,
                         @p_work_order_list,
                         @p_start_time,
                         @p_end_time,
                         @v_cm_screen_printer_equip_ids,
                         @p_serial_no_list,
                         @p_NA_order_by,
                         @p_NA_is_PM,
                         @p_NA_include_userdata,
                         @p_NA_temp_tab_name ,
                         'T' -- @p_is_screen_printer
        END

    END

    IF (epv_admin.udf_special_aoi_flag() = 'T')
    BEGIN
            PRINT 'Calling aoi data'
            EXEC epv_admin.special_aoi_trace
                         @p_barcode_list,
                         @p_model_no_list,
                         @p_part_no_list,
                         @p_vendor_list,
                         @p_lot_list,
                         @p_user_data_list,
                         @p_operator,
                         @p_reel_barcode,
                         @p_work_order_list,
                         @p_start_time,
                         @p_end_time,
                         @p_equip_id_list,
                         @p_serial_no_list,
                         @p_NA_order_by,
                         @p_NA_is_PM,
                         @p_NA_include_userdata,
                         @p_NA_temp_tab_name 
    END
    SELECT * FROM #barcode_rep_table
END
GO

-------------------------------------------------------------------------------
-- Stored Procedure :   mountlog_trace
--
-- Description      :   SP for the Mount Log trace report procedure. 
--
-- Parameters       :       @p_barcode_list     -- Panel Barcodes
--                          @p_model_no_list    -- Model numbers
--                          @p_part_no_list     -- Part numbers
--                          @p_vendor_list      -- Vendor numbers
--                          @p_lot_list         -- Lot numbers
--                          @p_user_data_list   -- User data
--                          @p_operator         -- Operator barcodes
--                          @p_reel_barcode     -- Reel barcodes
--                          @p_work_order_list  -- Work Orders
--                          @p_start_time       -- Start time
--                          @p_end_time         -- End time
--                          @p_equip_id_list    -- Equipment ID
--                          @p_serial_no_list   -- Panel Serial Numbers
--                          @p_NA_order_by      -- Not used
--                          @p_NA_is_PM         -- Not used
--                          @p_NA_include_userdata  -- Not used
--                          @p_NA_temp_tab_name     -- Not used
--
-- Returns          :   None
-------------------------------------------------------------------------------
EXEC usp_dropProcedure 'epv_admin.mountlog_trace'
GO
-------------------------------------------------------------------------------
CREATE PROCEDURE epv_admin.mountlog_trace
(
    @p_barcode_list         NVARCHAR(MAX) = NULL,
    @p_model_no_list         NVARCHAR(MAX) = NULL,
    @p_part_list            NVARCHAR(MAX) = NULL,
    @p_vendor_list          NVARCHAR(MAX) = NULL,
    @p_lot_list             NVARCHAR(MAX) = NULL,
    @p_user_data_list       NVARCHAR(MAX) = NULL,
    @p_operator_list        NVARCHAR(MAX) = NULL,
    @p_reel_barcode         NVARCHAR(MAX) = NULL,
    @p_job                  NVARCHAR(MAX) = NULL,
    @p_start_time           INT = NULL,
    @p_end_time             INT = NULL,
    @p_equip_id_list        NVARCHAR(MAX) = NULL,
    @p_serial_no            NVARCHAR(MAX) = NULL,
    @p_order_by             NVARCHAR(500) = NULL,
    @p_isPM                 INT=NULL,
    @p_includeuserdata      INT=NULL,
    @p_temptable_name       NVARCHAR(254)=NULL,
    @p_ref_designator       NVARCHAR(40)=NULL,
    @p_useTracePartFilter bit=0
)
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @base_select_stmt    Epv_admin.BigVarchar2
    DECLARE @track_select_stmt    Epv_admin.BigVarchar2
    DECLARE @pattern_select_stmt    Epv_admin.BigVarchar2

    CREATE TABLE #mount_log_rep_table
    (
        route_name      VARCHAR(200),
        zone_name       VARCHAR(200),
        equipment_name  VARCHAR(200),
        lane_no         INT,
        stage_no        INT,
        product_name    NVARCHAR(200),
        mix_name        NVARCHAR(200),
        prod_model_no   VARCHAR(128),
        barcode         VARCHAR(512),
        prod_side       VARCHAR(200),
        serial_no       VARCHAR(128),
        pattern_serial_no VARCHAR(128),
        release_time    VARCHAR(200),
        z_no            VARCHAR(200),
        slot            NUMERIC(18,0),
        subslot         NUMERIC(18,0),
        part_no         VARCHAR(200),
        ref_designator  VARCHAR(200),
        lot_no          VARCHAR(200),
        vendor_no       VARCHAR(200),
        user_data       VARCHAR(200), 
        part_class      VARCHAR(200),
        MCID            VARCHAR(200)
    )

    --
    -- Lane number is zero based in panels
    --
    SET @base_select_stmt = 'INSERT INTO #mount_log_rep_table
                SELECT   R.route_name     line_name,
                          Z.zone_name        zone_name,
                          E.equipment_name   equipment_name,
                          dbo.udf_Get_Display_Lane_No(P.lane_no) as [lane_no],
                          P.stage_no         stage_no,
                          PD.product_name    PCB_name, 
                          PRS.mix_name       mix_name,
                          TD.prod_model_no, 
                          TD.barcode, 
                          PRS.top_bottom prod_side,
                          TD.serial_no, 
                          PTD.serial_no, 
                          P.end_time, 
                          MLV.pu_num, 
                          COALESCE(NCD.slot, MPU.slot) slot,
                          COALESCE(NCD.subslot, MPU.subslot) subslot,
                          COALESCE(RD.part_no, MLV.part_no) part_no,
                          NPD.ref_designator ref_designator, 
                          COALESCE(RD.lot_no,  MLV.custom_area1) lot_no,
                          COALESCE(RD.vendor_no, MLV.custom_area2) vendor_no,
                          RD.user_data,
                          RD.part_class,
                          RD.MCID
                 FROM  mount_log_view MLV
                 JOIN nc_placement_detail NPD
                     ON  NPD.nc_placement_id = MLV.nc_placement_id
                 JOIN  panels P 
                     ON   P.panel_equipment_id = MLV.panel_equipment_id 
                 JOIN tracking_data TD
                     ON   TD.panel_id = P.panel_id
                  LEFT OUTER JOIN  panel_details PAD
                      ON   PAD.barcode = TD.barcode
                  LEFT OUTER JOIN  pattern_details PTD
                      ON   PTD.panel_pattern_id = PAD.panel_pattern_id
                 JOIN all_equipment_view E
                     ON   E.equipment_id = MLV.equipment_id 
                 JOIN all_zones_view Z
                     ON   Z.zone_id = E.zone_id 
                 JOIN all_routes_view R
                     ON   R.route_id      = E.route_id 
                 LEFT OUTER JOIN   reel_data            RD
                     ON   RD.reel_id = MLV.reel_id 
                 LEFT OUTER JOIN  nc_summary           NCS
                     ON   NCS.nc_version = P.nc_version 
                 LEFT OUTER JOIN    nc_detail            NCD
                     ON   NCD.nc_version = P.nc_version 
                     AND   NCD.cassette = MLV.z_num  
                 JOIN  product_setup        PRS
                     ON   PRS.setup_id = P.setup_id 
                 JOIN  product_data         PD
                     ON   PD.product_id = PRS.product_id 
                 LEFT OUTER JOIN    job_detail          JD
                     ON JD.job_id = P.job_id
                 LEFT OUTER JOIN all_machine_slot_to_pu_view MPU 
                     ON MPU.equipment_id = MLV.equipment_id
                     AND MPU.z_number = MLV.z_num
--               LEFT OUTER JOIN operator O
--               ON CAST(O.operator_id AS NVARCHAR(20)) = MLV.custom_area3
                 WHERE 1 = 1 ' +
                 epv_admin.build_time_filter('P.end_time', '>', @p_start_time) +
                 epv_admin.build_time_filter('P.start_time', '<= ', @p_end_time) +
                 epv_admin.build_where_clause('P.equipment_id', @p_equip_id_list) + 
                 epv_admin.build_char_where_clause('RD.part_no', @p_part_list ) +
                 epv_admin.build_char_where_clause('RD.vendor_no', @p_vendor_list ) +
                 epv_admin.build_char_where_clause('RD.lot_no', @p_lot_list ) +
                 epv_admin.build_char_where_clause('RD.user_data', @p_user_data_list ) +
--               epv_admin.build_char_where_clause('O.operator_name', @p_operator_list ) +
                 epv_admin.build_char_where_clause('RD.reel_barcode', @p_reel_barcode ) 
        -- 
        -- The given model / model + serial which is the barcode / serial_no can be in the tracking data or
        -- pattern_details or both. The simple way to do this is do an "OR" for example like
        -- AND (TD.serial_no IN (<input>) OR PTD.serial_no IN (<input>).
        -- But this is taking extremely long time
        -- Hence we get the details based on tracking data and then based on pattern_details
        --
        SET @track_select_stmt = @base_select_stmt + 
                        epv_admin.build_char_where_clause('TD.prod_model_no',   @p_model_no_list ) +
                        epv_admin.build_char_where_clause('TD.prod_model_no+TD.serial_no',         @p_barcode_list ) +
                        epv_admin.build_char_where_clause('TD.serial_no',       @p_serial_no) 

        SET @pattern_select_stmt = @base_select_stmt + 
                        epv_admin.build_char_where_clause('TD.prod_model_no',   @p_model_no_list ) +
                        epv_admin.build_char_where_clause('PTD.barcode',         @p_barcode_list ) +
                        epv_admin.build_char_where_clause('PTD.serial_no',       @p_serial_no) +
                        ' AND PTD.barcode IS NOT NULL ' +
                        ' AND NOT EXISTS (SELECT 1
                                          FROM   #mount_log_rep_table T
                                          WHERE   T.pattern_serial_no = PTD.serial_no)'


    EXEC (@track_select_stmt)
    EXEC (@pattern_select_stmt)
    SELECT * FROM #mount_log_rep_table ORDER BY serial_no, equipment_name, lane_no, stage_no, z_no

END
GO

--
-- BOSE update change the start (1286604000), end time  (1286856000),  equipment_id (1027) as needed
--Update 1286604000 with start time, Update 1286856000 with end time, Update 1027 with equiptment ID
--
--exec EPV_ADMIN.BARCODE_TRACE NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',1286604000,1286856000,'1027',NULL,'PART_NO',NULL,0,NULL --,NULL --,'0,1,2'
-- PASCZ Updates
--  2085	CM212-L11M1-SMT11	1	CM402.xpm	T	M		1305008228	1305701926
--  4390	CM402-L1M1-SMT1		1	CM402.xpm	T	M		1305826656	1306247924
--  3892	CM402-L2M1-SMT2		1	CM402.xpm	T	M		1305492545	1305863366
--  4007	CM402-L3M1-SMT3		1	CM402.xpm	T	M		1304970600	1304976502

--  3491	CM402-L4M1-SMT4		1	CM402.xpm	T	M		1305263325	1305765483	FAIL	1306879915
--  3491	CM402-L4M1-SMT4		1	CM402.xpm	T	M		1305765528	1306879915	FAIL	1305263325

--	2890	CM402-L5M1-SMT5		1	CM402.xpm	T	M		1305763227	1306228682
--	2187	CM402-L6M1-SMT6		1	CM402.xpm	T	M		1304894402	1305833754
--	4795	CM602-L10M2-SMT10	1	CM402.xpm	T	M		1305789985	1306239332
--	2892	CM602-L5M2-SMT5		1	CM402.xpm	T	M		1305763381	1306228810
--	4771	CM602-L6M2-SMT6		1	CM402.xpm	T	M		1304894510	1305833589
--	4799	DT401-L10M3-SMT10	1	CM401.xpm	T	M		1305885824	1306239336	none
--	4401	DT401-L1M2-SMT1		1	CM401.xpm	T	M		1304954782	1306247966
--	3894	DT401-L2M2-SMT2		1	CM401.xpm	T	M		1305492678	1305863318
--	3990	DT401-L3M2-SMT3		1	CM401.xpm	T	M		1304970682	1304976558
--	2894	DT401-L5M3-SMT5		1	CM401.xpm	T	M		1305328904	1306228999
--	2189	DT401-L6M3-SMT6		1	CM401.xpm	T	M		1304894450	1307447488
--
--CIMCS EDIT 'Start time', 'end time' and 'Equipment ID'
--
exec EPV_ADMIN.BARCODE_TRACE NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',1429160400,1429246799,'1006',NULL,'PART_NO',NULL,0,NULL --,NULL --,'0,1,2'
-- exec EPV_ADMIN.BARCODE_TRACE NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',1411621260,1411707660,'1008',NULL,'PART_NO',NULL,0,NULL --,NULL --,'0,1,2'
--CREATE PROCEDURE epv_admin.barcode_trace(
--    @p_barcode_list         NVARCHAR(4000)  = NULL,
--    @p_model_no_list        NVARCHAR(4000)  = NULL,
--    @p_part_no_list         NVARCHAR(4000)  = NULL,
--    @p_vendor_list          NVARCHAR(4000)  = NULL,
--    @p_lot_list             NVARCHAR(4000)  = NULL,
--    @p_user_data_list       NVARCHAR(4000)  = NULL,
--    @p_operator             NVARCHAR(4000)  = NULL,
--    @p_reel_barcode         NVARCHAR(4000)  = NULL,
--    @p_work_order_list      NVARCHAR(4000)  = NULL,
--    @p_start_time           NUMERIC(18,0)   = NULL,
--    @p_end_time             NUMERIC(18,0)   = NULL,
--    @p_equip_id_list        NVARCHAR(4000)  = NULL,
--    @p_serial_no_list       NVARCHAR(4000)  = NULL,
--    @p_NA_order_by          NVARCHAR(4000)  = NULL,
--    @p_NA_is_PM             NUMERIC(18,0)   = NULL,
--    @p_NA_include_userdata  NUMERIC(18,0)   = NULL,
--    @p_NA_temp_tab_name     NVARCHAR        = NULL