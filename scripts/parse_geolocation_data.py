import sys
import json

'''
	Gets geolocation of current used. Used for reporting the presence
	of a police patrol by a user.
'''

json_data = sys.stdin.read()
data_dict = json.loads(json_data)
patrol = dict()
location = data_dict['loc'].split(',')
patrol['latitude'] = location[0]
patrol['longitude'] = location[1]
json_data = json.dumps(patrol)
print(json_data)