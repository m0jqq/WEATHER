#!/bin/bash

# wx.sh v1.0 02 Dec 2023
# Script designed to be accessed by linbpq packet radio node to deliver a set location weather report
# To use this you will need to obtain your own openweathermap api_key
# from https://openweathermap.org
#
# for integration into your own BPQ node, see https://wiki.oarc.uk/packet:linbpq_custom_applications
# ypu will also need to instal jq (sudo apt install jq -y)
#
# Robin M0JQQ - GB7CNR SYSOP

# set up request
api_key="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
url=https://api.openweathermap.org/data/3.0/onecall?
lat=55.08
lon=-1.61
exclude=minutely,hourly,daily
units=metric

# request
weather=$(curl -sX GET --header "Accept: */*" "$url&lat=$lat&lon=$lon&exclude=$exclude&units=$units&appid=$api_key")

https://wiki.oarc.uk/packet:linbpq_custom_applications# extract the data
temperature=$(echo $weather |jq -r ."current|.temp")
feels_like=$(echo $weather |jq -r ."current|.feels_like")
wind_speed=$(echo $weather |jq -r ."current|.wind_speed")
wdeg=$(echo $weather |jq -r ."current|.wind_deg")

# convert temperatures to integer
temperature=${temperature%.*}
feels_like=${feels_like%.*}

# convert wind direction to cardinal
        if [[ "$wdeg" -gt -1 && "$wdeg" -lt 22 ]]
                then wdir="a Northerly"
        elif [[ "$wdeg" -gt 22 && "$wdeg" -lt 68 ]]
                then wdir="a North-Easterly"
        elif [[ "$wdeg" -gt 67 && "$wdeg" -lt 112 ]]
                then wdir="an Easterly"
        elif [[ "$wdeg" -gt 111 && "$wdeg" -lt 157 ]]
                then wdir="a South-Easterly"
        elif [[ "$wdeg" -gt 156 && "$wdeg" -lt 202 ]]
                then wdir="a Southerly"
        elif [[ "$wdeg" -gt 201 && "$wdeg" -lt 247 ]]
                then wdir="a South-Westerly"
        elif [[ "$wdeg" -gt 246 && "$wdeg" -lt 292 ]]
                then wdir="a Westerly"
        elif [[ "$wdeg" -gt 291 && "$wdeg" -lt 337 ]]
                then wdir="a North-Westerly"
        elif [[ "$wdeg" -gt 336 && "$wdeg" -lt 361 ]]
                then wdir="a Northerly"
        fi

# ouput
echo
echo
echo "  TODAY'S WEATHER"
echo
echo "  The weather in Cramlington, GB is currently ${temperature} degrees Centigrade."
echo "  This feels like ${feels_like} degrees."
echo "  The wind is ${wind_speed} kmh from ${wdir} direction."
echo

echo "   Thanks for checking :) - [ver 1.1]"
echo
