--               _mjsid             |  _lotname   | count 
--  --------------------------------+-------------+-------
--   RSD160RA-SA-NEW                | RSD160SA-05 |   140
--   RSA_Nissan_14DA_PP1-NEW-PART2  | RSD160NF-00 |  2028
--   NISSAN_DA_RS_RR_MASTER-part5   | RSD160MA-01 | 13638
--   RSD000FH-HA-MA-SF-UF-NEW-PART2 | RSD000MA-05 |  1275
--   RSD160NA                       | RSD160NA-06 |  3013
--   RSD160-171-AF-BF-CF-NEW        | RSD160CF-06 |  7536
--   RSD160-171-AF-BF-CF-NEW        | RSD160AF-06 |  3180
--   NISSAN_DA_RS_RR_MASTER-part5   | RSD160DA-01 |  1740
--   RSA_Nissan_14DA_PP1-NEW-PART2  | RSD160QF-00 |  2230
--   NISSAN_DA_RS_RR_MASTER-part4   | RSD160LF-00 |  6045
--   RSD000UF                       | RSD000UF-06 |  2470
--   RSD160PA                       | RSD160PA-06 |   265
--   NISSAN_DA_RS_RR_MASTER-part5   | RSD160CA-01 |  6555
--   NISSAN_DA_RS_RR_MASTER-part5   | RSD171CA-01 |  5769
--   RSD160RA-SA-NEW                | RSD160RA-05 |  2505
--   RSD000SH-NEW                   | RSD000LA-06 |  2500
--   RSD160-171-AF-BF-CF-NEW        | RSD171AF-06 |  6010
--  (17 rows)
--  
--            Table "u03.pcb_mqt_pos_aoi_data"
--           Column          |     Type      | Modifiers 
--  -------------------------+---------------+-----------
--   ftf_filename_route      | text          | 
--   ufd_machine_order       | integer       | 
--   ufd_lane_no             | integer       | 
--   ufd_stage_no            | integer       | 
--   ftf_filename_timestamp  | bigint        | 
--   ftf_filename            | text          | 
--   ftf_filename_type       | text          | 
--   ftf_filename_id         | numeric(30,0) | 
--   ufd_filename_id         | numeric(30,0) | 
--   ufd_date                | text          | 
--   ufd_pcb_serial          | text          | 
--   ufd_pcb_id              | text          | 
--   ufd_output_no           | integer       | 
--   ufd_pcb_id_lot_no       | text          | 
--   ufd_pcb_id_serial_no    | text          | 
--   upx_filename_id         | numeric(30,0) | 
--   upx_author              | text          | 
--   upx_authortype          | text          | 
--   upx_comment             | text          | 
--   upx_date                | text          | 
--   upx_diff                | text          | 
--   upx_format              | text          | 
--   upx_machine             | text          | 
--   upx_mjsid               | text          | 
--   upx_version             | text          | 
--   upi_filename_id         | numeric(30,0) | 
--   upi_bcrstatus           | text          | 
--   upi_code                | text          | 
--   upi_lane                | integer       | 
--   upi_lotname             | text          | 
--   upi_lotnumber           | integer       | 
--   upi_output              | integer       | 
--   upi_planid              | text          | 
--   upi_productid           | text          | 
--   upi_rev                 | text          | 
--   upi_serial              | text          | 
--   upi_serialstatus        | text          | 
--   upi_stage               | integer       | 
--   aftf_filename           | text          | 
--   aftf_filename_type      | text          | 
--   aftf_filename_timestamp | bigint        | 
--   aftf_filename_route     | text          | 
--   aftf_fid                | numeric(30,0) | 
--   aafd_filename_id        | numeric(30,0) | 
--   aafd_aoi_pcbid          | text          | 
--   aafd_date_time          | text          | 
--   ai_filename_id          | numeric(30,0) | 
--   ai_cid                  | text          | 
--   ai_timestamp            | text          | 
--   ai_crc                  | text          | 
--   ai_c2d                  | text          | 
--   ai_recipename           | text          | 
--   ai_mid                  | text          | 
--   ap_filename_id          | numeric(30,0) | 
--   ap_p                    | integer       | 
--   ap_cmp                  | integer       | 
--   ap_board_status         | text          | 
--   ap_sc                   | text          | 
--   ap_pid                  | text          | 
--   ap_fc                   | text          | 
--   mqt_filename_id         | numeric(30,0) | 
--   mqt_b                   | integer       | 
--   mqt_idnum               | integer       | 
--   mqt_turn                | integer       | 
--   mqt_ms                  | integer       | 
--   mqt_ts                  | integer       | 
--   mqt_fadd                | integer       | 
--   mqt_fsadd               | integer       | 
--   mqt_fblkcode            | text          | 
--   mqt_fblkserial          | text          | 
--   mqt_nhadd               | integer       | 
--   mqt_ncadd               | integer       | 
--   mqt_nblkcode            | text          | 
--   mqt_nblkserial          | text          | 
--   mqt_reelid              | text          | 
--   mqt_f                   | integer       | 
--   mqt_attempt_status      | text          | 
--   mqt_rcgx                | numeric(10,3) | 
--   mqt_rcgy                | numeric(10,3) | 
--   mqt_rcga                | numeric(10,3) | 
--   mqt_tcx                 | numeric(10,3) | 
--   mqt_tcy                 | numeric(10,3) | 
--   mqt_mposirecx           | numeric(10,3) | 
--   mqt_mposirecy           | numeric(10,3) | 
--   mqt_mposireca           | numeric(10,3) | 
--   mqt_mposirecz           | numeric(10,3) | 
--   mqt_thmax               | numeric(10,3) | 
--   mqt_thave               | numeric(10,3) | 
--   mqt_mntcx               | numeric(10,3) | 
--   mqt_mntcy               | numeric(10,3) | 
--   mqt_mntca               | numeric(10,3) | 
--   mqt_tlx                 | numeric(10,3) | 
--   mqt_tly                 | numeric(10,3) | 
--   mqt_inspectarea         | integer       | 
--   mqt_didnum              | integer       | 
--   mqt_ds                  | integer       | 
--   mqt_dispenseid          | text          | 
--   mqt_parts               | integer       | 
--   mqt_warpz               | numeric(10,3) | 
--   mqt_prepickuplot        | text          | 
--   mqt_prepickupsts        | text          | 
--   crb_fid                 | numeric(30,0) | 
--   ccfd_history_id         | text          | 
--   ccfd_time_stamp         | text          | 
--   ccfd_crb_file_name      | text          | 
--   ccfd_product_name       | text          | 
--   cl_filename_id          | numeric(30,0) | 
--   cl_idnum                | integer       | 
--   cl_lotnum               | integer       | 
--   cl_lot                  | text          | 
--   cl_mcfilename           | text          | 
--   cl_filter               | text          | 
--   cl_autochg              | text          | 
--   cl_basechg              | text          | 
--   cl_lane                 | text          | 
--   cl_productionid         | text          | 
--   cl_simproduct           | text          | 
--   cl_dgspcbname           | text          | 
--   cl_dgspcbrev            | text          | 
--   cl_dgspcbside           | text          | 
--   cl_dgsrefpin            | text          | 
--   cl_c                    | text          | 
--   cl_datagenmode          | text          | 
--   cl_mounthead            | text          | 
--   cl_vstpath              | text          | 
--   cl_order                | text          | 
--   cl_targettact           | text          | 
--   cp_filename_id          | numeric(30,0) | 
--   cp_lot_number           | integer       | 
--   cp_idnum                | integer       | 
--   cp_cadid                | text          | 
--   cp_x                    | text          | 
--   cp_y                    | text          | 
--   cp_a                    | text          | 
--   cp_parts                | text          | 
--   cp_brm                  | text          | 
--   cp_turn                 | text          | 
--   cp_dturn                | text          | 
--   cp_ts                   | text          | 
--   cp_ms                   | text          | 
--   cp_ds                   | text          | 
--   cp_np                   | text          | 
--   cp_dnp                  | text          | 
--   cp_pu                   | text          | 
--   cp_side                 | text          | 
--   cp_dpu                  | text          | 
--   cp_head                 | text          | 
--   cp_dhead                | text          | 
--   cp_ihead                | text          | 
--   cp_b                    | text          | 
--   cp_pg                   | text          | 
--   cp_s                    | text          | 
--   cp_rid                  | text          | 
--   cp_c                    | text          | 
--   cp_m                    | text          | 
--   cp_mb                   | text          | 
--   cp_f                    | text          | 
--   cp_pr                   | text          | 
--   cp_priseq               | text          | 
--   cp_p                    | text          | 
--   cp_pad                  | text          | 
--   cp_vw                   | text          | 
--   cp_stdpos               | text          | 
--   cp_land                 | text          | 
--   cp_depend               | text          | 
--   cp_chkflag              | text          | 
--   cp_exchk                | text          | 
--   cp_grand                | text          | 
--   cp_marea                | text          | 
--   cp_rmset                | text          | 
--   cp_sh                   | text          | 
--   cp_scandir1             | text          | 
--   cp_scandir2             | text          | 
--   cp_ohl                  | text          | 
--   cp_ohr                  | text          | 
--   cp_apcctrl              | text          | 
--   cp_wg                   | text          | 
--   cp_skipnumber           | text          | 
--   acmp_filename_id        | numeric(30,0) | 
--   acmp_p                  | integer       | 
--   acmp_cmp                | integer       | 
--   acmp_cc                 | text          | 
--   acmp_ref                | text          | 
--   acmp_type               | text          | 
--   ad_filename_id          | numeric(30,0) | 
--   ad_cmp                  | integer       | 
--   ad_defect               | integer       | 
--   ad_insp_type            | text          | 
--   ad_lead_id              | text          | 
--  Indexes:
--      "idx_mqt_pos_aoi_fid" btree (ftf_filename_id)
--      "idx_mqt_pos_aoi_fid_mach_lnno_stgno" btree (ftf_filename_id, ufd_machine_order, ufd_lane_no, ufd_stage_no)
--      "idx_mqt_pos_aoi_fid_mach_lnno_stgno_tst" btree (ftf_filename_id, ufd_machine_order, ufd_lane_no, ufd_stage_no, ftf_filename_timestamp)
--      "idx_mqt_pos_aoi_fid_pcbid_mach_lnno_stgno" btree (ftf_filename_id, ufd_pcb_id, ufd_machine_order, ufd_lane_no, ufd_stage_no)
--      "idx_mqt_pos_aoi_fid_prod_mach_lnno_stgno_tst" btree (ftf_filename_id, upx_mjsid, upi_lotname, ufd_machine_order, ufd_lane_no, ufd_stage_no, ftf_filename_timestamp)
--  

