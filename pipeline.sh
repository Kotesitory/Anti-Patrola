#!/bin/bash

bash scripts/download_xml_data.sh | 
	py scripts/xml_to_json.py | 
	py scripts/extract_highway_data.py | 
	py scripts/convert_to_db_entity.py |
	py scripts/write_json.py