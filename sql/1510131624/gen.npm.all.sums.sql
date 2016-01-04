-- 
-- dgs_nc_placement_detail dgs_product_data_id
-- dgs_nc_placement_detail dgs_product_setup_id
-- dgs_nc_placement_detail idnum
-- dgs_nc_placement_detail ref_designator
-- dgs_nc_placement_detail part_name
-- dgs_nc_placement_detail pattern_number
-- 
-- dgs_nc_summary dgs_product_data_id
-- dgs_nc_summary physical_equipment_id
-- dgs_nc_summary dgs_glue_total
-- 
-- feeder_counts feeder_id
-- feeder_counts subslot
-- feeder_counts components_fed
-- feeder_counts total_components_fed
-- feeder_counts update_time
-- feeder_counts placement_count
-- feeder_counts total_placement_count
-- feeder_counts pickup_miss
-- feeder_counts total_pickup_miss
-- feeder_counts pickup_error
-- feeder_counts total_pickup_error
-- feeder_counts shape_error
-- feeder_counts total_shape_error
-- feeder_counts recognition_error
-- feeder_counts total_recognition_error
-- 
-- nc_detail nc_version
-- nc_detail cassette
-- nc_detail slot
-- nc_detail subslot
-- nc_detail tva
-- 
-- nc_placement_detail nc_placement_id
-- nc_placement_detail idnum
-- nc_placement_detail ref_designator
-- nc_placement_detail part_name
-- nc_placement_detail pattern_number
-- nc_placement_detail nc_version
-- 
-- nc_summary setup_id
-- nc_summary equipment_id
-- nc_summary nc_version
-- nc_summary tva
-- nc_summary double_feeder_flag
-- nc_summary glue_total
-- nc_summary solder_total
-- 
-- nozzle_npm report_id
-- nozzle_npm lot
-- nozzle_npm stage
-- nozzle_npm tprod
-- nozzle_npm head
-- nozzle_npm ncadd
-- nozzle_npm nhadd
-- nozzle_npm tcnt
-- nozzle_npm tmiss
-- nozzle_npm rmiss
-- nozzle_npm hmiss
-- nozzle_npm board
-- nozzle_npm nozzlenum
-- nozzle_npm nblkcode
-- nozzle_npm nblkserial
-- nozzle_npm fmiss
-- nozzle_npm mmiss
-- nozzle_npm place_count
-- nozzle_npm trsmiss
-- nozzle_npm timestamp
-- 
-- nozzle_npm_by_board report_id
-- nozzle_npm_by_board lot
-- nozzle_npm_by_board stage
-- nozzle_npm_by_board tprod
-- nozzle_npm_by_board head
-- nozzle_npm_by_board ncadd
-- nozzle_npm_by_board nhadd
-- nozzle_npm_by_board tcnt
-- nozzle_npm_by_board tmiss
-- nozzle_npm_by_board rmiss
-- nozzle_npm_by_board hmiss
-- nozzle_npm_by_board board
-- nozzle_npm_by_board nozzlenum
-- nozzle_npm_by_board nblkcode
-- nozzle_npm_by_board nblkserial
-- nozzle_npm_by_board fmiss
-- nozzle_npm_by_board mmiss
-- nozzle_npm_by_board place_count
-- nozzle_npm_by_board trsmiss
-- nozzle_npm_by_board timestamp
-- 
-- nozzle_npm_hdr report_id
-- nozzle_npm_hdr product_id
-- nozzle_npm_hdr equipment_id
-- nozzle_npm_hdr start_time
-- nozzle_npm_hdr end_time
-- nozzle_npm_hdr setup_id
-- nozzle_npm_hdr nc_version
-- nozzle_npm_hdr lane_no
-- nozzle_npm_hdr job_id
-- nozzle_npm_hdr trx_productid
-- nozzle_npm_hdr stage
-- nozzle_npm_hdr timestamp
-- 
-- nozzle_npm_hdr_by_board report_id
-- nozzle_npm_hdr_by_board product_id
-- nozzle_npm_hdr_by_board equipment_id
-- nozzle_npm_hdr_by_board start_time
-- nozzle_npm_hdr_by_board end_time
-- nozzle_npm_hdr_by_board setup_id
-- nozzle_npm_hdr_by_board nc_version
-- nozzle_npm_hdr_by_board lane_no
-- nozzle_npm_hdr_by_board job_id
-- nozzle_npm_hdr_by_board trx_productid
-- nozzle_npm_hdr_by_board stage
-- nozzle_npm_hdr_by_board timestamp
-- 
-- nozzle_npm_hdr_raw report_id
-- nozzle_npm_hdr_raw product_id
-- nozzle_npm_hdr_raw equipment_id
-- nozzle_npm_hdr_raw start_time
-- nozzle_npm_hdr_raw end_time
-- nozzle_npm_hdr_raw setup_id
-- nozzle_npm_hdr_raw nc_version
-- nozzle_npm_hdr_raw lane_no
-- nozzle_npm_hdr_raw job_id
-- nozzle_npm_hdr_raw trx_productid
-- nozzle_npm_hdr_raw stage
-- nozzle_npm_hdr_raw timestamp
-- 
-- nozzle_npm_raw report_id
-- nozzle_npm_raw lot
-- nozzle_npm_raw stage
-- nozzle_npm_raw tprod
-- nozzle_npm_raw head
-- nozzle_npm_raw ncadd
-- nozzle_npm_raw nhadd
-- nozzle_npm_raw tcnt
-- nozzle_npm_raw tmiss
-- nozzle_npm_raw rmiss
-- nozzle_npm_raw hmiss
-- nozzle_npm_raw board
-- nozzle_npm_raw nozzlenum
-- nozzle_npm_raw nblkcode
-- nozzle_npm_raw nblkserial
-- nozzle_npm_raw fmiss
-- nozzle_npm_raw mmiss
-- nozzle_npm_raw place_count
-- nozzle_npm_raw trsmiss
-- nozzle_npm_raw timestamp
-- 
-- panel_barcode_map module_id
-- panel_barcode_map panel_id
-- panel_barcode_map panel_id_string
-- panel_barcode_map timestamp
-- panel_barcode_map lane_no
-- panel_barcode_map setup_id
-- 
-- panel_placement_details panel_placement_id
-- panel_placement_details reel_id
-- panel_placement_details nc_placement_id
-- panel_placement_details pattern_no
-- panel_placement_details z_num
-- panel_placement_details pu_num
-- panel_placement_details part_no
-- panel_placement_details custom_area1
-- panel_placement_details custom_area2
-- panel_placement_details custom_area3
-- panel_placement_details custom_area4
-- panel_placement_details ref_designator
-- 
-- panel_placement_header panel_equipment_id
-- panel_placement_header equipment_id
-- panel_placement_header master_placement_id
-- panel_placement_header panel_placement_id
-- panel_placement_header timestamp
-- panel_placement_header trx_product_id
-- 
-- panel_production_reports_uvs equipment_id
-- panel_production_reports_uvs product_id
-- panel_production_reports_uvs start_time
-- panel_production_reports_uvs end_time
-- panel_production_reports_uvs setup_id
-- panel_production_reports_uvs panel_id
-- panel_production_reports_uvs cycle_time
-- 
-- panels panel_id
-- panels equipment_id
-- panels nc_version
-- panels start_time
-- panels end_time
-- panels panel_equipment_id
-- panels panel_source
-- panels panel_trace
-- panels stage_no
-- panels lane_no
-- panels job_id
-- panels setup_id
-- panels trx_product_id
-- 
-- panel_strace_details panel_strace_id
-- panel_strace_details reel_id
-- panel_strace_details z_num
-- panel_strace_details pu_num
-- panel_strace_details part_no
-- panel_strace_details custom_area1
-- panel_strace_details custom_area2
-- panel_strace_details custom_area3
-- panel_strace_details custom_area4
-- panel_strace_details feeder_bc
-- 
-- panel_strace_header panel_equipment_id
-- panel_strace_header equipment_id
-- panel_strace_header master_strace_id
-- panel_strace_header panel_strace_id
-- panel_strace_header timestamp
-- panel_strace_header trx_product_id
-- 
-- product_data product_id
-- product_data product_name
-- product_data dos_product_name
-- product_data patterns_per_panel
-- product_data panel_width
-- product_data panel_length
-- product_data panel_thickness
-- product_data camera_xaxis_top
-- product_data camera_yaxis_top
-- product_data camera_xaxis_bottom
-- product_data camera_yaxis_bottom
-- product_data tooling_pin_distance
-- product_data barcodes_per_panel
-- product_data product_valid_flag
-- product_data tooling_pin
-- product_data conveyor_speed
-- product_data use_brd_file
-- product_data base_product_id
-- 
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
-- 
-- production_reports_npm_by_board report_id
-- production_reports_npm_by_board total
-- production_reports_npm_by_board actual
-- production_reports_npm_by_board board
-- production_reports_npm_by_board pboard
-- production_reports_npm_by_board module
-- production_reports_npm_by_board hsup
-- production_reports_npm_by_board clean
-- production_reports_npm_by_board brec
-- production_reports_npm_by_board maintenance
-- production_reports_npm_by_board ope_rate
-- production_reports_npm_by_board pickup_rate
-- production_reports_npm_by_board mount_rate
-- production_reports_npm_by_board mount
-- production_reports_npm_by_board recog_err1
-- production_reports_npm_by_board recog_err2
-- production_reports_npm_by_board floortemp
-- production_reports_npm_by_board floorhumid
-- production_reports_npm_by_board mctemp
-- production_reports_npm_by_board mchumid
-- production_reports_npm_by_board thermostatus
-- production_reports_npm_by_board waitt
-- production_reports_npm_by_board poweron
-- production_reports_npm_by_board change
-- production_reports_npm_by_board prodview
-- production_reports_npm_by_board mente
-- production_reports_npm_by_board dataedit
-- production_reports_npm_by_board unitadjust
-- production_reports_npm_by_board idle
-- production_reports_npm_by_board load
-- production_reports_npm_by_board breg
-- production_reports_npm_by_board tpickup
-- production_reports_npm_by_board tpmiss
-- production_reports_npm_by_board trmiss
-- production_reports_npm_by_board tdmiss
-- production_reports_npm_by_board tmmiss
-- production_reports_npm_by_board thmiss
-- production_reports_npm_by_board timestamp
-- production_reports_npm_by_board prod_time
-- production_reports_npm_by_board brcg_time
-- production_reports_npm_by_board othrstop_time
-- production_reports_npm_by_board mhrcgstop_time
-- production_reports_npm_by_board cperr_time
-- production_reports_npm_by_board otherlstop_time
-- production_reports_npm_by_board bndstop_time
-- production_reports_npm_by_board mcfwait_time
-- production_reports_npm_by_board mcrwait_time
-- production_reports_npm_by_board fwait_time
-- production_reports_npm_by_board rwait_time
-- production_reports_npm_by_board swait_time
-- production_reports_npm_by_board cwait_time
-- production_reports_npm_by_board bwait_time
-- production_reports_npm_by_board pwait_time
-- production_reports_npm_by_board scstop_time
-- production_reports_npm_by_board scestop_time
-- production_reports_npm_by_board cnvstop_time
-- production_reports_npm_by_board brcgstop_time
-- production_reports_npm_by_board trbl_time
-- production_reports_npm_by_board fbstop_time
-- production_reports_npm_by_board bndrcgstop_time
-- production_reports_npm_by_board crerr_time
-- production_reports_npm_by_board cderr_time
-- production_reports_npm_by_board cmerr_time
-- production_reports_npm_by_board cterr_time
-- production_reports_npm_by_board trserr_time
-- production_reports_npm_by_board prdstop_time
-- production_reports_npm_by_board judgestop_time
-- production_reports_npm_by_board mount_time
-- production_reports_npm_by_board total_time
-- production_reports_npm_by_board caerr_time
-- production_reports_npm_by_board cpwait_time
-- production_reports_npm_by_board mskrecerrstop_time
-- production_reports_npm_by_board mskpstrecerrstop_time
-- production_reports_npm_by_board bprcgstop_time
-- production_reports_npm_by_board sothrstop_time
-- production_reports_npm_by_board pcustop_time
-- production_reports_npm_by_board bestop_time
-- production_reports_npm_by_board twait_time
-- production_reports_npm_by_board hcwait_time
-- production_reports_npm_by_board hswait_time
-- production_reports_npm_by_board pstrecerrstop_time
-- production_reports_npm_by_board solvnonstop_time
-- production_reports_npm_by_board fwait_count
-- production_reports_npm_by_board rwait_count
-- production_reports_npm_by_board swait_count
-- production_reports_npm_by_board cwait_count
-- production_reports_npm_by_board bwait_count
-- production_reports_npm_by_board pwait_count
-- production_reports_npm_by_board scstop_count
-- production_reports_npm_by_board scestop_count
-- production_reports_npm_by_board othrstop_count
-- production_reports_npm_by_board cnvstop_count
-- production_reports_npm_by_board brcgstop_count
-- production_reports_npm_by_board trbl_count
-- production_reports_npm_by_board mhrcgstop_count
-- production_reports_npm_by_board fbstop_count
-- production_reports_npm_by_board bndrcgstop_count
-- production_reports_npm_by_board cperr_count
-- production_reports_npm_by_board crerr_count
-- production_reports_npm_by_board cderr_count
-- production_reports_npm_by_board cmerr_count
-- production_reports_npm_by_board cterr_count
-- production_reports_npm_by_board trserr_count
-- production_reports_npm_by_board trsmiss_count
-- production_reports_npm_by_board otherlstop_count
-- production_reports_npm_by_board bndstop_count
-- production_reports_npm_by_board tdispense_count
-- production_reports_npm_by_board tpriming_count
-- production_reports_npm_by_board lotboard_count
-- production_reports_npm_by_board lotmodule_count
-- production_reports_npm_by_board mcfwait_count
-- production_reports_npm_by_board mcrwait_count
-- production_reports_npm_by_board caerr_count
-- production_reports_npm_by_board cpwait_count
-- production_reports_npm_by_board mskrecerrstop_count
-- production_reports_npm_by_board mskpstrecerrstop_count
-- production_reports_npm_by_board bprcgstop_count
-- production_reports_npm_by_board sothrstop_count
-- production_reports_npm_by_board pcustop_count
-- production_reports_npm_by_board bestop_count
-- production_reports_npm_by_board twait_count
-- production_reports_npm_by_board hcwait_count
-- production_reports_npm_by_board hswait_count
-- production_reports_npm_by_board pstrecerrstop_count
-- production_reports_npm_by_board total_count
-- production_reports_npm_by_board solvnonstop_count
-- production_reports_npm_by_board spdlenerrstop_time
-- production_reports_npm_by_board spdpstcntupstop_time
-- production_reports_npm_by_board spdpstnonstop_time
-- production_reports_npm_by_board spdpapernonstop_time
-- production_reports_npm_by_board spdmskrecerrstop_time
-- production_reports_npm_by_board spdpstrecerrstop_time
-- production_reports_npm_by_board spdsolvnonstop_time
-- production_reports_npm_by_board spdlenerrstop_count
-- production_reports_npm_by_board spdpstcntupstop_count
-- production_reports_npm_by_board spdpstnonstop_count
-- production_reports_npm_by_board spdpapernonstop_count
-- production_reports_npm_by_board spdmskrecerrstop_count
-- production_reports_npm_by_board spdpstrecerrstop_count
-- production_reports_npm_by_board spdsolvnonstop_count
-- production_reports_npm_by_board spdreccnt_count
-- production_reports_npm_by_board spdprintcnt_count
-- production_reports_npm_by_board spdclncnt_count
-- production_reports_npm_by_board spdpstsupplycnt_count
-- production_reports_npm_by_board spdfbclncnt_count
-- production_reports_npm_by_board spdfbprintcnt_count
-- production_reports_npm_by_board spdrestorationcnt_count
-- production_reports_npm_by_board jwait_time
-- 
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
-- 
-- production_reports_npm_hdr_by_board report_id
-- production_reports_npm_hdr_by_board product_id
-- production_reports_npm_hdr_by_board equipment_id
-- production_reports_npm_hdr_by_board start_time
-- production_reports_npm_hdr_by_board end_time
-- production_reports_npm_hdr_by_board setup_id
-- production_reports_npm_hdr_by_board nc_version
-- production_reports_npm_hdr_by_board lane_no
-- production_reports_npm_hdr_by_board job_id
-- production_reports_npm_hdr_by_board trx_productid
-- production_reports_npm_hdr_by_board stage
-- production_reports_npm_hdr_by_board timestamp
-- 
-- production_reports_npm_hdr_raw report_id
-- production_reports_npm_hdr_raw product_id
-- production_reports_npm_hdr_raw equipment_id
-- production_reports_npm_hdr_raw start_time
-- production_reports_npm_hdr_raw end_time
-- production_reports_npm_hdr_raw setup_id
-- production_reports_npm_hdr_raw nc_version
-- production_reports_npm_hdr_raw lane_no
-- production_reports_npm_hdr_raw job_id
-- production_reports_npm_hdr_raw trx_productid
-- production_reports_npm_hdr_raw stage
-- production_reports_npm_hdr_raw timestamp
-- 
-- production_reports_npm_raw report_id
-- production_reports_npm_raw total
-- production_reports_npm_raw actual
-- production_reports_npm_raw board
-- production_reports_npm_raw pboard
-- production_reports_npm_raw module
-- production_reports_npm_raw hsup
-- production_reports_npm_raw clean
-- production_reports_npm_raw brec
-- production_reports_npm_raw maintenance
-- production_reports_npm_raw ope_rate
-- production_reports_npm_raw pickup_rate
-- production_reports_npm_raw mount_rate
-- production_reports_npm_raw mount
-- production_reports_npm_raw recog_err1
-- production_reports_npm_raw recog_err2
-- production_reports_npm_raw floortemp
-- production_reports_npm_raw floorhumid
-- production_reports_npm_raw mctemp
-- production_reports_npm_raw mchumid
-- production_reports_npm_raw thermostatus
-- production_reports_npm_raw waitt
-- production_reports_npm_raw poweron
-- production_reports_npm_raw change
-- production_reports_npm_raw prodview
-- production_reports_npm_raw mente
-- production_reports_npm_raw dataedit
-- production_reports_npm_raw unitadjust
-- production_reports_npm_raw idle
-- production_reports_npm_raw load
-- production_reports_npm_raw breg
-- production_reports_npm_raw tpickup
-- production_reports_npm_raw tpmiss
-- production_reports_npm_raw trmiss
-- production_reports_npm_raw tdmiss
-- production_reports_npm_raw tmmiss
-- production_reports_npm_raw thmiss
-- production_reports_npm_raw timestamp
-- production_reports_npm_raw prod_time
-- production_reports_npm_raw brcg_time
-- production_reports_npm_raw othrstop_time
-- production_reports_npm_raw mhrcgstop_time
-- production_reports_npm_raw cperr_time
-- production_reports_npm_raw otherlstop_time
-- production_reports_npm_raw bndstop_time
-- production_reports_npm_raw mcfwait_time
-- production_reports_npm_raw mcrwait_time
-- production_reports_npm_raw fwait_time
-- production_reports_npm_raw rwait_time
-- production_reports_npm_raw swait_time
-- production_reports_npm_raw cwait_time
-- production_reports_npm_raw bwait_time
-- production_reports_npm_raw pwait_time
-- production_reports_npm_raw scstop_time
-- production_reports_npm_raw scestop_time
-- production_reports_npm_raw cnvstop_time
-- production_reports_npm_raw brcgstop_time
-- production_reports_npm_raw trbl_time
-- production_reports_npm_raw fbstop_time
-- production_reports_npm_raw bndrcgstop_time
-- production_reports_npm_raw crerr_time
-- production_reports_npm_raw cderr_time
-- production_reports_npm_raw cmerr_time
-- production_reports_npm_raw cterr_time
-- production_reports_npm_raw trserr_time
-- production_reports_npm_raw prdstop_time
-- production_reports_npm_raw judgestop_time
-- production_reports_npm_raw mount_time
-- production_reports_npm_raw total_time
-- production_reports_npm_raw caerr_time
-- production_reports_npm_raw cpwait_time
-- production_reports_npm_raw mskrecerrstop_time
-- production_reports_npm_raw mskpstrecerrstop_time
-- production_reports_npm_raw bprcgstop_time
-- production_reports_npm_raw sothrstop_time
-- production_reports_npm_raw pcustop_time
-- production_reports_npm_raw bestop_time
-- production_reports_npm_raw twait_time
-- production_reports_npm_raw hcwait_time
-- production_reports_npm_raw hswait_time
-- production_reports_npm_raw pstrecerrstop_time
-- production_reports_npm_raw solvnonstop_time
-- production_reports_npm_raw fwait_count
-- production_reports_npm_raw rwait_count
-- production_reports_npm_raw swait_count
-- production_reports_npm_raw cwait_count
-- production_reports_npm_raw bwait_count
-- production_reports_npm_raw pwait_count
-- production_reports_npm_raw scstop_count
-- production_reports_npm_raw scestop_count
-- production_reports_npm_raw othrstop_count
-- production_reports_npm_raw cnvstop_count
-- production_reports_npm_raw brcgstop_count
-- production_reports_npm_raw trbl_count
-- production_reports_npm_raw mhrcgstop_count
-- production_reports_npm_raw fbstop_count
-- production_reports_npm_raw bndrcgstop_count
-- production_reports_npm_raw cperr_count
-- production_reports_npm_raw crerr_count
-- production_reports_npm_raw cderr_count
-- production_reports_npm_raw cmerr_count
-- production_reports_npm_raw cterr_count
-- production_reports_npm_raw trserr_count
-- production_reports_npm_raw trsmiss_count
-- production_reports_npm_raw otherlstop_count
-- production_reports_npm_raw bndstop_count
-- production_reports_npm_raw tdispense_count
-- production_reports_npm_raw tpriming_count
-- production_reports_npm_raw lotboard_count
-- production_reports_npm_raw lotmodule_count
-- production_reports_npm_raw mcfwait_count
-- production_reports_npm_raw mcrwait_count
-- production_reports_npm_raw caerr_count
-- production_reports_npm_raw cpwait_count
-- production_reports_npm_raw mskrecerrstop_count
-- production_reports_npm_raw mskpstrecerrstop_count
-- production_reports_npm_raw bprcgstop_count
-- production_reports_npm_raw sothrstop_count
-- production_reports_npm_raw pcustop_count
-- production_reports_npm_raw bestop_count
-- production_reports_npm_raw twait_count
-- production_reports_npm_raw hcwait_count
-- production_reports_npm_raw hswait_count
-- production_reports_npm_raw pstrecerrstop_count
-- production_reports_npm_raw total_count
-- production_reports_npm_raw solvnonstop_count
-- production_reports_npm_raw spdlenerrstop_time
-- production_reports_npm_raw spdpstcntupstop_time
-- production_reports_npm_raw spdpstnonstop_time
-- production_reports_npm_raw spdpapernonstop_time
-- production_reports_npm_raw spdmskrecerrstop_time
-- production_reports_npm_raw spdpstrecerrstop_time
-- production_reports_npm_raw spdsolvnonstop_time
-- production_reports_npm_raw spdlenerrstop_count
-- production_reports_npm_raw spdpstcntupstop_count
-- production_reports_npm_raw spdpstnonstop_count
-- production_reports_npm_raw spdpapernonstop_count
-- production_reports_npm_raw spdmskrecerrstop_count
-- production_reports_npm_raw spdpstrecerrstop_count
-- production_reports_npm_raw spdsolvnonstop_count
-- production_reports_npm_raw spdreccnt_count
-- production_reports_npm_raw spdprintcnt_count
-- production_reports_npm_raw spdclncnt_count
-- production_reports_npm_raw spdpstsupplycnt_count
-- production_reports_npm_raw spdfbclncnt_count
-- production_reports_npm_raw spdfbprintcnt_count
-- production_reports_npm_raw spdrestorationcnt_count
-- production_reports_npm_raw jwait_time
-- 
-- product_run_history product_run_history_id
-- product_run_history equipment_id
-- product_run_history lane_no
-- product_run_history setup_id
-- product_run_history start_time
-- product_run_history end_time
-- 
-- product_setup product_id
-- product_setup route_id
-- product_setup mix_name
-- product_setup setup_id
-- product_setup ldf_file_name
-- product_setup machine_file_name
-- product_setup setup_valid_flag
-- product_setup last_modified_time
-- product_setup dos_file_name
-- product_setup model_string
-- product_setup top_bottom
-- product_setup pt_group_name
-- product_setup pt_lot_name
-- product_setup pt_mc_file_name
-- product_setup pt_downloaded_flag
-- product_setup pt_needs_download
-- product_setup sub_parts_flag
-- product_setup barcode_side
-- product_setup cycle_time
-- product_setup import_source
-- product_setup modified_import_source
-- product_setup theoretical_xover_time
-- product_setup publish_mode
-- product_setup pcb_name
-- product_setup master_mjs_id
-- 
-- reel_data reel_id
-- reel_data part_no
-- reel_data mcid
-- reel_data vendor_no
-- reel_data lot_no
-- reel_data quantity
-- reel_data user_data
-- reel_data reel_barcode
-- reel_data current_quantity
-- reel_data update_time
-- reel_data master_reel_id
-- reel_data create_time
-- reel_data part_class
-- reel_data material_name
-- reel_data prev_reel_id
-- reel_data next_reel_id
-- reel_data adjusted_current_quantity
-- reel_data tray_quantity
-- reel_data bulk_master_id
-- reel_data is_msd
-- 
-- route_layout route_id
-- route_layout pos
-- route_layout zone_id
-- route_layout dos_cell_no
-- route_layout pro_module_no
-- 
-- routes route_id
-- routes route_name
-- routes host_name
-- routes dos_line_no
-- routes flow_direction
-- routes valid_flag
-- routes subimport_path
-- routes stand_alone
-- routes route_startup
-- routes lnb_host_name
-- routes route_abbr
-- routes dgs_line_id
-- routes dgs_import_mode
-- routes mgmt_upload_type
-- routes sub_part_import_src
-- routes navi_import_mode
-- routes restricted_components_enabled
-- routes separate_network_ip
-- routes separate_network_enabled
-- routes publish_mode
-- routes linked_to_publish
-- routes publish_route_id
-- routes disable_tray_part_scan
-- routes enable_tray_interlock
-- routes bmx_zone_id
-- routes bmx_storage_unit_id
-- routes bmx_dedication_type
-- routes pt200_line_id
-- routes allow_delete
-- 
-- system_config attribute_name
-- system_config attribute_value
-- 
-- tracking_data serial_no
-- tracking_data prod_model_no
-- tracking_data panel_id
-- tracking_data pattern_id
-- tracking_data barcode
-- tracking_data setup_id
-- tracking_data top_bottom
-- tracking_data timestamp
-- tracking_data import_flag
-- 
-- z_cass_npm report_id
-- z_cass_npm lot
-- z_cass_npm stage
-- z_cass_npm tprod
-- z_cass_npm head
-- z_cass_npm fadd
-- z_cass_npm fsadd
-- z_cass_npm fblkcode
-- z_cass_npm fblkserial
-- z_cass_npm reelid
-- z_cass_npm tcnt
-- z_cass_npm tmiss
-- z_cass_npm rmiss
-- z_cass_npm hmiss
-- z_cass_npm fmiss
-- z_cass_npm mmiss
-- z_cass_npm board
-- z_cass_npm partsname
-- z_cass_npm place_count
-- z_cass_npm trsmiss
-- z_cass_npm timestamp
-- z_cass_npm reel_id
-- z_cass_npm feeder_id
-- 
-- z_cass_npm_by_board report_id
-- z_cass_npm_by_board lot
-- z_cass_npm_by_board stage
-- z_cass_npm_by_board tprod
-- z_cass_npm_by_board head
-- z_cass_npm_by_board fadd
-- z_cass_npm_by_board fsadd
-- z_cass_npm_by_board fblkcode
-- z_cass_npm_by_board fblkserial
-- z_cass_npm_by_board reelid
-- z_cass_npm_by_board tcnt
-- z_cass_npm_by_board tmiss
-- z_cass_npm_by_board rmiss
-- z_cass_npm_by_board hmiss
-- z_cass_npm_by_board fmiss
-- z_cass_npm_by_board mmiss
-- z_cass_npm_by_board board
-- z_cass_npm_by_board partsname
-- z_cass_npm_by_board place_count
-- z_cass_npm_by_board trsmiss
-- z_cass_npm_by_board timestamp
-- z_cass_npm_by_board reel_id
-- z_cass_npm_by_board feeder_id
-- 
-- z_cass_npm_hdr report_id
-- z_cass_npm_hdr product_id
-- z_cass_npm_hdr equipment_id
-- z_cass_npm_hdr start_time
-- z_cass_npm_hdr end_time
-- z_cass_npm_hdr setup_id
-- z_cass_npm_hdr nc_version
-- z_cass_npm_hdr lane_no
-- z_cass_npm_hdr job_id
-- z_cass_npm_hdr trx_productid
-- z_cass_npm_hdr stage
-- z_cass_npm_hdr timestamp
-- 
-- z_cass_npm_hdr_by_board report_id
-- z_cass_npm_hdr_by_board product_id
-- z_cass_npm_hdr_by_board equipment_id
-- z_cass_npm_hdr_by_board start_time
-- z_cass_npm_hdr_by_board end_time
-- z_cass_npm_hdr_by_board setup_id
-- z_cass_npm_hdr_by_board nc_version
-- z_cass_npm_hdr_by_board lane_no
-- z_cass_npm_hdr_by_board job_id
-- z_cass_npm_hdr_by_board trx_productid
-- z_cass_npm_hdr_by_board stage
-- z_cass_npm_hdr_by_board timestamp
-- 
-- z_cass_npm_hdr_raw report_id
-- z_cass_npm_hdr_raw product_id
-- z_cass_npm_hdr_raw equipment_id
-- z_cass_npm_hdr_raw start_time
-- z_cass_npm_hdr_raw end_time
-- z_cass_npm_hdr_raw setup_id
-- z_cass_npm_hdr_raw nc_version
-- z_cass_npm_hdr_raw lane_no
-- z_cass_npm_hdr_raw job_id
-- z_cass_npm_hdr_raw trx_productid
-- z_cass_npm_hdr_raw stage
-- z_cass_npm_hdr_raw timestamp
-- 
-- z_cass_npm_raw report_id
-- z_cass_npm_raw lot
-- z_cass_npm_raw stage
-- z_cass_npm_raw tprod
-- z_cass_npm_raw head
-- z_cass_npm_raw fadd
-- z_cass_npm_raw fsadd
-- z_cass_npm_raw fblkcode
-- z_cass_npm_raw fblkserial
-- z_cass_npm_raw reelid
-- z_cass_npm_raw tcnt
-- z_cass_npm_raw tmiss
-- z_cass_npm_raw rmiss
-- z_cass_npm_raw hmiss
-- z_cass_npm_raw fmiss
-- z_cass_npm_raw mmiss
-- z_cass_npm_raw board
-- z_cass_npm_raw partsname
-- z_cass_npm_raw place_count
-- z_cass_npm_raw trsmiss
-- z_cass_npm_raw timestamp
-- z_cass_npm_raw reel_id
-- z_cass_npm_raw feeder_id
-- 
-- zone_layout zone_id
-- zone_layout pos
-- zone_layout equipment_id
-- 
-- zones zone_id
-- zones zone_name
-- zones host_name
-- zones control_mode
-- zones control_level
-- zones trace_level
-- zones queue_size
-- zones zone_type
-- zones valid_flag
-- zones zone_barcode
-- zones mgmt_mode
-- zones product_mode
-- zones program_mode
-- zones zone_startup
-- zones pin_adjust_mode
-- zones module_id
-- zones ms_zone_id
-- zones active_status
-- zones module_type
-- zones operational_level
-- zones allow_delete
-- 
-- z_cass_npm report_id
-- z_cass_npm lot
-- z_cass_npm stage
-- z_cass_npm tprod
-- z_cass_npm head
-- z_cass_npm fadd
-- z_cass_npm fsadd
-- z_cass_npm fblkcode
-- z_cass_npm fblkserial
-- z_cass_npm reelid
-- z_cass_npm tcnt
-- z_cass_npm tmiss
-- z_cass_npm rmiss
-- z_cass_npm hmiss
-- z_cass_npm fmiss
-- z_cass_npm mmiss
-- z_cass_npm board
-- z_cass_npm partsname
-- z_cass_npm place_count
-- z_cass_npm trsmiss
-- z_cass_npm timestamp
-- z_cass_npm reel_id
-- z_cass_npm feeder_id
-- 
-- z_cass_npm_by_board report_id
-- z_cass_npm_by_board lot
-- z_cass_npm_by_board stage
-- z_cass_npm_by_board tprod
-- z_cass_npm_by_board head
-- z_cass_npm_by_board fadd
-- z_cass_npm_by_board fsadd
-- z_cass_npm_by_board fblkcode
-- z_cass_npm_by_board fblkserial
-- z_cass_npm_by_board reelid
-- z_cass_npm_by_board tcnt
-- z_cass_npm_by_board tmiss
-- z_cass_npm_by_board rmiss
-- z_cass_npm_by_board hmiss
-- z_cass_npm_by_board fmiss
-- z_cass_npm_by_board mmiss
-- z_cass_npm_by_board board
-- z_cass_npm_by_board partsname
-- z_cass_npm_by_board place_count
-- z_cass_npm_by_board trsmiss
-- z_cass_npm_by_board timestamp
-- z_cass_npm_by_board reel_id
-- z_cass_npm_by_board feeder_id
-- 
-- z_cass_npm_hdr report_id
-- z_cass_npm_hdr product_id
-- z_cass_npm_hdr equipment_id
-- z_cass_npm_hdr start_time
-- z_cass_npm_hdr end_time
-- z_cass_npm_hdr setup_id
-- z_cass_npm_hdr nc_version
-- z_cass_npm_hdr lane_no
-- z_cass_npm_hdr job_id
-- z_cass_npm_hdr trx_productid
-- z_cass_npm_hdr stage
-- z_cass_npm_hdr timestamp
-- 
-- z_cass_npm_hdr_by_board report_id
-- z_cass_npm_hdr_by_board product_id
-- z_cass_npm_hdr_by_board equipment_id
-- z_cass_npm_hdr_by_board start_time
-- z_cass_npm_hdr_by_board end_time
-- z_cass_npm_hdr_by_board setup_id
-- z_cass_npm_hdr_by_board nc_version
-- z_cass_npm_hdr_by_board lane_no
-- z_cass_npm_hdr_by_board job_id
-- z_cass_npm_hdr_by_board trx_productid
-- z_cass_npm_hdr_by_board stage
-- z_cass_npm_hdr_by_board timestamp
-- 
-- z_cass_npm_hdr_raw report_id
-- z_cass_npm_hdr_raw product_id
-- z_cass_npm_hdr_raw equipment_id
-- z_cass_npm_hdr_raw start_time
-- z_cass_npm_hdr_raw end_time
-- z_cass_npm_hdr_raw setup_id
-- z_cass_npm_hdr_raw nc_version
-- z_cass_npm_hdr_raw lane_no
-- z_cass_npm_hdr_raw job_id
-- z_cass_npm_hdr_raw trx_productid
-- z_cass_npm_hdr_raw stage
-- z_cass_npm_hdr_raw timestamp
-- 
-- z_cass_npm_raw report_id
-- z_cass_npm_raw lot
-- z_cass_npm_raw stage
-- z_cass_npm_raw tprod
-- z_cass_npm_raw head
-- z_cass_npm_raw fadd
-- z_cass_npm_raw fsadd
-- z_cass_npm_raw fblkcode
-- z_cass_npm_raw fblkserial
-- z_cass_npm_raw reelid
-- z_cass_npm_raw tcnt
-- z_cass_npm_raw tmiss
-- z_cass_npm_raw rmiss
-- z_cass_npm_raw hmiss
-- z_cass_npm_raw fmiss
-- z_cass_npm_raw mmiss
-- z_cass_npm_raw board
-- z_cass_npm_raw partsname
-- z_cass_npm_raw place_count
-- z_cass_npm_raw trsmiss
-- z_cass_npm_raw timestamp
-- z_cass_npm_raw reel_id
-- z_cass_npm_raw feeder_id

