#!/bin/bash

#set -eu

APP_NAME=@option.app@
GIT_TAG=@option.tag@

export DOCKER_TAG=$(echo ${GIT_TAG} | awk -F"-" '{print $(NF-1)}')

TMPL_PATH="/opt/git/k8s_yml_tmpl/tmpl/deployment"
YML_PATH="/opt/git/k8s_yml_tmpl/yml/deployment"

[ -d ${YML_PATH} ] || mkdir -p ${YML_PATH}

cd ${TMPL_PATH}
echo -e "\e[1;32m current dir :\e[0m" "\e[1;31m $(pwd) \e[0m"
echo " current branch : $(git branch | grep '*') "
git pull || { git reset --hard HEAD~20; git pull ;  }

echo -e "\e[1;32m generate yml :\e[0m" "\e[1;31m ${APP_NAME}.yml \e[0m"
echo -e "\e[1;32m docker image ver :\e[0m" "\e[1;31m ${DOCKER_TAG} \e[0m"
envsubst < ${APP_NAME}.yml > ${YML_PATH}/${APP_NAME}.yml

ls -lrht ${YML_PATH}/${APP_NAME}.yml
kubectl apply -f ${YML_PATH}/${APP_NAME}.yml

sleep 10
echo -e "\e[1;32m --------k8s componentstatus--------\e[0m"
kubectl get componentstatus

echo -e "\e[1;32m --------k8s deployment--------\e[0m"
kubectl -n=prod get deployment | grep -e NAME -e ${APP_NAME}

echo -e "\e[1;32m --------k8s pod--------\e[0m"
kubectl -n=prod get pod | grep -e NAME -e ${APP_NAME}

echo -e "\e[1;32m --------k8s service--------\e[0m"
kubectl -n=prod get service | grep -e NAME -e ${APP_NAME}