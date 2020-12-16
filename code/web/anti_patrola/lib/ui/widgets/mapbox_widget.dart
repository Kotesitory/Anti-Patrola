import 'dart:math';

import 'package:anti_patrola/logic/services/geolocation_service.dart';
import 'package:anti_patrola/resources/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'dart:async';
import 'dart:typed_data';
import '../../remote_config.dart';

class MapBoxScreenWidget extends StatefulWidget {
  @override
  _MapBoxScreenWidgetState createState() => _MapBoxScreenWidgetState();
}

class _MapBoxScreenWidgetState extends State<MapBoxScreenWidget> {
  MapboxMapController _controller;
  GeolocationService geolocationService =
      GeolocationService(); // Start monitoring for geolocation

  LatLng _skopjeLatLng = LatLng(41.9981, 21.4254);
  // TODO: Remove this after testing
  bool _isFirstTimeClicked = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 10)).then((value) {
      print('Continue!');
    });
  }

  void _loadImagesFromAsset() async {
    _addImageFromAsset('police_car_symbol', AppImages.PoliceCarSymbol);
  }

  /// Adds an asset image to the currently displayed style
  Future<void> _addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return _controller.addImage(name, list);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MapboxMap(
          accessToken: RemoteConfigModel.MapBoxTokenPublic,
          myLocationEnabled: true,
          myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
          myLocationRenderMode: MyLocationRenderMode.GPS,
          styleString: MapboxStyles.MAPBOX_STREETS,
          initialCameraPosition: CameraPosition(
              target: _skopjeLatLng, zoom: RemoteConfigModel.mapZoomValue),
          onMapCreated: (cntrl) {
            _controller = cntrl;
          },
          onStyleLoadedCallback: () {
            _loadImagesFromAsset();
          },
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton(
              onPressed: () {
                _controller.addSymbol(SymbolOptions(
                  geometry: LatLng(
                    (_isFirstTimeClicked)
                        ? _skopjeLatLng.latitude
                        : _skopjeLatLng.latitude +
                            ((Random().nextDouble() > 0.5 ? 0.0001 : -0.009) +
                                Random().nextDouble() * 0.008),
                    (_isFirstTimeClicked)
                        ? _skopjeLatLng.longitude
                        : _skopjeLatLng.longitude +
                            ((Random().nextDouble() > 0.5 ? 0.0001 : -0.009) +
                                Random().nextDouble() * 0.00008),
                  ),
                  iconImage: 'police_car_symbol',
                  iconSize: 0.5,
                ));

                _isFirstTimeClicked = false;
              },
              child: Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.orange,
                  child: Text('Test adding police symbols')),
            ),
          ),
        ),
      ],
    );
  }
}
