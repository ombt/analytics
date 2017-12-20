#
/home/MRumore/g/testbin/postgres/pg.create.table.index.pl \
	training_data2 \
	u03.pcb_mqt_pos_aoi_data \
	ftf_filename_id \
	idx_mqt_pos_aoi_fid \
	localhost \
	5432 \
	cim
#
/home/MRumore/g/testbin/postgres/pg.create.table.index.pl \
	training_data2 \
	u03.pcb_mqt_pos_aoi_data \
	ftf_filename_id:ufd_machine_order:ufd_lane_no:ufd_stage_no \
	idx_mqt_pos_aoi_fid_mach_lnno_stgno \
	localhost \
	5432 \
	cim
#
/home/MRumore/g/testbin/postgres/pg.create.table.index.pl \
	training_data2 \
	u03.pcb_mqt_pos_aoi_data \
	ftf_filename_id:ufd_machine_order:ufd_lane_no:ufd_stage_no:ftf_filename_timestamp \
	idx_mqt_pos_aoi_fid_mach_lnno_stgno_tst \
	localhost \
	5432 \
	cim
#
/home/MRumore/g/testbin/postgres/pg.create.table.index.pl \
	training_data2 \
	u03.pcb_mqt_pos_aoi_data \
	ftf_filename_id:ufd_pcb_id:ufd_machine_order:ufd_lane_no:ufd_stage_no \
	idx_mqt_pos_aoi_fid_pcbid_mach_lnno_stgno \
	localhost \
	5432 \
	cim
#
/home/MRumore/g/testbin/postgres/pg.create.table.index.pl \
	training_data2 \
	u03.pcb_mqt_pos_aoi_data \
	ftf_filename_id:upx_mjsid:upi_lotname:ufd_machine_order:ufd_lane_no:ufd_stage_no:ftf_filename_timestamp \
	idx_mqt_pos_aoi_fid_prod_mach_lnno_stgno_tst \
	localhost \
	5432 \
	cim
#
/home/MRumore/g/testbin/postgres/pg.create.table.index.pl \
	training_data2 \
	u03.pcb_mqt_pos_aoi_data \
	upx_mjsid:upi_lotname:ufd_machine_order:ufd_lane_no:ufd_stage_no:ftf_filename_timestamp \
	idx_mqt_pos_aoi_prod_mach_lnno_stgno_tst \
	localhost \
	5432 \
	cim
#
exit 0
