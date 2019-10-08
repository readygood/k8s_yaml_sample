#!/bin/bash
JSON_FILE="/var/jenkins_home/rundeck_options_tag/${JOB_NAME}.json"
cd  ${WORKSPACE}
echo '[' > ${JSON_FILE}
TAGS=$(git tag | grep ${JOB_NAME} | grep -e ${XB_YYMM} -e ${XB_YYMM_L} -e ${XB_YYMM_LL} | sort -r | head -n 10 )
echo ${TAGS}
for TAG in ${TAGS}
do
     echo '"'${TAG}'"'',' >> ${JSON_FILE}
done
sed -i '$s/,//' ${JSON_FILE}
echo ']' >> ${JSON_FILE}