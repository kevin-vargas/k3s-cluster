#! /bin/bash

TEMPLATE="./templates/certificate.yaml"
DOMAINS="./domains/"
DNS_REGEX="%DNS_NAME%"
NAME_REGEX="%NAME%"
NAMESPACE_REGEX="%NAMESPACE%"

create_template(){
    local DNS=$1
    local NAME=$(echo "${DNS}" | sed "s/[.]/-/g")
    local NAMESPACE=$2
    local RESULT=$(cat ${TEMPLATE} | sed "s/${DNS_REGEX}/${DNS}/g" | sed "s/${NAME_REGEX}/${NAME}/g" | sed "s/${NAMESPACE_REGEX}/${NAMESPACE}/g")
    echo "$RESULT" > "${DOMAINS}${NAME}-certificate.yaml"
}

create_template api.fast.ar kevin