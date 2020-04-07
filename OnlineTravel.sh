#!/bin/bash
ACT[0]="Find Properties"
ACT[1]="Host Login"
ACT[2]="Employee Login"
sdate_input=''
edate_input=''
guests_input=''
country_input=''
host_email_input=''
employee_email_input=''
per_night_fee=''
name=''
max_guests=''
num_bathrooms=''
house_number=''
street=''
postal_code=''
city=''
province=''
entire_home=''
spark_clean=''
wifi=''
heating=''
description=''
country=''
# Find Properties
ACT_0()
{
  read -p "Start Date (YYYY-MM-DD): " sdate_input
  read -p "End Date (YYYY-MM-DD): " edate_input
  read -p "Number of Guests: " guests_input
  read -p "Country: " country_input
  export PGPASSWORD='XXXXXXXX' #your postgres password
  psql -h 127.0.0.1 -d postgres -U postgres -c "\encoding UTF8;" -c "SELECT property.propertyid, property.name, property.maxguests, property.pernightfee, property.city FROM \"OnlineTravel\".property natural join \"OnlineTravel\".booking_info WHERE country LIKE '%$country_input%' and maxguests >= '$guests_input' and (enddate <= '$sdate_input' or startdate >= '$edate_input')"
  echo "Properties listed above are available during your selected dates"
  #option=''
  #read -p "Would you like to sort results? Price - [ASC/DESC] " option
  #export PGPASSWORD='XXXXXXXX' #your postgres password
  #psql -h 127.0.0.1 -d postgres -U postgres -c "SELECT property.propertyid, property.name, property.maxguests, property.pernightfee, property.city FROM \"OnlineTravel\".property natural join \"OnlineTravel\".booking_info WHERE country LIKE '%$country_input%' and maxguests >= '$guests_input' and (enddate <= '$sdate_input' or startdate >= '$edate_input') ORDER BY \"OnlineTravel\".property.pernightfee '$option'"
  

}

# Host Login
ACT_1()
{
  userid=''
  read -p "Email Address (example@example.com): " host_email_input
  export PGPASSWORD='XXXXXXXX' #your postgres password
  userid=`psql -X -h 127.0.0.1 -d postgres -U postgres -t -c "SELECT sys_user.userid FROM \"OnlineTravel\".sys_user WHERE email LIKE '%$host_email_input%'"`
  userid=$(echo ${userid:1})
  echo "Found userid: $userid"
  option=''
  if [[ $userid != '' ]]; then
    echo "Welcome $host_email_input"
    read -p 'Would you like to make a listing [Y/N]? ' option
    if [[ $option == "Y" ]]; then
      propertyid=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
      read -p "Per Night Fee $" per_night_fee
      read -p "Name of Property " name
      read -p "Max Number of Guests " max_guests
      read -p "Number of Bathrooms " num_bathrooms
      read -p "House Number " house_number
      read -p "Street " street
      read -p "Postal Code " postal_code
      read -p "City " city
      read -p "Province " province
      read -p "Country " country
      read -p "Entire Home? (true/false) " entire_home
      read -p "Spark Clean? (true/false) " spark_clean
      read -p "WIFI? (true/false) " wifi
      read -p "Heating? (true/false) " heating
      read -p "Description " description
      export PGPASSWORD='XXXXXXXX' #your postgres password
      country=`psql -X -h 127.0.0.1 -d postgres -U postgres -t -c "SELECT branch.country FROM \"OnlineTravel\".branch WHERE country LIKE '%$country%'"`
      country=$(echo ${country:1})
      export PGPASSWORD='XXXXXXXX' #your postgres password
      psql -h 127.0.0.1 -d postgres -U postgres -c "INSERT INTO \"OnlineTravel\".property(propertyid, userid, pernightfee, name, maxguests, numbathrooms, housenumber, street, postalcode, city, province, country, entirehome, sparkclean, wifi, heating, description) 
      VALUES ( '$propertyid', '$userid', '$per_night_fee', '$name', $max_guests, $num_bathrooms, $house_number, '$street', '$postal_code', '$city', '$province', '$country', $entire_home, $spark_clean, $wifi, $heating, '$description');"
    fi
  else
    echo "The email specified does not exist in the system, please try again"
  fi
}

