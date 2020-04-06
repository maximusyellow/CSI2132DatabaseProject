#!/bin/bash

ACT[0]="Find Properties"
ACT[1]="Host Login"
ACT[2]="Employee Login"
sdate_input = ''
edate_input = ''
guests_input = ''
country_input = ''
host_email_input = ''
employee_id_input = ''

# Find Properties
ACT_0()
{
  export PGPASSWORD='Gvasn2v2bj' #your postgres password
  psql -h 127.0.0.1 -d postgres -U postgres
  read -p "Start Date (YYYY-MM-DD): " sdate_input
  read -p "End Date (YYYY-MM-DD): " edate_input
  read -p "Number of Guests: " guests_input
  read -p "Country: " country_input
  psql -t -d postgres -c 'SELECT property.*, startdate, enddate FROM "OnlineTravel".property natural join "OnlineTravel".booking_info WHERE country LIKE %'$country_input'% and maxguests >= '$guests_input' and (enddate <= '$sdate_input' or startdate >= '$edate_input')'
  
}

# Host Login
ACT_1()
{
  export PGPASSWORD='Gvasn2v2bj' #your postgres password
  psql -h 127.0.0.1 -d postgres -U postgres
  read -p "Email Address (example@example.com): " host_email_input

  output="$(psql -t -d postgres -c 'SELECT EXISTS (SELECT sys_user.* FROM "OnlineTravel".sys_user WHERE email = '$host_email_input')'"
  echo $output
}

LOC_TXT[0]="You found your way out of the cave and have won the game.\nCongratz."
LOC_ACTS[0]=""
LOC_TXT[1]="Welcome to Online Travel\nYou have no memory of how you got here.\nYou can head north toward the cave entrance, or south to head further into the cave."
LOC_ACTS[1]="0,1,2"
LOC_TXT[2]="Stumbling around in the dark cave, you trip and fall down a hole.\nYou break your legs and starve to death.\nSorry about that."
LOC_ACTS[2]=""

LOC=1
while [ true ]; do
  echo -e "${LOC_TXT[$LOC]}"
  echo ""
  
  LEGAL_ACTS=$(echo "${LOC_ACTS[$LOC]}" | sed 's|,|\n|g')
  if [ -z "$LEGAL_ACTS" ]; then
    break
  fi
  
  echo "Available actions:"
  while read -r LOC_ACT; do
    echo -e "\t[${LOC_ACT}] - ${ACT[$LOC_ACT]}"
  done < <(echo "${LEGAL_ACTS}")
  echo -n "What do you want to do? "
  read ACT_INPUT
  
  if [ -z "$(echo "$LEGAL_ACTS" | grep "^${ACT_INPUT}$")" ]; then
    echo "That is not a valid action."
    continue
  fi
  ACT_${ACT_INPUT}
done