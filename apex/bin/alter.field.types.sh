#!/usr/bin/bash
#
(
cat <<EOF
aoi.u0x_filename_data _machine_order integer
aoi.u0x_filename_data _stage_no integer
aoi.u0x_filename_data _lane_no integer
aoi.u0x_filename_data _output_no integer
crb.u0x_filename_data _machine_order integer
crb.u0x_filename_data _stage_no integer
crb.u0x_filename_data _lane_no integer
crb.u0x_filename_data _output_no integer
u01.u0x_filename_data _machine_order integer
u01.u0x_filename_data _stage_no integer
u01.u0x_filename_data _lane_no integer
u01.u0x_filename_data _output_no integer
u03.u0x_filename_data _machine_order integer
u03.u0x_filename_data _stage_no integer
u03.u0x_filename_data _lane_no integer
u03.u0x_filename_data _output_no integer
aoi.rst_filename_data _lane integer
crb.rst_filename_data _lane integer
u01.rst_filename_data _lane integer
u03.rst_filename_data _lane integer
u01.mountpickupfeeder _usef integer
u01.mountpickupfeeder _fadd integer
u01.mountpickupfeeder _fsadd integer
u01.mountpickupfeeder _user integer
u01.mountpickupfeeder _pickup integer
u01.mountpickupfeeder _pmiss integer
u01.mountpickupfeeder _rmiss integer
u01.mountpickupfeeder _dmiss integer
u01.mountpickupfeeder _mmiss integer
u01.mountpickupfeeder _hmiss integer
u01.mountpickupfeeder _trsmiss integer
u01.mountpickupfeeder _mount integer
u01.mountpickupnozzle _head integer
u01.mountpickupnozzle _nhadd integer
u01.mountpickupnozzle _ncadd integer
u01.mountpickupnozzle _user integer
u01.mountpickupnozzle _nozzlename integer
u01.mountpickupnozzle _pickup integer
u01.mountpickupnozzle _pmiss integer
u01.mountpickupnozzle _rmiss integer
u01.mountpickupnozzle _dmiss integer
u01.mountpickupnozzle _mmiss integer
u01.mountpickupnozzle _hmiss integer
u01.mountpickupnozzle _trsmiss integer
u01.mountpickupnozzle _mount integer
u03.mountqualitytrace _b integer
u03.mountqualitytrace _idnum integer
u03.mountqualitytrace _turn integer
u03.mountqualitytrace _ms integer
u03.mountqualitytrace _ts integer
u03.mountqualitytrace _fadd integer
u03.mountqualitytrace _fsadd integer
u03.mountqualitytrace _nhadd integer
u03.mountqualitytrace _ncadd integer
u03.mountqualitytrace _f integer
u03.mountqualitytrace _rcgx numeric(10,3)
u03.mountqualitytrace _rcgy numeric(10,3)
u03.mountqualitytrace _rcga numeric(10,3)
u03.mountqualitytrace _tcx numeric(10,3)
u03.mountqualitytrace _tcy numeric(10,3)
u03.mountqualitytrace _mposirecx numeric(10,3)
u03.mountqualitytrace _mposirecy numeric(10,3)
u03.mountqualitytrace _mposireca numeric(10,3)
u03.mountqualitytrace _mposirecz numeric(10,3)
u03.mountqualitytrace _thmax numeric(10,3)
u03.mountqualitytrace _thave numeric(10,3)
u03.mountqualitytrace _mntcx numeric(10,3)
u03.mountqualitytrace _mntcy numeric(10,3)
u03.mountqualitytrace _mntca numeric(10,3)
u03.mountqualitytrace _tlx numeric(10,3)
u03.mountqualitytrace _tly numeric(10,3)
u03.mountqualitytrace _inspectarea integer
u03.mountqualitytrace _didnum integer
u03.mountqualitytrace _ds integer
u03.mountqualitytrace _parts integer
u03.mountqualitytrace _warpz numeric(10,3)
EOF
) |
while read table field type
do
    echo "alter table $table alter column $field type ${type} using cast($field as $type);"
done > /tmp/alter.$$
#
psql -d training_data -U cim -f /tmp/alter.$$
#
exit 0