ACT[3]="List upcoming booked properties for your branch"
ACT[4]="List upcoming available properties for your branch"

#List upcoming booked properties for your branch
ACT_3() 
{
  option=''
  current_date=$(date +%F)
  read -p "Specify Branch Country: " country_input
  export PGPASSWORD='XXXXXXXX' #your postgres password
  psql -h 127.0.0.1 -d postgres -U postgres -c "\encoding UTF8;" -c "SELECT property.propertyid, booking_info.bookingid, booking_info.bookerid, property.name, property.maxguests, property.pernightfee, property.city, startdate, enddate FROM \"OnlineTravel\".property natural join \"OnlineTravel\".booking_info WHERE country LIKE '%$country_input%' and (startdate > '$current_date' ) ORDER BY startdate ASC;"
  read -p 'If you would like to see more information on property (including past and future bookings), please enter the propertyid [N to cancel] '
  echo $option
  if [[ $option != "N" ]]; then
    psql -h 127.0.0.1 -d postgres -U postgres -c "\encoding UTF8;" -c "SELECT property.*, startdate, enddate FROM \"OnlineTravel\".property natural join \"OnlineTravel\".booking_info WHERE propertyid LIKE '%$option%';"
  fi

}

function boolean() {
  case $1 in
    TRUE) echo true ;;
    FALSE) echo false ;;
    *) echo "Err: Unknown boolean value \"$1\"" 1>&2; exit 1 ;;
   esac
}

#List upcoming available properties for your branch
ACT_4()
{
  option=''
  current_date=$(date +%F)
  read -p "Specify Branch Country: " country_input
  export PGPASSWORD='XXXXXXXX' #your postgres password
  psql -h 127.0.0.1 -d postgres -U postgres -c "SELECT property.propertyid, booking_info.bookingid, booking_info.bookerid, property.name, property.maxguests, property.pernightfee, property.city, startdate, enddate FROM \"OnlineTravel\".property natural join \"OnlineTravel\".booking_info WHERE country LIKE '%$country_input%' and (enddate < '$current_date' or startdate > '$current_date') ORDER BY enddate ASC;"
  read -p 'If you would like to see more information on property (including past and future bookings), please enter the propertyid [N to cancel] ' option
  echo $option
  if [[ $option != "N" ]]; then
    psql -h 127.0.0.1 -d postgres -U postgres -c "\encoding UTF8;" -c "SELECT property.*, startdate, enddate FROM \"OnlineTravel\".property natural join \"OnlineTravel\".booking_info WHERE propertyid LIKE '%$option%';"
  fi
}
#Employee Login
ACT_2()
{
  employeeid=''
  read -p "Employee Email Address (example@example.com): " employee_email_input
  export PGPASSWORD='XXXXXXXX' #your postgres password
  employeeid=`psql -X -h 127.0.0.1 -d postgres -U postgres -t -c "\encoding UTF8;" -c "SELECT employee.employeeid FROM \"OnlineTravel\".employee WHERE email LIKE '%$employee_email_input%'"`
  output='f'
  option=''
  echo "Found employeeid: $employeeid"
  if [[ $employeeid != '' ]]; then
    echo "Welcome $employee_email_input"
    echo "Here are your options: "
    LOC=2
    while [ true ]; do
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
  else
    echo "The email specified does not exist in the system, please try again"
  fi
}

LOC_ACTS[0]=""
LOC_TXT[1]="Welcome to Online Travel"
LOC_ACTS[1]="0,1,2"
LOC_ACTS[2]="3,4"

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