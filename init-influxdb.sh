#!/bin/bash
#set -x

if [ -z "$1" ]; then
  echo "Usage: $0 <db-name> <duration>"
  exit 1
fi

DB=$1
if [ -z "$2" ]; then
  DUR=35d
  echo "Use default duration: $DUR"
else
  DUR=$2
fi

HOST=localhost
PORT=9928

init_database() {
  curl -i -XPOST http://$HOST:$PORT/query --data-urlencode "q=DROP DATABASE $DB"
  curl -i -XPOST http://$HOST:$PORT/query --data-urlencode "q=CREATE DATABASE $DB WITH DURATION $DUR"
}

init_database