select 
    dn.ftf_filename_route,
    dn.upx_mjsid,
    dn.upi_lotname,
    dn.ufd_machine_order,
    dn.ufd_lane_no,
    dn.ufd_stage_no,
    dn.ftf_filename_timestamp,
    dn.ftf_filename,
    -- dn.ftf_filename_type,
    -- dn.ftf_filename_id,
    -- dn.ufd_filename_id,
    -- dn.ufd_date,
    dn.ufd_pcb_serial,
    dn.ufd_pcb_id,
    dn.ufd_output_no,
    -- dn.ufd_pcb_id_lot_no,
    -- dn.ufd_pcb_id_serial_no,
    -- dn.upx_filename_id,
    -- dn.upx_author,
    -- dn.upx_authortype,
    -- dn.upx_comment,
    -- dn.upx_date,
    -- dn.upx_diff,
    -- dn.upx_format,
    -- dn.upx_machine,
    -- dn.upx_version,
    -- dn.upi_filename_id,
    -- dn.upi_bcrstatus,
    dn.upi_code,
    -- dn.upi_lane,
    dn.upi_lotnumber,
    -- dn.upi_output,
    -- dn.upi_planid,
    dn.upi_productid,
    -- dn.upi_rev,
    dn.upi_serial,
    -- dn.upi_serialstatus,
    -- dn.upi_stage,
    dn.aftf_filename,
    -- dn.aftf_filename_type,
    dn.aftf_filename_timestamp,
    -- dn.aftf_filename_route,
    -- dn.aftf_fid,
    -- dn.aafd_filename_id,
    dn.aafd_aoi_pcbid,
    -- dn.aafd_date_time,
    -- dn.ai_filename_id,
    dn.ai_cid,
    -- dn.ai_timestamp,
    -- dn.ai_crc,
    dn.ai_c2d,
    dn.ai_recipename,
    -- dn.ai_mid,
    -- dn.ap_filename_id,
    dn.ap_p,
    dn.ap_cmp,
    dn.ap_board_status,
    dn.ap_sc,
    dn.ap_pid,
    dn.ap_fc,
    -- dn.mqt_filename_id,
    dn.mqt_b,
    dn.mqt_idnum,
    dn.mqt_ms,
    dn.mqt_turn,
    dn.mqt_ts,
    dn.mqt_fadd,
    dn.mqt_fsadd,
    dn.mqt_fblkcode,
    dn.mqt_fblkserial,
    dn.mqt_nhadd,
    dn.mqt_ncadd,
    dn.mqt_nblkcode,
    dn.mqt_nblkserial,
    dn.mqt_reelid,
    dn.mqt_f,
    dn.mqt_attempt_status,
    dn.mqt_rcgx,
    dn.mqt_rcgy,
    dn.mqt_rcga,
    dn.mqt_tcx,
    dn.mqt_tcy,
    -- dn.mqt_mposirecx,
    -- dn.mqt_mposirecy,
    -- dn.mqt_mposireca,
    -- dn.mqt_mposirecz,
    dn.mqt_thmax,
    dn.mqt_thave,
    dn.mqt_mntcx,
    dn.mqt_mntcy,
    dn.mqt_mntca,
    dn.mqt_tlx,
    dn.mqt_tly,
    -- dn.mqt_inspectarea,
    -- dn.mqt_didnum,
    -- dn.mqt_ds,
    -- dn.mqt_dispenseid,
    dn.mqt_parts,
    -- dn.mqt_warpz,
    -- dn.mqt_prepickuplot,
    -- dn.mqt_prepickupsts,
    -- dn.crb_fid,
    -- dn.ccfd_history_id,
    dn.ccfd_time_stamp,
    -- dn.ccfd_crb_file_name,
    dn.ccfd_product_name,
    -- dn.cl_filename_id,
    dn.cl_idnum,
    dn.cl_lotnum,
    dn.cl_lot,
    dn.cl_mcfilename,
    -- dn.cl_filter,
    -- dn.cl_autochg,
    -- dn.cl_basechg,
    -- dn.cl_lane,
    -- dn.cl_productionid,
    -- dn.cl_simproduct,
    dn.cl_dgspcbname,
    dn.cl_dgspcbrev,
    dn.cl_dgspcbside,
    -- dn.cl_dgsrefpin,
    -- dn.cl_c,
    -- dn.cl_datagenmode,
    -- dn.cl_mounthead,
    -- dn.cl_vstpath,
    -- dn.cl_order,
    -- dn.cl_targettact,
    -- dn.cp_filename_id,
    dn.cp_lot_number,
    dn.cp_idnum,
    dn.cp_cadid,
    dn.cp_x,
    dn.cp_y,
    dn.cp_a,
    dn.cp_parts,
    dn.cp_brm,
    dn.cp_turn,
    dn.cp_dturn,
    dn.cp_ts,
    dn.cp_ms,
    dn.cp_ds,
    dn.cp_np,
    dn.cp_dnp,
    dn.cp_pu,
    dn.cp_side,
    dn.cp_dpu,
    dn.cp_head,
    dn.cp_dhead,
    dn.cp_ihead,
    dn.cp_b,
    dn.cp_pg,
    dn.cp_s,
    dn.cp_rid,
    dn.cp_c,
    dn.cp_m,
    dn.cp_mb,
    dn.cp_f,
    dn.cp_pr,
    -- dn.cp_priseq,
    -- dn.cp_p,
    -- dn.cp_pad,
    -- dn.cp_vw,
    -- dn.cp_stdpos,
    -- dn.cp_land,
    -- dn.cp_depend,
    -- dn.cp_chkflag,
    -- dn.cp_exchk,
    -- dn.cp_grand,
    -- dn.cp_marea,
    -- dn.cp_rmset,
    dn.cp_sh,
    -- dn.cp_scandir1,
    -- dn.cp_scandir2,
    -- dn.cp_ohl,
    -- dn.cp_ohr,
    -- dn.cp_apcctrl,
    -- dn.cp_wg,
    -- dn.cp_skipnumber,
    -- dn.acmp_filename_id,
    dn.acmp_p,
    dn.acmp_cmp,
    dn.acmp_cc,
    dn.acmp_ref,
    dn.acmp_type,
    dn.ad_filename_id,
    dn.ad_cmp,
    dn.ad_defect,
    dn.ad_insp_type,
    dn.ad_lead_id
