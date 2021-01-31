# Homework 4

The final and refactored vesion of tha app can be found in this folder

The directory ```backend``` contains the code for the backend microservice. This is a node.js microservice that handles access to the database, validation for the reported patrols, patrol confirmations, and other calculations such as neerby patrols and so on.

In the ```web``` directory is the code responsible for the frontend of our application. It was developed in Flutter since the end goal is planned to be released on web as well as IOS and Android. Building this in Flutter allows us to build a cross-platform app that will soon be ported to the mentioned platforms. This code is responsible for user login (we use Google login as a service) and rendering and displying the map as well as patrols to the user.

The current build of the application can be seen [here](https://antipatrola.ml)