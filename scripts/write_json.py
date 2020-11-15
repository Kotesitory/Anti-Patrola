import sys
import json

'''
	Script used for writing an entities JSON to a file 
	representing the database. For now it only writes the JSON
	to a file as is, but further processing can be done in the future.
'''

json_data = sys.stdin.read()

with open('data/roads_data.json', 'w') as file: 
    file.write(json_data)

print(json_data)