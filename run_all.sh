#!/bin/bash

ORANGE="\e[1;38m"
RED="\e[1;31m"
YELLOW="\e[1;33m"
BLUE="\e[1;34m"
END="\e[0m"
REPLAYD_SERVER="replayd_server"

function build_replayd {
    echo -e "$ORANGE Cleaning up if required... $END"
    # stop if we already have server running
    docker stop $REPLAYD_SERVER
    docker rmi c7-systemd-sshd

    echo -e "$ORANGE====================================== $END"
    echo -e "$BLUE     Building Docker Image..  $END"
    echo -e "$ORANGE====================================== $END"
    cd build
    docker build --rm -t c7-systemd-sshd .
    printf "\nour docker image is...\n"
    docker images c7-systemd-sshd
    cd ..
    echo -e "$YELLOW Successfully build docker image.. $END"
}

function run_config_replayd {
    echo -e "$ORANGE Cleaning up if required... $END"
    # stop if we already have server running
    docker stop $REPLAYD_SERVER
    echo -e "$ORANGE====================================== $END"
    echo -e "$BLUE     Creating the container... $END"
    echo -e "$ORANGE====================================== $END"
    docker run -d --name $REPLAYD_SERVER --rm --privileged=true -p 22222:22 -p 6080:6080 -v /sys/fs/cgroup:/sys/fs/cgroup:ro c7-systemd-sshd
    printf "replayd_container ..\n"
    docker ps -f "name=$REPLAYD_SERVER"
    server_ip=`docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $REPLAYD_SERVER`
    echo -e "$YELLOW$REPLAYD_SERVER is running with ip : $server_ip $END"

    printf "configuring our server ..."
    cd config
    # Not able to use command line args for hosts , giving error. temporary solution
    awk 'f{$0="'$server_ip'";f=0}/REPLAYD_SERVER/{f=1}1' temp_hosts > hosts
    ansible-playbook replayd.yaml 
    cd ..
    echo -e "$YELLOW Successfully configured $REPLAYD_SERVER $END"
}

function test_replayd {
    echo -e "$BLUEPerforming unit test... $END"
    cd test
    ./unit_test.sh
    cd ..
}

function show_help {
    echo "run_all.sh <all | build | run | test>"
    echo "all will do all steps, build,run,test"
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
