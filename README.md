# Anti-Patrola

The site can be found [here](https://antipatrola.ml). However, the site might be down due to free-hosting resuource limits. 

## Introduction

Anti-Patrola is a web and mobile application that allows users to report and view road-side police patrols in
their area. This is a community-driven tool that helps users avoid getting fined for reckless driving or breaking the traffic rules. 

The initial inspiration came from the very popular Facebook and Viber groups that fundamentally do the same thing - inform about road-side police patrol. 
However by creating this app, instead of users having to type out messages, their geolocation is recorded 
and broadcast at a push of a button.
By simplifying and digitizing the process, Anti-Patrola provides real-time solution for this problem with nearly-zero user's effort.

More details about the idea and the product description can be found at: [docs/SRS.pdf](docs/SRS.pdf).

## Usage

At the moment the project is in its very early stages. So the only parts that are implemented are the pipelines for
gathering open data from [Open Street Map](https://www.openstreetmap.org/) and user geolocation. The pipelines are
implemented as modular bash and python scripts which request, download, parse and save data in a desired format.

To run the scripts you must have a python 3.X interpreter installed as well as the python modules mentioned in the <requirements>.
The `pipeline.sh` bash script is a pipeline that downloads map data for Macedonia from Open Street Map and further processes it.
In the end the output is saved in the `data/roads_data.json` file. The pipeline extracts data for highways in Macedonia which might be
useful down the line. To run:
```
bash pipeline.sh
```

The output is a JSON in the following format:

```
[
	...
	"road": 
	[
		{
			"latitude": "41.9915022", 
			"longitude": "21.5351179"
		},
		{
			"latitude": "41.9925844", 
			"longitude": "21.5346562"
		},
		{
			"latitude": "41.9915022", 
			"longitude": "21.5351179"
		}
	],
	"road"
	[
		{
			"latitude": "41.9915022", 
			"longitude": "21.5351179"
		},
		{
			"latitude": "41.9915022", 
			"longitude": "21.5351179"
		}
	],
	...
]
```
For getting user geolocation the `user_geolocation_pipe.sh` script can be ran and the output is appended to the `data/patrol_locations.json` file.
To run:
```
bash user_geolocation_pipe.sh
```
 The output is a JSON in the following format, however it is just appended to the file so the file is not a valid JSON:
 ```
{
	"latitude": "41.9915022", 
	"longitude": "21.5351179"
}
 ```

The scripts used in the pipelines can be found in the `scripts` directory.

## Software Requirements Specification

The SRS for this project is contained in [docs/SRS.pdf](docs/SRS.pdf).


| Team member       	| Index     | 
| ----------------- 	| --------- |
| Stefan Kotevski 		| 171101    |
| [Nikola Velkovski](https://github.com/Nikolak47) 	| 171070    |
