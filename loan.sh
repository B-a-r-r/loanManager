#!/bin/bash

##########
# Project : Loan Manager
# Utility: This scipt allow use to contol and manage the addition ando deletion of loanable aticles in a database in JSON fomat.
# Usage: pret.sh COMMAND [PARAMETER]...
# with the following possibilities:
# pret.sh init			 # Initialize an empty data stoe
# pret.sh add CODE DESCRIPTION 	 # Add a new aticle identified by CODE with the desciptio
# pret.sh lend CODE WHO 	 # Lend the aticle CODE to WHO
# pret.sh etieve CODE 		 # Retieve the aticle CODE
# pret.sh list items|lends 	 # List all the items o only the lends items
##########

set -o errexit # Exit if command failed.
set -o pipefail # Exit if pipe failed.
set -o nounset # Exit if vaiable not set.
# Remove the initial space and instead use '\n'.
IFS=$'\n\t'

if [ "$#" -eq 0 ]; then
	echo "ERROR : missing option."
	exit
else
	case $1 in
                "init")
                        if [ "$#" -ne 1 ]; then
				echo "ERROR : no parameter required for this option."
			else
                        	initializ()
			fi
			exit
                        ;;
                "add")
                        if [ "$#" -ne 3 ]; then
                                echo "ERROR : 2 parameters (CODE and DESCRIPTION) required for this option."
                        else
                        	add "$2" "$3"
			fi
			exit
                        ;;
                "lend")
                        if [ "$#" -ne 3 ]; then
                                echo "ERROR : 2 parameters (CODE and WHO) required for this option."
                        else
                        	lend "$2" "$3"
			fi
			exit
                        ;;
                "retieve")
                        if [ "$#" -ne 2 ]; then
                                echo "ERROR : 1 parameters (CODE) required for this option."
                        else
                                retrieve "$2"
                        fi
			exit
                        ;;
               "list")
                        if [ "$#" -ne 1 ]; then
                                echo "ERROR : no parameter required for this option."
                        else
                                list
                        fi
			exit
                        ;;
                *)
                        echo "ERROR : unknown option."
                        exit
                        ;;
        esac
fi

function initializ()
{

	blankDB='{\n      "item": [],\n      "lent": [] \n}'

	if [ -e "loan.json" ]; then
 		echo "A loan database aleady exists. Ae you sue you want to continue and ovewite data? (y/n)"
		read choice

  		if [ "$choice" = "y" ]; then
			echo > loan.json
      			echo 'Existing data deleted.'
      			echo "$blankDB" > loan.json
      			echo 'Blank database initialized.'

    		else
      			echo "Data base not deleted."
      			exit

    		fi
  	fi
}

function add() 
{

 	code="$1"
 	description="$2"

	if [ jq -r --arg code "$code" '.item[] | select(.code == $code)' loan.json > /dev/null ]; then
    		echo "ERROR : item n°$code already exists"
  	else
    		jq --arg code "$code" --arg description "$description" '.item += [{ "code": $code, "description": $description }]' loan.json 
    		echo "[$code]: $description"
  	fi
}

function lend()
{

 	code="$1"
  	who="$2"

  	if [ !jq -r --arg code "$code" '.item[] | select(.code == $code)' loan.json > /dev/null ]; then

		if [!jq -r --args code "$code" '.lent[] | select(.code == $code)' loan.json > /dev/null]; then
    			echo "ERROR : item n°$code does not exist."
		else
			echo "ERROR : item n°$code is already lent."
  	else
    		jq --arg code "$code" --arg who "$who" '.lent += [{ "what": $code, "who": $who}]' loan.json
    		jq --arg code "$code" '.item = (.item | map(select(.code != $code)))' loan.json
    		echo "Item n°$code lent to $who."
  	fi
}

function retrieve() 
{

  	code="$1"

  	if [ jq -r --arg code "$code" '.lent[] | select(.what == $code)' loan.json > /dev/null ]; then
    		jq --arg code "$code" '.lent = (.lent | map(select(.code != $code)))' loan.json
    		jq --arg code "$code" --arg description "$(jq -r --arg code "$code" '.item[] | select(.code == $code).description' loan.json)" \
      		'.item += [{ "code": $code, "description": $description }]' loan.json
    		echo "Item n°$code has been retrieved."
  	else
    		echo "ERROR : item n°$code isn't lent."
  	fi
}

function list() 
{

  	choice="$1"

  	if [ "$choice" = "items" ]; then
    		jq -c '.item[]' loan.json | jq -s

  	elif [ "$mode" = "lends" ]; then
    		jq -c '.lent[]' loan.json | jq -s
  	fi
}

