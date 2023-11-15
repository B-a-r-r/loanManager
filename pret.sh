#!/bin/bash
set -o errexit # Exit if command failed.
set -o pipefail # Exit if pipe failed.
set -o nounset # Exit if variable not set.
# Remove the initial space and instead use '\n'.
IFS=$'\n\t'



function init {
  echo "fonction init"
}

function add {
  echo "fonction add"
}

function lend {
  echo "fonction lend"
}

function retrieve {
  echo "fonction retrieve"
}

function list {
  echo "fonction list"
}

function error {
  if [[ "$1" -eq "$2" ]]
    then
    echo "message d'erreur"
    exit
  fi
}

error 0 "$#"

case $1 in
"init")
  init
  ;;
"add")
  add
  ;;
"lend")
  lend
  ;;
"retrieve")
  retrieve
  ;;
"list")
  list
  ;;
*)
  echo "message d'erreur"
  ;;
esac
