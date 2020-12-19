import 'dart:math';

import 'package:anti_patrola/logic/bloc/map_screen_bloc.dart';
import 'package:anti_patrola/logic/bloc/map_screen_states.dart';
import 'package:anti_patrola/logic/services/geolocation_service.dart';
import 'package:anti_patrola/logic/services/patrol_service.dart';
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
  LatLng _skopjeLatLng = LatLng(41.9981, 21.4254);

  @override
  void initState() {
    super.initState();
    var locationData = _geolocationService.CurrentLocationData;
    (locationData != null)
        ? _initialUserLocation =
            LatLng(locationData.latitude, locationData.longitude)
        : _initialUserLocation = _skopjeLatLng;
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
          } else if (state is NewPatrolsArrivedState) {

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
                  target: _skopjeLatLng, zoom: RemoteConfigModel.mapZoomValue),
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
                padding: const EdgeInsets.all(50.0),
                child: RaisedButton(
                  color: Colors.red[300],
                  onPressed: () {
                    var currentLocationData =
                        GetIt.instance<GeolocationService>()
                            .CurrentLocationData;
                    if (currentLocationData == null) {
                      // TODO: Log this in sentry
                      debugPrint('Current GeoLocation Data is null');
                      throw new ArgumentError('Current locationdata is null');
                    }
                    GetIt.instance<PatrolService>().reportNewPatrol(LatLng(
                        currentLocationData.latitude,
                        currentLocationData.longitude));
                  },
                  child: Text(
                    'Report Patrol',
                    style: TextStyle(fontSize: 22),
                  ),
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
    if (_userSymbol != null) await _controller.removeSymbol(_userSymbol);

    print("Should add: " + latLng.latitude.toString() + " " + latLng.longitude.toString());
    if (_controller != null) {
      _controller
          .addSymbol(SymbolOptions(
            geometry: latLng,
            iconImage: AppImages.UserSymbol,
            iconSize: 0.5,
          ))
          .then((newSymbol) => _userSymbol = newSymbol);
    } else
      print('Controller is NULL');
  }
}
