#
# denormalize the data we have to include only the fields we want.
#
trd_denorm = list();
#
trd_denorm[["aoi_count"]] = 
	merge(x=trd$aoi, y=trd$count, by.x="_pcbid", by.y="_pcb_id")
nrow(trd_denorm[["aoi_count"]])
length(trd_denorm[["aoi_count"]])
#
trd_denorm[["aoi_time"]] = 
	merge(x=trd$aoi, y=trd$time, by.x="_pcbid", by.y="_pcb_id")
nrow(trd_denorm[["aoi_time"]])
length(trd_denorm[["aoi_time"]])
#
trd_denorm[["aoi_feeder"]] = 
	merge(x=trd$aoi, y=trd$feeder, by.x="_pcbid", by.y="_pcb_id")
nrow(trd_denorm[["aoi_feeder"]])
length(trd_denorm[["aoi_feeder"]])
#
trd_denorm[["aoi_nozzle"]] = 
	merge(x=trd$aoi, y=trd$nozzle, by.x="_pcbid", by.y="_pcb_id")
nrow(trd_denorm[["aoi_nozzle"]])
length(trd_denorm[["aoi_nozzle"]])
#
