set -x
cd ../TypeChef
sbt mkrun
cd ../TypeChef-BusyboxAnalysis
rm -rf VSAT_metadata
./cleanBusybox.sh
./analyzeBusybox.sh | tee vsat_outputOfLastExecution.txt