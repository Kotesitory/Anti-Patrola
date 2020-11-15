import sys
import xmltodict
import json

'''
	Parses OSM-XML format into a JSON for further processing.
	Reads a OSM-XML string from standard input and converts it
	into a JSON format which is the output of this script.
'''

xml_data = sys.stdin.read()
xml_data = xml_data.encode('utf-8', 'replace').decode()
data_dict = xmltodict.parse(xml_data)
json_data = json.dumps(data_dict)
print(json_data)
