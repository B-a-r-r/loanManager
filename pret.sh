#!/bin/bash
set -o errexit # Exit if command failed.
set -o pipefail # Exit if pipe failed.
set -o nounset # Exit if variable not set.
# Remove the initial space and instead use '\n'.
IFS=$'\n\t'


commande=$1

case $commande in
null)
  echo "pas d'argument"
  ;;
"init")
  echo "fonction init"
"add")
  echo "fonction add"
  ;;
"lend")
  echo "fonction lend"
  ;;
"retrieve")
  echo "fonction retrieve"
  ;;
"list")
  echo "fonction list"
  ;;
esac


