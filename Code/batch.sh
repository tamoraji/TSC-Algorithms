#!/bin/bash

#target_dir="1-time-series classification in manufacturing/Code"
#cp "logperf.sh" "${target_dir}"
#pushd "${target_dir}"

./logperf.sh python3 TS1KNN.py --dataset PHM2022 --distance dtw
./logperf.sh python3 TS1KNN.py --dataset PHM2022 --distance erp
./logperf.sh python3 TS1KNN.py --dataset PHM2022 --distance euclidean
./logperf.sh python3 TS1KNN.py --dataset PHM2022 --distance lcss
./logperf.sh python3 TS1KNN.py --dataset PHM2022 --distance wdtw
./logperf.sh python3 TS1KNN.py --dataset PHM2022 --distance twe
./logperf.sh python3 TS1KNN.py --dataset PHM2022 --distance msm
./logperf.sh python3 TS1KNN.py --dataset PHM2022 --distance ddtw
./logperf.sh python3 CIF.py --dataset PHM2022 --data_path ../Datasets
./logperf.sh python3 WEASELMUSE.py --dataset PHM2022 --data_path ../Datasets
./logperf.sh python3 LR.py --dataset PHM2022 --data_path ../Datasets
./logperf.sh python3 RF.py --dataset PHM2022 --data_path ../Datasets
./logperf.sh python3 SVM.py --dataset PHM2022 --data_path ../Datasets

echo ""
echo ""
echo ""
echo "High Priority Runs Complete"
echo ""
echo ""
echo ""

# Single Core
./logperf.sh python3 TS1KNN.py --dataset bearing_dataset --distance dtw
./logperf.sh python3 TS1KNN.py --dataset condition_monitoring_hydraulic --distance dtw
./logperf.sh python3 TS1KNN.py --dataset Gas_sensor --distance dtw
#./logperf.sh python3 TS1KNN.py --dataset PHM2022 --distance dtw
./logperf.sh python3 TS1KNN.py --dataset bearing_dataset --distance erp
./logperf.sh python3 TS1KNN.py --dataset condition_monitoring_hydraulic --distance erp
./logperf.sh python3 TS1KNN.py --dataset Gas_sensor --distance erp
#./logperf.sh python3 TS1KNN.py --dataset PHM2022 --distance erp
./logperf.sh python3 TS1KNN.py --dataset bearing_dataset --distance euclidean
./logperf.sh python3 TS1KNN.py --dataset condition_monitoring_hydraulic --distance euclidean
./logperf.sh python3 TS1KNN.py --dataset Gas_sensor --distance euclidean
#./logperf.sh python3 TS1KNN.py --dataset PHM2022 --distance euclidean
./logperf.sh python3 TS1KNN.py --dataset bearing_dataset --distance lcss
./logperf.sh python3 TS1KNN.py --dataset condition_monitoring_hydraulic --distance lcss
./logperf.sh python3 TS1KNN.py --dataset Gas_sensor --distance lcss
#./logperf.sh python3 TS1KNN.py --dataset PHM2022 --distance lcss
./logperf.sh python3 TS1KNN.py --dataset bearing_dataset --distance wdtw
./logperf.sh python3 TS1KNN.py --dataset condition_monitoring_hydraulic --distance wdtw
./logperf.sh python3 TS1KNN.py --dataset Gas_sensor --distance wdtw
#./logperf.sh python3 TS1KNN.py --dataset PHM2022 --distance wdtw
./logperf.sh python3 TS1KNN.py --dataset bearing_dataset --distance twe
./logperf.sh python3 TS1KNN.py --dataset condition_monitoring_hydraulic --distance twe
./logperf.sh python3 TS1KNN.py --dataset Gas_sensor --distance twe
#./logperf.sh python3 TS1KNN.py --dataset PHM2022 --distance twe
./logperf.sh python3 TS1KNN.py --dataset bearing_dataset --distance msm
./logperf.sh python3 TS1KNN.py --dataset condition_monitoring_hydraulic --distance msm
./logperf.sh python3 TS1KNN.py --dataset Gas_sensor --distance msm
#./logperf.sh python3 TS1KNN.py --dataset PHM2022 --distance msm
./logperf.sh python3 TS1KNN.py --dataset bearing_dataset --distance ddtw
./logperf.sh python3 TS1KNN.py --dataset condition_monitoring_hydraulic --distance ddtw
./logperf.sh python3 TS1KNN.py --dataset Gas_sensor --distance ddtw
#./logperf.sh python3 TS1KNN.py --dataset PHM2022 --distance ddtw

#python3 CIF.py --dataset <datasetname> --data_path <path> --est <default=500> --att <default=8>
# Parallel
./logperf.sh python3 CIF.py --dataset bearing_dataset --data_path ../Datasets
./logperf.sh python3 CIF.py --dataset condition_monitoring_hydraulic --data_path ../Datasets
./logperf.sh python3 CIF.py --dataset Gas_sensor --data_path ../Datasets
#./logperf.sh python3 CIF.py --dataset PHM2022 --data_path ../Datasets

#python3 WEASELMUSE.py --dataset <datasetname> --data_path <path>
# Single Core
./logperf.sh python3 WEASELMUSE.py --dataset bearing_dataset --data_path ../Datasets
./logperf.sh python3 WEASELMUSE.py --dataset condition_monitoring_hydraulic --data_path ../Datasets
./logperf.sh python3 WEASELMUSE.py --dataset Gas_sensor --data_path ../Datasets
#./logperf.sh python3 WEASELMUSE.py --dataset PHM2022 --data_path ../Datasets

#python3 LR.py --dataset <datasetname> --data_path <path> --C <default=10>
# Parallel
./logperf.sh python3 LR.py --dataset bearing_dataset --data_path ../Datasets
./logperf.sh python3 LR.py --dataset condition_monitoring_hydraulic --data_path ../Datasets
./logperf.sh python3 LR.py --dataset Gas_sensor --data_path ../Datasets
#./logperf.sh python3 LR.py --dataset PHM2022 --data_path ../Datasets

#python3 RF.py --dataset <datasetname> --data_path <path> --n_trees <default=500>
# Parallel
./logperf.sh python3 RF.py --dataset bearing_dataset --data_path ../Datasets
./logperf.sh python3 RF.py --dataset condition_monitoring_hydraulic --data_path ../Datasets
./logperf.sh python3 RF.py --dataset Gas_sensor --data_path ../Datasets
#./logperf.sh python3 RF.py --dataset PHM2022 --data_path ../Datasets

#python3 SVM.py --dataset <datasetname> --data_path <path> --C <default=10>
# Single Core
./logperf.sh python3 SVM.py --dataset bearing_dataset --data_path ../Datasets
./logperf.sh python3 SVM.py --dataset condition_monitoring_hydraulic --data_path ../Datasets
./logperf.sh python3 SVM.py --dataset Gas_sensor --data_path ../Datasets
#./logperf.sh python3 SVM.py --dataset PHM2022 --data_path ../Datasets

#popd

