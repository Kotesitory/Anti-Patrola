#!/bin/bash

if [ ! -d "./data" ]; then
	mkdir ./data
fi

curl -s https://lz4.overpass-api.de/api/map?bbox=20.4456000,40.8471000,23.0411000,42.3809000