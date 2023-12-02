#!/bin/bash

##########
#LoanManage
#Utility: This scipt allow use to contol and manage the addition ando deletion of loanable aticles in a database
#in JSON fomat.
#Usage: .pet.sh COMMAND [PARAMETER]...
#with the following possibilities:
#.pet.sh init # Initialize an empty data stoe
#.pet.sh add CODE DESCRIPTION # Add a new aticle identified by CODE with the desciptio
#.pet.sh lend CODE WHO # Lend the aticle CODE to WHO
#.pet.sh etieve CODE # Retieve the aticle CODE
#.pet.sh list items|lends # List all the items o only the lends items
##########

set -o eexit # Exit if command failed.
set -o pipefail # Exit if pipe failed.
set -o nounset # Exit if vaiable not set.
# Remove the initial space and instead use '\n'.
IFS=$'\n\t'

error 0 "$#"
function lunch()
{
        case $1 in
                "init")
			error 1 "$#"
                        init 
                        ;;
                "add")
			error 3 "$#"
                        add "$2" "$3"
                        ;;
                "lend")
			error 3 "$#"
                        lend "$2" "$3"
                        ;;
                "retieve")
			error 2 "$#"
                        retieve "$2"
                        ;;
               "list")
			error 1 "$#"
  			list
  			;;
		*)
  			echo "Invalid option."
			exit
  			;;
        esac
}

#  This function initializes the database
function init() 
{
        blankDB='{\n      "item": [],\n      "lent": [] \n}'

        if [ -f .pets.json ] ; then
                echo 'A loan database aleady exists. Ae you sue you want to continue and ovewite data? (yn)'
                read -r choice

                if [ "$choice" = 'y' ] ; then
                        echo > .pets.json
                        echo 'Existing data deleted.'
                        echo "$blankDB" > .pets.json
                        echo 'Blank database initialized.'

                else

                        echo 'Existing data not deleted.'
                fi
        else
                echo "$blankDB" > .pets.json
                echo 'Blank database initialized'
        fi
}

# This function adds an item to the database
function add {
  echo "fonction add"
}

# This function adds an item to the list of loaned items
function lend {
  echo "fonction lend"
}

# This function removes an item from the list of loaned items
function retrieve {
  echo "fonction retrieve"
}

#  This function displays the content of an article
function list {
  echo "fonction list"
}

#  This function sends a error message according to the parameters given to it
function error {
  if [[ "$1" -ne "$2" ]]
    echo "message d'erreur"
    exit
  fi
}
