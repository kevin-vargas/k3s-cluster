#! /bin/bash

SECRET_NAME=docker-registry-htpasswd
FILE=htpasswd
DIR=secrets
FILE_PATH="./${DIR}/${FILE}"

ask_values(){
    read -p 'Username: ' USERNAME_INPUT
}

create_dir(){
    mkdir -p $1
}

create_pass(){
    USERNAME=$1
    FILE=$2
    htpasswd -Bc $FILE $USERNAME
}

create_secret(){
    NAME=$1
    FILE=$2
    kubectl create secret generic $NAME --from-file $FILE
}

{
    create_dir $DIR &&
    ask_values &&
    create_pass $USERNAME_INPUT $FILE_PATH &&
    create_secret $SECRET_NAME $FILE_PATH
}