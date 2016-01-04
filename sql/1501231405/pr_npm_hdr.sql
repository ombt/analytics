-- production_reports_npm_hdr report_id
-- production_reports_npm_hdr product_id
-- production_reports_npm_hdr equipment_id
-- production_reports_npm_hdr start_time
-- production_reports_npm_hdr end_time
-- production_reports_npm_hdr setup_id
-- production_reports_npm_hdr nc_version
-- production_reports_npm_hdr lane_no
-- production_reports_npm_hdr job_id
-- production_reports_npm_hdr trx_productid
-- production_reports_npm_hdr stage
-- production_reports_npm_hdr timestamp

-- production_reports_npm report_id
-- production_reports_npm total
-- production_reports_npm actual
-- production_reports_npm board
-- production_reports_npm pboard
-- production_reports_npm module
-- production_reports_npm hsup
-- production_reports_npm clean
-- production_reports_npm brec
-- production_reports_npm maintenance
-- production_reports_npm ope_rate
-- production_reports_npm pickup_rate
-- production_reports_npm mount_rate
-- production_reports_npm mount
-- production_reports_npm recog_err1
-- production_reports_npm recog_err2
-- production_reports_npm floortemp
-- production_reports_npm floorhumid
-- production_reports_npm mctemp
-- production_reports_npm mchumid
-- production_reports_npm thermostatus
-- production_reports_npm waitt
-- production_reports_npm poweron
-- production_reports_npm change
-- production_reports_npm prodview
-- production_reports_npm mente
-- production_reports_npm dataedit
-- production_reports_npm unitadjust
-- production_reports_npm idle
-- production_reports_npm load
-- production_reports_npm breg
-- production_reports_npm tpickup
-- production_reports_npm tpmiss
-- production_reports_npm trmiss
-- production_reports_npm tdmiss
-- production_reports_npm tmmiss
-- production_reports_npm thmiss
-- production_reports_npm timestamp
-- production_reports_npm prod_time
-- production_reports_npm brcg_time
-- production_reports_npm othrstop_time
-- production_reports_npm mhrcgstop_time
-- production_reports_npm cperr_time
-- production_reports_npm otherlstop_time
-- production_reports_npm bndstop_time
-- production_reports_npm mcfwait_time
-- production_reports_npm mcrwait_time
-- production_reports_npm fwait_time
-- production_reports_npm rwait_time
-- production_reports_npm swait_time
-- production_reports_npm cwait_time
-- production_reports_npm bwait_time
-- production_reports_npm pwait_time
-- production_reports_npm scstop_time
-- production_reports_npm scestop_time
-- production_reports_npm cnvstop_time
-- production_reports_npm brcgstop_time
-- production_reports_npm trbl_time
-- production_reports_npm fbstop_time
-- production_reports_npm bndrcgstop_time
-- production_reports_npm crerr_time
-- production_reports_npm cderr_time
-- production_reports_npm cmerr_time
-- production_reports_npm cterr_time
-- production_reports_npm trserr_time
-- production_reports_npm prdstop_time
-- production_reports_npm judgestop_time
-- production_reports_npm mount_time
-- production_reports_npm total_time
-- production_reports_npm caerr_time
-- production_reports_npm cpwait_time
-- production_reports_npm mskrecerrstop_time
-- production_reports_npm mskpstrecerrstop_time
-- production_reports_npm bprcgstop_time
-- production_reports_npm sothrstop_time
-- production_reports_npm pcustop_time
-- production_reports_npm bestop_time
-- production_reports_npm twait_time
-- production_reports_npm hcwait_time
-- production_reports_npm hswait_time
-- production_reports_npm pstrecerrstop_time
-- production_reports_npm solvnonstop_time
-- production_reports_npm fwait_count
-- production_reports_npm rwait_count
-- production_reports_npm swait_count
-- production_reports_npm cwait_count
-- production_reports_npm bwait_count
-- production_reports_npm pwait_count
-- production_reports_npm scstop_count
-- production_reports_npm scestop_count
-- production_reports_npm othrstop_count
-- production_reports_npm cnvstop_count
-- production_reports_npm brcgstop_count
-- production_reports_npm trbl_count
-- production_reports_npm mhrcgstop_count
-- production_reports_npm fbstop_count
-- production_reports_npm bndrcgstop_count
-- production_reports_npm cperr_count
-- production_reports_npm crerr_count
-- production_reports_npm cderr_count
-- production_reports_npm cmerr_count
-- production_reports_npm cterr_count
-- production_reports_npm trserr_count
-- production_reports_npm trsmiss_count
-- production_reports_npm otherlstop_count
-- production_reports_npm bndstop_count
-- production_reports_npm tdispense_count
-- production_reports_npm tpriming_count
-- production_reports_npm lotboard_count
-- production_reports_npm lotmodule_count
-- production_reports_npm mcfwait_count
-- production_reports_npm mcrwait_count
-- production_reports_npm caerr_count
-- production_reports_npm cpwait_count
-- production_reports_npm mskrecerrstop_count
-- production_reports_npm mskpstrecerrstop_count
-- production_reports_npm bprcgstop_count
-- production_reports_npm sothrstop_count
-- production_reports_npm pcustop_count
-- production_reports_npm bestop_count
-- production_reports_npm twait_count
-- production_reports_npm hcwait_count
-- production_reports_npm hswait_count
-- production_reports_npm pstrecerrstop_count
-- production_reports_npm total_count
-- production_reports_npm solvnonstop_count
-- production_reports_npm spdlenerrstop_time
-- production_reports_npm spdpstcntupstop_time
-- production_reports_npm spdpstnonstop_time
-- production_reports_npm spdpapernonstop_time
-- production_reports_npm spdmskrecerrstop_time
-- production_reports_npm spdpstrecerrstop_time
-- production_reports_npm spdsolvnonstop_time
-- production_reports_npm spdlenerrstop_count
-- production_reports_npm spdpstcntupstop_count
-- production_reports_npm spdpstnonstop_count
-- production_reports_npm spdpapernonstop_count
-- production_reports_npm spdmskrecerrstop_count
-- production_reports_npm spdpstrecerrstop_count
-- production_reports_npm spdsolvnonstop_count
-- production_reports_npm spdreccnt_count
-- production_reports_npm spdprintcnt_count
-- production_reports_npm spdclncnt_count
-- production_reports_npm spdpstsupplycnt_count
-- production_reports_npm spdfbclncnt_count
-- production_reports_npm spdfbprintcnt_count
-- production_reports_npm spdrestorationcnt_count
-- production_reports_npm jwait_time

select
    prnh.report_id,
    prnh.product_id,
    prnh.equipment_id,
    prnh.start_time,
    prnh.end_time,
    prnh.setup_id,
    prnh.nc_version,
    prnh.lane_no,
    prnh.job_id,
    prnh.trx_productid,
    prnh.stage,
    prnh.timestamp
from
    production_reports_npm_hdr prnh,
    production_reports_npm prn
where
    prnh.start_time >= prnh.end_time
and
    prn.report_id = prnh.report_id
go

select
    count(*) as 'count_equal'
from
    production_reports_npm_hdr prnh
where
    prnh.start_time = prnh.end_time
go

select
    count(*) as 'count_greater'
from
    production_reports_npm_hdr prnh
where
    prnh.start_time > prnh.end_time
go

select
    count(*) as 'count_less'
from
    production_reports_npm_hdr prnh
where
    prnh.start_time < prnh.end_time
go

