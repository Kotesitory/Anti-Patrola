#!/bin/bash

# Gets geolocation data
if [ ! -d "./data" ]; then
	mkdir ./data
fi

curl -s https://ipinfo.io | 
py scripts/parse_geolocation_data.py >> ./data/patrol_locations.json