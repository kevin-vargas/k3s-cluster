#! /bin/bash
BOOT_CMDLINE_DIR="./cmdline.txt"
BOOT_CONFIG_DIR="./config.txt"
echo "Running master node install"

upgrade_system(){
    sudo apt update && sudo apt upgrade
    return 0
}

append(){
    local TO_ADD=$1
    local APPEND_DIR=$2
    grep -q "$TO_ADD" $APPEND_DIR
    if [ $? -eq 0 ]
    then
        echo "File $APPEND_DIR has $TO_ADD"
    else
        echo -n "$TO_ADD" >> $APPEND_DIR
    fi
    return 0
}

appendln(){
    local TO_ADD=$1
    local APPEND_DIR=$2
    grep -q "$TO_ADD" $APPEND_DIR
    if [ $? -eq 0 ]
    then
        echo "File $APPEND_DIR has $TO_ADD"
    else
        printf "\n$TO_ADD\n" >> $APPEND_DIR
    fi
    return 0
}

add_memory_config(){
    local TO_ADD=" cgroup_enable=memory cgroup_memory=1"
    append "$TO_ADD" $BOOT_CMDLINE_DIR
}

add_config(){
    local TO_ADD="arm_64bit=1"
    appendln $TO_ADD $BOOT_CONFIG_DIR
}

get_k3s(){
    local TOKEN_DIR="/var/lib/rancher/k3s/server/node-token"
    local TOKEN="token"
    (curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644) && 
    kubectl get nodes &&
    echo "Saving token in $TOKEN" &&
    cat $TOKEN_DIR > $TOKEN 
}

{
    upgrade_system &&
    add_memory_config &&
    add_config &&
    get_k3s
}
