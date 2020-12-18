import 'dart:math';

import 'package:anti_patrola/logic/bloc/map_screen_bloc.dart';
import 'package:anti_patrola/logic/bloc/map_screen_states.dart';
import 'package:anti_patrola/logic/services/geolocation_service.dart';
import 'package:anti_patrola/resources/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
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
  GeolocationService _geolocationService = GetIt.instance<GeolocationService>();
  Symbol _userSymbol;
  LatLng _initialUserLocation;

  @override
  void initState() {
    super.initState();
    _geolocationService.startMonitoringLocation();
    var locationData = _geolocationService.CurrentLocationData;
    _initialUserLocation =
        LatLng(locationData.latitude, locationData.longitude);
  }

  void _loadImagesFromAsset() async {
    _addImageFromAsset(AppImages.PoliceCarSymbol);
    _addImageFromAsset(AppImages.UserSymbol);
  }

  /// Adds an asset image to the currently displayed style
  Future<void> _addImageFromAsset(String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return _controller.addImage(assetName, list);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MapScreenBloc, MapScreenState>(
        listener: (listenerContext, state) {
          if (state is UpdateUserLocationState) {
            debugPrint('Updated location');
            LatLng latLng = LatLng(
                state.locationData.latitude, state.locationData.longitude);
            setState(() {
              _addUserSymbol(latLng);
            });
          }
        },
        child: Stack(
          children: [
            MapboxMap(
              accessToken: RemoteConfigModel.MapBoxTokenPublic,
              myLocationEnabled: true,
              myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
              myLocationRenderMode: MyLocationRenderMode.GPS,
              styleString: MapboxStyles.MAPBOX_STREETS,
              initialCameraPosition: CameraPosition(
                  target: _initialUserLocation, zoom: RemoteConfigModel.mapZoomValue),
              onMapCreated: (cntrl) {
                _controller = cntrl;
              },
              onStyleLoadedCallback: () {
                _loadImagesFromAsset();
              },
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: RaisedButton(
                  onPressed: () {
                    // TODO: Implement reporting the patrol
                  },
                  child: Text('Report Patrol'),
                ),
              ),
            ),
          ],
        ));
  }

  void _addPoliceSymbol(LatLng latLng) {
    _controller.addSymbol(SymbolOptions(
      geometry: latLng,
      iconImage: AppImages.PoliceCarSymbol,
      iconSize: 0.5,
    ));
  }

  void _addUserSymbol(LatLng latLng) async {
    await _controller.removeSymbol(_userSymbol);
    _controller
        .addSymbol(SymbolOptions(
          geometry: latLng,
          iconImage: AppImages.UserSymbol,
          iconSize: 0.5,
        ))
        .then((newSymbol) => _userSymbol = newSymbol);
  }
}
