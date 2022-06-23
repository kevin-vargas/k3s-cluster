#! /bin/bash
BOOT_CMDLINE_DIR="/boot/cmdline.txt"
BOOT_CONFIG_DIR="/boot/config.txt"
echo "Running k3s install script"
NODE=$1

is_master(){
    local WORKER="WORKER"
    if [ "$NODE" == "WORKER" ]
    then
        return 1
    fi
    return 0
}

ask_type_node(){
    local YN
    echo "Select type of node:"
    select YN in "MASTER" "WORKER"; do
        case $YN in
            MASTER ) return 0;;
            WORKER ) return 1;;
        esac
    done
}

upgrade_system(){
    sudo apt update && sudo apt upgrade -y
    return 0
}

append(){
    local TO_ADD=$1
    local APPEND_DIR=$2
    grep -q "$TO_ADD" $APPEND_DIR
    if [ $? -eq 0 ]
    then
        echo "File $APPEND_DIR has $TO_ADD"
        return 1
    else
        echo -n "$TO_ADD" >> $APPEND_DIR
        return 0
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
        return 1
    else
        printf "\n$TO_ADD\n" >> $APPEND_DIR
        return 0
    fi
}

add_memory_config(){
    local TO_ADD=" cgroup_memory=1 cgroup_enable=memory"
    append "$TO_ADD" $BOOT_CMDLINE_DIR
}

add_config(){
    local TO_ADD="arm_64bit=1"
    appendln $TO_ADD $BOOT_CONFIG_DIR
}
install_master(){
    local TOKEN_DIR="/var/lib/rancher/k3s/server/node-token"
    local TOKEN="token"
    (curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644) && 
    kubectl get nodes &&
    echo "Saving token in $TOKEN" &&
    cat $TOKEN_DIR > $TOKEN 
}

install_worker(){
    local HAS_PORT=":[0-9]+"
    local DEFAULT_PORT="6443"
    local MASTER NODE_NAME K3S_TOKEN
    read -p 'Master URL: ' MASTER
    read -p 'Node Name: ' NODE_NAME
    read -sp 'Token: ' K3S_TOKEN
    if ! [[ $MASTER =~ $HAS_PORT ]]
    then
        MASTER="${MASTER}:${DEFAULT_PORT}"
    fi
    curl -sfL https://get.k3s.io | K3S_URL=${MASTER} K3S_TOKEN=${K3S_TOKEN} K3S_NODE_NAME=${NODE_NAME} sh -
}

install(){
    if ask_type_node
    then
        install_master
    else
        install_worker
    fi
    return 0
}

{
    upgrade_system &&
    add_memory_config &&
    add_config &&
    install
}
