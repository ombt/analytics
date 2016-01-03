select MAX(PANEL_ID) as tracking_data_PANEL_ID_Max from [dbo].[tracking_data]
select COUNT(PANEL_ID) as tracking_data_PANEL_ID_Count from [dbo].[tracking_data]
go
select MAX(PATTERN_ID) as tracking_data_PATTERN_ID_Max from [dbo].[tracking_data]
select COUNT(PATTERN_ID) as tracking_data_PATTERN_ID_Count from [dbo].[tracking_data]
go
select MAX(PANEL_ID) as panels_PANEL_ID_Max from [dbo].[panels]
go
select MAX(PANEL_ID) as panel_seq_PANEL_ID_Max from [dbo].[panel_seq]
go
select MAX(PANEL_ID) as pattern_seq_PANEL_ID_Max from [dbo].[pattern_seq]
go
select COUNT(PANEL_ID) as panel_seq_PANEL_ID_Count from [dbo].[panel_seq]
go
select COUNT(PANEL_ID) as pattern_seq_PANEL_ID_Count from [dbo].[pattern_seq]
go