print N'PROD_NPM_RAW_CTE GENERATED DELTA DATA ...';
go

with 
    prod_npm_cte (
        eqid,
        lnno,
        rid,
        etm,
        trx,
        brd,
        pkup,
        pmiss,
        rmiss,
        dmiss,
        mmiss,
        hmiss,
        row
)
as (
    select
        eq.equipment_name as eqid,
        prnhr.lane_no as lnno,
        prnhr.report_id as rid,
        prnhr.end_time as etm,
        prnhr.trx_productid as trx,
        prnr.board as brd,
        prnr.tpickup as pkup,
        prnr.tpmiss as pmiss,
        prnr.trmiss as rmiss,
        prnr.tdmiss as dmiss,
        prnr.tmmiss as mmiss,
        prnr.thmiss as hmiss,
        row_number() over (
            partition by 
                eq.equipment_name, 
                prnhr.lane_no
            order by
                eq.equipment_name asc, 
                prnhr.lane_no asc, 
                prnhr.end_time asc
       ) as row
    from
        production_reports_npm_hdr_raw prnhr
    left join
        production_reports_npm_raw prnr
    on
        prnr.report_id = prnhr.report_id
    left join
        equipment eq
    on
        prnhr.equipment_id = eq.equipment_id
    where
        prnhr.end_time >= 1442941200
    and
        prnhr.end_time <= 1443027600
)
select
    -- curr.row as curr_row,
    -- prev.row as prev_row,
    curr.eqid as curr_eqid, 
    curr.lnno as curr_lnno, 

    -- curr.etm as curr_etm,
    -- curr.rid as curr_rid,
    -- curr.trx as curr_trx,
    -- curr.brd as curr_brd,
    -- curr.pkup as curr_pkup,
    -- curr.pmiss as curr_pmiss,
    -- curr.rmiss as curr_rmiss,
    -- curr.dmiss as curr_dmiss,
    -- curr.mmiss as curr_mmiss,
    -- curr.hmiss as curr_hmiss,

    -- prev.etm as prev_etm,
    -- prev.rid as prev_rid,
    -- prev.trx as prev_trx,
    -- prev.brd as prev_brd,
    -- prev.pkup as prev_pkup,
    -- prev.pmiss as prev_pmiss,
    -- prev.rmiss as prev_rmiss,
    -- prev.dmiss as prev_dmiss,
    -- prev.mmiss as prev_mmiss,
    -- prev.hmiss as prev_hmiss,

    sum(curr.brd - prev.brd) as sum_delta_brd,
    sum(curr.pkup - prev.pkup) as sum_delta_pkup,
    sum(curr.pmiss - prev.pmiss) as sum_delta_pmiss,
    sum(curr.rmiss - prev.rmiss) as sum_delta_rmiss,
    sum(curr.dmiss - prev.dmiss) as sum_delta_dmiss,
    sum(curr.mmiss - prev.mmiss) as sum_delta_mmiss,
    sum(curr.hmiss - prev.hmiss) as sum_delta_hmiss
