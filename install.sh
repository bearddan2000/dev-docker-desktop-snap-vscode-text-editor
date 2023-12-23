#!/usr/bin/env bash

basefile="install"
logfile="general.log"
timestamp=`date '+%Y-%m-%d %H:%M:%S'`

if [ "$#" -ne 1 ]; then
  msg="[ERROR]: $basefile failed to receive enough args"
  echo "$msg"
  echo "$msg" >> $logfile
  exit 1
fi

function setup-logging(){
  scope="setup-logging"
  info_base="[$timestamp INFO]: $basefile::$scope"

  echo "$info_base started" >> $logfile

  echo "$info_base removing old logs" >> $logfile

  rm -f $logfile

  echo "$info_base ended" >> $logfile

  echo "================" >> $logfile
}

function root-check(){
  scope="root-check"
  info_base="[$timestamp INFO]: $basefile::$scope"

  echo "$info_base started" >> $logfile

  #Make sure the script is running as root.
  if [ "$UID" -ne "0" ]; then
    echo "[$timestamp ERROR]: $basefile::$scope you must be root to run $0" >> $logfile
    echo "==================" >> $logfile
    echo "You must be root to run $0. Try the following"
    echo "sudo $0"
    exit 1
  fi

  echo "$info_base ended" >> $logfile
  echo "================" >> $logfile
}

function docker-check() {
  scope="docker-check"
  info_base="[$timestamp INFO]: $basefile::$scope"
  cmd=`docker -v`

  echo "$info_base started" >> $logfile

  if [ -z "$cmd" ]; then
    echo "$info_base docker not installed"
    echo "$info_base docker not installed" >> $logfile
  fi

  echo "$info_base ended" >> $logfile
  echo "================" >> $logfile

}

function usage() {
    echo ""
    echo "Usage: "
    echo ""
    echo "-u: start."
    echo "-d: tear down."
    echo "-h: Display this help and exit."
    echo ""
}
function start-up(){

  scope="start-up"
  local app="code"
  info_base="[$timestamp INFO]: $basefile::$scope"

  echo "$info_base started" >> $logfile

  xhost + local:docker

  sudo docker build -t snapd .

  echo "$info_base running image" >> $logfile

  sudo docker run --name snapd -ti -d \
    --tmpfs /tmp --tmpfs /run --tmpfs /run/lock \
    --privileged -v /lib/modules:/lib/modules:ro \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    snapd

  sudo docker exec -it snapd /bin/bash -c "snap install ${app} --classic"

  # Security patch
  sudo docker exec -it snapd mount -t securityfs securityfs /sys/kernel/security

  # As root
  sudo docker exec -it snapd /bin/bash -c "$(whereis ${app}) --no-sandbox --user-data-dir /home/developer ."

  # As developer
  # sudo docker exec -it -u developer snapd $app .

  echo "$info_base running image" >> $logfile

  echo "$info_base ended" >> $logfile

  echo "================" >> $logfile
}
function tear-down(){

    scope="tear-down"
    info_base="[$timestamp INFO]: $basefile::$scope"

    echo "$info_base started" >> $logfile

    echo "$info_base services removed" >> $logfile

    sudo docker stop snapd
    
    sudo docker rm $(sudo docker ps -aq)

    echo "$info_base ended" >> $logfile

    echo "================" >> $logfile
}

root-check
docker-check

while getopts ":udh" opts; do
  case $opts in
    u)
      setup-logging
      start-up ;;
    d)
      tear-down ;;
    h)
      usage
      exit 0 ;;
    /?)
      usage
      exit 1 ;;
  esac
done
