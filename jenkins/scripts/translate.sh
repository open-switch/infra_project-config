PATH=$PATH:home/jenkins/HP_Fortify/HP_Fortify_SCA_and_Apps_4.40/bin

SCACMD=/home/jenkins/HP_Fortify/HP_Fortify_SCA_and_Apps_4.40/bin/sourceanalyzer

BUILDID=$1
ProjectID=$2
shift 2
TRANSLATEOPTS=$*

#Translate Source Code to Fortify NST files
$SCACMD -b ${BUILDID} -verbose -source 1.7 -logfile ${BUILDID}.log ${TRANSLATEOPTS}
#Scan Fortify NST Files
$SCACMD -b ${BUILDID} -verbose -Xmx4000m -logfile ${BUILDID}.log -scan -f ${BUILDID}.fpr
#upload fpr to ssc
/home/jenkins/HP_Fortify/HP_Fortify_SCA_and_Apps_4.40/bin/fortifyclient uploadFPR -url http://ssc-nos.rose.rdlabs.hpecorp.net:8080/ssc -authtoken 1d98e836-41b7-4910-8ff1-e99e3b309593 -projectVersionID ${ProjectID} -file ${BUILDID}.fpr
# Cleanup temp area
$SCACMD -b ${BUILDID} -show-files
#$SCACMD -b ${BUILDID} -clean
