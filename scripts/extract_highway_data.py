import sys
import json

'''
	Gets all the "way" nodes from a JSON format for further filtering.
	Reads in JSON string from standard input and outputs a JSON
	containing only the way nodes from the input JSON.
'''

json_data = sys.stdin.read()
data_dict = json.loads(json_data)
way_nodes = data_dict['osm']['way']
node_nodes = data_dict['osm']['node']
highways = []
node_ids = set()
for way in way_nodes:
	is_highway = False
	if 'tag' in way.keys():
		for tag in way['tag']:
			if isinstance(tag, dict) and tag['@k'] == 'highway' and tag['@v'] == 'motorway':
				is_highway = True
				break

		# Only keeping motorway roads and their referenced nodes
		if is_highway:
			highways.append(way)
			for node in  way['nd']:
				node_ids.add(node['@ref'])

# Extracting all nodes that are in a relation with the highways
nodes = [node for node in node_nodes if node['@id'] in node_ids]
output_json = dict()
output_json['nodes'] = nodes
output_json['highways'] = highways
ways_json = json.dumps(output_json)
print(ways_json)