select 
    max(sh.panel_equipment_id) as max_sh_panel_equipment_id
from
    panel_strace_header sh
go

select 
    max(p.panel_equipment_id) as  max_p_panel_equipment_id
from
    panels p
go

select 
    max(p.panel_id) as max_p_panel_i
from
    panels p
go

select 
    max(td.panel_id) as max_td_panel_id
from
    tracking_data td
go

select 
    max(panel_id) as tracking_data_panel_id 
from 
    [dbo].[tracking_data]
go

select 
    max(panel_id) as panels_panel_id 
from 
    [dbo].[panels]
go

select 
    max(panel_id) as panel_seq_panel_id 
from 
    [dbo].[panel_seq]
go

select 
    max(panel_id) as pattern_seq_panel_id 
from 
    [dbo].[pattern_seq]
go

select 
    count(panel_id) as panel_seq_panel_id_count 
from 
    [dbo].[panel_seq]
go

select 
    max(panel_id) as pattern_seq_panel_id_max
from 
    [dbo].[pattern_seq]
go

select 
    max(panel_id) as pattern_seq_panel_id_max
from 
    [dbo].[pattern_seq]
go

select MAX(PANEL_ID) as tracking_data_PANEL_ID_Max from [dbo].[tracking_data]
go
select MAX(PATTERN_ID) as tracking_data_PATTERN_ID_Max from [dbo].[tracking_data]
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

