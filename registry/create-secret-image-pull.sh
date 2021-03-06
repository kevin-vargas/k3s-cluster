#! /bin/bash

SECRET_NAME=regcred
ask_values(){
    read -p 'Server: ' SERVER_INPUT
    read -p 'Username: ' USERNAME_INPUT
    read -p 'Namespace: ' NAMESPACE_INPUT
    read -sp 'Password: ' PASSWORD_INPUT
}

create_secret(){
    local NAMESPACE_SECRET

    if [ ! -z ${NAMESPACE_INPUT+x} ];
    then
        NAMESPACE_SECRET="--namespace=${NAMESPACE_INPUT}"
    fi

    kubectl create secret docker-registry $SECRET_NAME --docker-server=$SERVER_INPUT --docker-username=$USERNAME_INPUT --docker-password=$PASSWORD_INPUT ${NAMESPACE_SECRET}

}

{
    ask_values &&
    create_secret
}