#!/bin/bash

REPLAYD_SERVER="replayd_server"
function build_replayd {
    # stop if we already have server running
    docker stop $REPLAYD_SERVER
    docker rmi c7-systemd-sshd

    echo "======================================"
    echo "Building Docker Image.."
    echo "======================================"
    cd build
    docker build --rm -t c7-systemd-sshd .
    printf "\nour docker image is...\n"
    docker images c7-systemd-sshd
    cd ..
}

function run_config_replayd {
    echo "======================================"
    printf "Creating the container...\m"
    echo "======================================"
    docker run -d --name $REPLAYD_SERVER --rm --privileged=true -p 22222:22 -p 6080:6080 -v /sys/fs/cgroup:/sys/fs/cgroup:ro c7-systemd-sshd
    printf "replayd_container ..\n"
    docker ps -f "name=$REPLAYD_SERVER"
    rep_ip=`docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $REPLAYD_SERVER`
    printf "$REPLAYD_SERVER is running with ip : $rep_ip\n"

    printf "configuring our server ..."
    cd config
    ansible-playbook replayd.yaml --extra-vars "REPLAYD_SERVER=$rep_ip"
    cd ..

}

function test_replayd {
    echo "======================================"
    echo "performing unit test..."
    echo "======================================"
    cd test
    ./unit_test.sh
    cd ..
}

function show_help {
    echo "run_all.sh <all | build | run | test>"
    echo "build will do all steps, build,run,test"
    echo "build will build docker image"
    echo "run will create a docker container and configures replayd server on port 6080"
    echo "test will perform post and get to make sure what we get is what we set"
    echo ""
}


# This script will build, test and deploy

case $1 in 
    all)
    build_replayd
    run_config_replayd
    test_replayd
    ;;

    build)
    build_replayd
    ;;

    run)
    run_config_replayd
    ;;

    test)
    test_replayd
    ;;

    *)
    show_help
esac
