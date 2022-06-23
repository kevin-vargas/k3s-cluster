#! /bin/bash

TEMPLATE="./templates/certificate.yaml"
DOMAINS="./domains/"
DNS_REGEX="%DNS_NAME%"
NAME_REGEX="%NAME%"
NAMESPACE_REGEX="%NAMESPACE%"

ask_values(){
    read -p 'Namespace: ' NAMESPACE_INPUT
    read -p 'DNS: ' DNS_INPUT
}

create_template(){
    local DNS=$1
    local NAME=$(echo "${DNS}" | sed "s/[.]/-/g")
    local NAMESPACE=$2
    local RESULT=$(cat ${TEMPLATE} | sed "s/${DNS_REGEX}/${DNS}/g" | sed "s/${NAME_REGEX}/${NAME}/g" | sed "s/${NAMESPACE_REGEX}/${NAMESPACE}/g")
    echo "$RESULT" > "${DOMAINS}${NAME}-certificate.yaml"
}

{
    ask_values && 
    create_template $DNS_INPUT $NAMESPACE_INPUT 
}