from
    u03.pcb_mqt_pos_aoi_data dn
where
    dn.upx_mjsid = 'NISSAN_DA_RS_RR_MASTER-part5'
and
    dn.upi_lotname = 'RSD160CA-01'
-- where 
--     dn.ufd_pcb_id in
-- (
--     'YEP0PTD000LA|00|A|101633701823|01',
--     'YEP0PTD000LA|00|A|101633701825|01',
--     'YEP0PTD000LA|00|A|101633701828|01',
--     'YEP0PTD000LA|00|A|101633701830|01',
--     'YEP0PTD000LA|00|A|101633701832|01',
--     'YEP0PTD000LA|00|A|101633701834|01',
--     'YEP0PTD000LA|00|A|101633701836|01',
--     'YEP0PTD000LA|00|A|101633701838|01',
--     'YEP0PTD000LA|00|A|101633701839|01',
--     'YEP0PTD000LA|00|A|101633701840|01',
--     'YEP0PTD000LA|00|A|101633701854|01',
--     'YEP0PTD000LA|00|A|101633701856|01',
--     'YEP0PTD000LA|00|A|101633701858|01',
--     'YEP0PTD000LA|00|A|101633701860|01',
--     'YEP0PTD000LA|00|A|101633701862|01',
--     'YEP0PTD000LA|00|A|101633701864|01',
--     'YEP0PTD000LA|00|A|101633701865|01',
--     'YEP0PTD000LA|00|A|101633701866|01',
--     'YEP0PTD000LA|00|A|101633701867|01',
--     'YEP0PTD000LA|00|A|101633701869|01',
--     'YEP0PTD000LA|00|A|101633701871|01',
--     'YEP0PTD000LA|00|A|101633701872|01',
--     'YEP0PTD000LA|00|A|101633701874|01',
--     'YEP0PTD000LA|00|A|101633701875|01',
--     'YEP0PTD000LA|00|A|101633701879|01',
--     'YEP0PTD000LA|00|A|101633701880|01',
--     'YEP0PTD000LA|00|A|101633701881|01',
--     'YEP0PTD000LA|00|A|101633701889|01',
--     'YEP0PTD000LA|00|A|101633701891|01',
--     'YEP0PTD000LA|00|A|101633701893|01',
--     'YEP0PTD000LA|00|A|101633701895|01',
--     'YEP0PTD000LA|00|A|101633701897|01',
--     'YEP0PTD000LA|00|A|101633701899|01',
--     'YEP0PTD000LA|00|A|101633701901|01',
--     'YEP0PTD000LA|00|A|101633701903|01',
--     'YEP0PTD000LA|00|A|101633701905|01',
--     'YEP0PTD000LA|00|A|101633701907|01',
--     'YEP0PTD000LA|00|A|101633701908|01',
--     'YEP0PTD000LA|00|A|101633701911|01',
--     'YEP0PTD000LA|00|A|101633701913|01',
--     'YEP0PTD000LA|00|A|101633701915|01',
--     'YEP0PTD000LA|00|A|101633701917|01',
--     'YEP0PTD000LA|00|A|101633701919|01',
--     'YEP0PTD000LA|00|A|101633701921|01',
--     'YEP0PTD000LA|00|A|101633701923|01',
--     'YEP0PTD000LA|00|A|101633701963|01',
--     'YEP0PTD000LA|00|A|101633701965|01',
--     'YEP0PTD000LA|00|A|101633701967|01',
--     'YEP0PTD000LA|00|A|101633701982|01',
--     'YEP0PTD000LA|00|A|101633701983|01',
--     'YEP0PTD000LA|00|A|101633701985|01',
--     'YEP0PTD000LA|00|A|101633701987|01',
--     'YEP0PTD000LA|00|A|101633701989|01',
--     'YEP0PTD000LA|00|A|101633701991|01',
--     'YEP0PTD000LA|00|A|101633701993|01',
--     'YEP0PTD000LA|00|A|101633701997|01',
--     'YEP0PTD000LA|00|A|101633701998|01',
--     'YEP0PTD000LA|00|A|101633702000|01',
--     'YEP0PTD000LA|00|A|101633702002|01',
--     'YEP0PTD000LA|00|A|101633702004|01',
--     'YEP0PTD000LA|00|A|101633702009|01',
--     'YEP0PTD000LA|00|A|101633702011|01',
--     'YEP0PTD000LA|00|A|101633702013|01',
--     'YEP0PTD000LA|00|A|101633702015|01',
--     'YEP0PTD000LA|00|A|101633702017|01',
--     'YEP0PTD000LA|00|A|101633702019|01',
--     'YEP0PTD000LA|00|A|101633702021|01',
--     'YEP0PTD000LA|00|A|101633702023|01',
--     'YEP0PTD000LA|00|A|101633702025|01',
--     'YEP0PTD000LA|00|A|101633702027|01',
--     'YEP0PTD000LA|00|A|101633702032|01',
--     'YEP0PTD000LA|00|A|101633702033|01',
--     'YEP0PTD000LA|00|A|101633702034|01',
--     'YEP0PTD000LA|00|A|101633702035|01',
--     'YEP0PTD000LA|00|A|101633702036|01',
--     'YEP0PTD000LA|00|A|101633702037|01',
--     'YEP0PTD000LA|00|A|101633702038|01',
--     'YEP0PTD000LA|00|A|101633702039|01',
--     'YEP0PTD000LA|00|A|101633702040|01',
--     'YEP0PTD000LA|00|A|101633702041|01',
--     'YEP0PTD000LA|00|A|101633702042|01',
--     'YEP0PTD000LA|00|A|101633702043|01',
--     'YEP0PTD000LA|00|A|101633702044|01',
--     'YEP0PTD000LA|00|A|101633702045|01',
--     'YEP0PTD000LA|00|A|101633702046|01',
--     'YEP0PTD000LA|00|A|101633702047|01',
--     'YEP0PTD000LA|00|A|101633702048|01',
--     'YEP0PTD000LA|00|A|101633702049|01',
--     'YEP0PTD000LA|00|A|101633702050|01',
--     'YEP0PTD000LA|00|A|101633702051|01',
--     'YEP0PTD000LA|00|A|101633702060|01',
--     'YEP0PTD000LA|00|A|101633702061|01',
--     'YEP0PTD000LA|00|A|101633702091|01',
--     'YEP0PTD000LA|00|A|101633702093|01',
--     'YEP0PTD000LA|00|A|101633702095|01',
--     'YEP0PTD000LA|00|A|101633702097|01',
--     'YEP0PTD000LA|00|A|101633702099|01',
--     'YEP0PTD000LA|00|A|101633702101|01',
--     'YEP0PTD000LA|00|A|101633702103|01',
--     'YEP0PTD000LA|00|A|101633702105|01',
--     'YEP0PTD000LA|00|A|101633800105|01',
--     'YEP0PTD000LA|00|A|101633800129|01',
--     'YEP0PTD000LA|00|A|101633800190|01',
--     'YEP0PTD000LA|00|A|101633800192|01',
--     'YEP0PTD000LA|00|A|101633800193|01',
--     'YEP0PTD000LA|00|A|101633800195|01',
--     'YEP0PTD000LA|00|A|101633800198|01',
--     'YEP0PTD000LA|00|A|101633800200|01',
--     'YEP0PTD000LA|00|A|101633800202|01',
--     'YEP0PTD000LA|00|A|101633800205|01',
--     'YEP0PTD000LA|00|A|101633800206|01',
--     'YEP0PTD000LA|00|A|101633800208|01',
--     'YEP0PTD000LA|00|A|101633800210|01',
--     'YEP0PTD000LA|00|A|101633800212|01',
--     'YEP0PTD000LA|00|A|101633800214|01',
--     'YEP0PTD000LA|00|A|101633800216|01',
--     'YEP0PTD000LA|00|A|101633800218|01',
--     'YEP0PTD000LA|00|A|101633800220|01',
--     'YEP0PTD000LA|00|A|101633800222|01',
--     'YEP0PTD000LA|00|A|101633800225|01',
--     'YEP0PTD000LA|00|A|101633800227|01',
--     'YEP0PTD000LA|00|A|101633800229|01',
--     'YEP0PTD000LA|00|A|101633800231|01',
--     'YEP0PTD000LA|00|A|101633800233|01',
--     'YEP0PTD000LA|00|A|101633800235|01',
--     'YEP0PTD000LA|00|A|101633800237|01',
--     'YEP0PTD000LA|00|A|101633800239|01',
--     'YEP0PTD000LA|00|A|101633800327|01',
--     'YEP0PTD000LA|00|A|101633800329|01',
--     'YEP0PTD000LA|00|A|101633800330|01',
--     'YEP0PTD000LA|00|A|101633800333|01',
--     'YEP0PTD000LA|00|A|101633800335|01',
--     'YEP0PTD000LA|00|A|101633800337|01',
--     'YEP0PTD000LA|00|A|101633800341|01',
--     'YEP0PTD000LA|00|A|101633800344|01',
--     'YEP0PTD000LA|00|A|101633800346|01',
--     'YEP0PTD000LA|00|A|101633800348|01',
--     'YEP0PTD000LA|00|A|101633800350|01',
--     'YEP0PTD000LA|00|A|101633800351|01',
--     'YEP0PTD000LA|00|A|101633800353|01',
--     'YEP0PTD000LA|00|A|101633800355|01',
--     'YEP0PTD000LA|00|A|101633800357|01',
--     'YEP0PTD000LA|00|A|101633800359|01',
--     'YEP0PTD000LA|00|A|101633800362|01',
--     'YEP0PTD000LA|00|A|101633800364|01',
--     'YEP0PTD000LA|00|A|101633800366|01',
--     'YEP0PTD000LA|00|A|101633800368|01',
--     'YEP0PTD000LA|00|A|101633800370|01',
--     'YEP0PTD000LA|00|A|101633800372|01',
--     'YEP0PTD000LA|00|A|101633800374|01'
-- )
order by
    ufd_machine_order,
    ufd_lane_no,
    ufd_stage_no,
    ftf_filename_timestamp,
    dn.mqt_ms,
    dn.mqt_turn
;
    
