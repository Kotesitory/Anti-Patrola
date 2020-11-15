import sys
import json

'''
	Gets a JSON input of "way" nodes and their referenced "node" nodes
	and converts them into a format to be saved to a database.
'''

json_data = sys.stdin.read()
data_dict = json.loads(json_data)

# Creating a node index for resolving the node references
nodes = dict()
for node in data_dict['nodes']:
	node_id = node['@id']
	nodes[node_id] = node

highways = data_dict['highways']
roads = []
for road in highways:
	road_obj = dict()
	nodes_list = []

	# Resolving node references for each road
	for nd in road['nd']:
		node_id = nd['@ref']
		node = nodes[node_id]
		node_obj = dict()
		node_obj['latitude'] = node['@lat']
		node_obj['longitude'] = node['@lon']
		nodes_list.append(node_obj)

	road_obj['road'] = nodes_list
	roads.append(road_obj)

roads_json = json.dumps(roads)
print(roads_json)