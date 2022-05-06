#! /bin/bash

create_namespace(){
    kubectl apply -f namespace.yml
}

create_cert_manager(){
    kubectl apply -f cert-manager-arm.yaml
}



{
    create_namespace &&
    create_cert_manager
}