from
    prod_npm_cte curr
left outer join
    prod_npm_cte prev
on
    curr.row = prev.row + 1
where
    curr.eqid = prev.eqid
and 
    curr.lnno = prev.lnno
group by
    curr.eqid,
    curr.lnno
order by
    curr.eqid asc,
    curr.lnno asc
go

print N'Z_CASS_NPM_RAW_CTE GENERATED DELTA DATA ...';
go

-- z_cass_npm_raw fblkserial

with 
    z_cass_cte (
        eqid, 
        lnno, 
        rid,
        fadd, 
        fsadd, 
        fblkserial,
        pkup,
        plc,
        tmiss,
        rmiss,
        hmiss,
        fmiss,
        mmiss,
        row
    )
as (
    select
        eq.equipment_name as eqid,
        zhr.lane_no as lnno,
        zhr.report_id as rid,
        zr.fadd as fadd,
        zr.fsadd as fsadd,
        zr.fblkserial as fblkserial,
        zr.tcnt as pkup,
        zr.place_count as plc,
        zr.tmiss as tmiss,
        zr.rmiss as rmiss,
        zr.hmiss as hmiss,
        zr.fmiss as fmiss,
        zr.mmiss as mmiss,
        row_number() over (
            partition by 
                eq.equipment_name, 
                zhr.lane_no, 
                zr.fadd, 
                zr.fsadd,
                zr.fblkserial
            order by
                eq.equipment_name asc, 
                zhr.lane_no asc, 
                zr.fadd asc,
                zr.fsadd asc,
                zr.fblkserial asc,
                zr.report_id asc
        ) as row
    from
        z_cass_npm_hdr_raw zhr
    inner join
        z_cass_npm_raw zr
    on
        zhr.report_id = zr.report_id
    inner join
        equipment eq
    on
        zhr.equipment_id = eq.equipment_id
    where
        zhr.end_time >= 1442941200
    and
        zhr.end_time <= 1443027600
)
select
    -- curr.row as curr_row,
    -- prev.row as prev_row,

    curr.eqid as curr_eqid, 
    curr.lnno as curr_lnno, 

    -- curr.fadd as curr_fadd, 
    -- curr.fsadd as curr_fsadd, 

    -- curr.pkup as curr_pkup,
    -- curr.plc as curr_plc,
    -- curr.tmiss as curr_tmiss,
    -- curr.rmiss as curr_rmiss,
    -- curr.hmiss as curr_hmiss,
    -- curr.fmiss as curr_fmiss,
    -- curr.mmiss as curr_mmiss,

    -- prev.fadd as prev_fadd, 
    -- prev.fsadd as prev_fsadd, 

    -- prev.pkup as prev_pkup,
    -- prev.plc as prev_plc,
    -- prev.tmiss as tmiss,
    -- prev.rmiss as rmiss,
    -- prev.hmiss as hmiss,
    -- prev.fmiss as fmiss,
    -- prev.mmiss as mmiss,

    sum(curr.pkup - prev.pkup) as sum_delta_pkup,
    sum(curr.plc - prev.plc) as sum_delta_plc,
    sum(curr.tmiss - prev.tmiss) as sum_delta_tmiss,
    sum(curr.rmiss - prev.rmiss) as sum_delta_rmiss,
    sum(curr.hmiss - prev.hmiss) as sum_delta_hmiss,
    sum(curr.fmiss - prev.fmiss) as sum_delta_fmiss,
    sum(curr.mmiss - prev.mmiss) as sum_delta_mmiss
