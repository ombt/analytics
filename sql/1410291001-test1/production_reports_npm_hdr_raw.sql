USE CICOR_20151016_OFFICIAL
GO
SELECT count(*) FROM production_reports_npm_hdr_raw
GO
TRUNCATE TABLE production_reports_npm_hdr_raw
GO
SELECT count(*) FROM production_reports_npm_hdr_raw
GO
SET IDENTITY_INSERT production_reports_npm_hdr_raw ON
GO
INSERT INTO production_reports_npm_hdr_raw (REPORT_ID,PRODUCT_ID,EQUIPMENT_ID,START_TIME,END_TIME,SETUP_ID,NC_VERSION,LANE_NO,JOB_ID,TRX_PRODUCTID,STAGE,TIMESTAMP,PREV_REPORT_ID)  VALUES ( 1000,1073,1000,1413375682,1413375683,1134,41206,1,1165,'20141015072123090+-+01+-+1+-+1+-+0+-++-+12+-++-+0',1,1413375683,0 )
GO
INSERT INTO production_reports_npm_hdr_raw (REPORT_ID,PRODUCT_ID,EQUIPMENT_ID,START_TIME,END_TIME,SETUP_ID,NC_VERSION,LANE_NO,JOB_ID,TRX_PRODUCTID,STAGE,TIMESTAMP,PREV_REPORT_ID)  VALUES ( 1001,1073,1000,1413375683,1413375743,1134,41206,1,1165,'20141015072223032+-+01+-+1+-+1+-+0+-++-+12+-++',1,1413375743,1000 )
GO
INSERT INTO production_reports_npm_hdr_raw (REPORT_ID,PRODUCT_ID,EQUIPMENT_ID,START_TIME,END_TIME,SETUP_ID,NC_VERSION,LANE_NO,JOB_ID,TRX_PRODUCTID,STAGE,TIMESTAMP,PREV_REPORT_ID)  VALUES ( 1002,1073,1000,1413375743,1413375803,1134,41206,1,1165,'20141015072323483+-+01+-+1+-+1+-+0+-++-+12+-++-+',1,1413375803,1001 )
GO
SELECT count(*) FROM production_reports_npm_hdr_raw
GO
SET IDENTITY_INSERT production_reports_npm_hdr_raw OFF
GO
BYE
