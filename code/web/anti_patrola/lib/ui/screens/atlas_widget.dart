// import 'package:flutter/material.dart';
// import 'package:atlas/atlas.dart';
// import 'package:google_atlas/google_atlas.dart';

// class AtlasScreenWidget extends StatefulWidget {
//   @override
//   _AtlasScreenWidgetState createState() => _AtlasScreenWidgetState();
// }

// class _AtlasScreenWidgetState extends State<AtlasScreenWidget> {
//   AtlasController _controller;
//   final CameraPosition _initialCameraPosition = CameraPosition(
//     target: LatLng(
//       latitude: 37.42796133580664,
//       longitude: -122.085749655962,
//     ),
//     zoom: 12,
//   );
//   final Set<Marker> _markers = Set<Marker>.from(
//     [
//       Marker(
//         id: 'marker-1',
//         position: LatLng(
//           latitude: 41.878113,
//           longitude: -87.629799,
//         ),
//         onTap: () {
//           print('tapped marker-1');
//         },
//       ),
//     ],
//   );

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Atlas(
//       initialCameraPosition: _initialCameraPosition,
//       markers: _markers,
//       showMyLocation: true,
//       showMyLocationButton: false,
//       mapType: MapType.night,
//       onTap: (LatLng position) {
//         print(
//           'map tapped: ${position.latitude}, ${position.longitude}',
//         );
//       },
//       onLongPress: (LatLng position) {
//         print('long press ${position.latitude}, ${position.longitude}');
//         setState(() {
//           _markers.add(
//             Marker(
//               id: 'marker-4',
//               position: position,
//               onTap: () {
//                 print('tapped marker-4');
//               },
//             ),
//           );
//         });
//       },
//       onMapCreated: (controller) {
//         _controller = controller;
//       },
//       onCameraPositionChanged: (cameraPosition) {
//         print('Camera position changed!');
//       },
//     );
//   }
// }

// /*

//     @required CameraPosition initialCameraPosition,
//     @required Set<Marker> markers,
//     @required Set<Circle> circles,
//     @required Set<Polygon> polygons,
//     @required Set<Polyline> polylines,
//     @required bool showMyLocation,
//     @required bool showMyLocationButton,
//     @required MapType mapType,
//     @required bool showTraffic,

// */