from
    z_cass_cte curr
left outer join
    z_cass_cte prev
on
    curr.row = prev.row + 1
where
    curr.eqid = prev.eqid
and 
    curr.lnno = prev.lnno
and
    curr.fadd = prev.fadd
and 
    curr.fsadd = prev.fsadd
and 
    curr.fblkserial = prev.fblkserial
group by
    curr.eqid,
    curr.lnno
    -- curr.fadd,
    -- curr.fsadd
order by
    curr.eqid asc,
    curr.lnno asc
    -- curr.fadd asc,
    -- curr.fsadd asc
go

-- 
-- print N'NOZZLE_NPM_RAW_CTE GENERATED DELTA DATA ...';
-- go
-- 
-- with 
--     nozzle_cte (
--         eqid, 
--         lnno, 
--         rid,
--         nhadd, 
--         ncadd, 
--         pkup,
--         plc,
--         tmiss,
--         rmiss,
--         hmiss,
--         fmiss,
--         mmiss,
--         row
--     )
-- as (
--     select
--         eq.equipment_name as eqid,
--         nhr.lane_no as lnno,
--         nhr.report_id as rid,
--         nr.nhadd as ncadd,
--         nr.ncadd as ncadd,
--         nr.tcnt as pkup,
--         nr.place_count as plc,
--         nr.tmiss as tmiss,
--         nr.rmiss as rmiss,
--         nr.hmiss as hmiss,
--         nr.fmiss as fmiss,
--         nr.mmiss as mmiss,
--         row_number() over (
--             partition by 
--                 eq.equipment_name, 
--                 nhr.lane_no, 
--                 nr.nhadd, 
--                 nr.ncadd
--             order by
--                 eq.equipment_name asc, 
--                 nhr.lane_no asc, 
--                 nr.report_id asc,
--                 nr.nhadd asc,
--                 nr.ncadd asc
--         ) as row
--     from
--         nozzle_npm_hdr_raw nhr
--     inner join
--         nozzle_npm_raw nr
--     on
--         nhr.report_id = nr.report_id
--     inner join
--         equipment eq
--     on
--         nhr.equipment_id = eq.equipment_id
--     where
--         nhr.end_time >= 1442941200
--     and
--         nhr.end_time <= 1443027600
-- )
-- select
--     curr.row as curr_row,
--     prev.row as prev_row,
--     curr.eqid as curr_eqid, 
--     curr.lnno as curr_lnno, 
--     curr.nhadd as curr_nhadd, 
--     curr.ncadd as curr_ncadd, 
--     curr.pkup as curr_pkup,
--     curr.plc as curr_plc,
--     curr.tmiss as curr_tmiss,
--     curr.rmiss as curr_rmiss,
--     curr.hmiss as curr_hmiss,
--     curr.fmiss as curr_fmiss,
--     curr.mmiss as curr_mmiss,
--     prev.nhadd as prev_nhadd, 
--     prev.ncadd as prev_ncadd, 
--     prev.pkup as prev_pkup,
--     prev.plc as prev_plc,
--     prev.tmiss as tmiss,
--     prev.rmiss as rmiss,
--     prev.hmiss as hmiss,
--     prev.fmiss as fmiss,
--     prev.mmiss as mmiss,
--     curr.pkup - prev.pkup as delta_pkup,
--     curr.plc - prev.plc as delta_plc,
--     curr.tmiss - prev.tmiss as delta_tmiss,
--     curr.rmiss - prev.rmiss as delta_rmiss,
--     curr.hmiss - prev.hmiss as delta_hmiss,
--     curr.fmiss - prev.fmiss as delta_fmiss,
--     curr.mmiss - prev.mmiss as delta_mmiss
-- from
--     nozzle_cte curr
-- left outer join
--     nozzle_cte prev
-- on
--     curr.row = prev.row + 1
-- where
--     curr.eqid = prev.eqid
-- and 
--     curr.lnno = prev.lnno
-- and
--     curr.nhadd = prev.nhadd
-- and 
--     curr.ncadd = prev.ncadd
-- order by
--     curr.eqid asc,
--     curr.lnno asc,
--     curr.nhadd asc,
--     curr.ncadd asc
-- go
-- 
-- 