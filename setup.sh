#!/bin/bash
set -e
pwdir=.password
vardir=/var/lib/loblab

[ "$(whoami)" == "root" ] || SUDO=sudo

function create_passwords() {
  which pwgen >/dev/null 2>&1 || $SUDO apt -y install pwgen
  test -d $pwdir || mkdir $pwdir
  test -f $pwdir/influxdb.env || echo "INFLUXDB_ADMIN_PASSWORD=$(pwgen -s 20 1)" > $pwdir/influxdb.env
  test -f $pwdir/grafana.env || echo "GF_SECURITY_ADMIN_PASSWORD=$(pwgen -s 20 1)" > $pwdir/grafana.env
  chmod 600 $pwdir/*.env
}

function setup_docker() {
  test -d grafana || mkdir grafana
  test -d influxdb || mkdir influxdb
  docker run --rm influxdb influxd config > influxdb/influxdb.conf

  $SUDO mkdir -p $vardir/grafana
  $SUDO chown -R 472:472 $vardir/grafana
  docker-compose up -d
}

function main() {
  create_passwords
  setup_docker
}

main

