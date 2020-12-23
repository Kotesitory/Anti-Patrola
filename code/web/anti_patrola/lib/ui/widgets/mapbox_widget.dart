import 'package:anti_patrola/data/models/patrol_model.dart';
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
  static const int PATROL_DISTANCE_WARDNING_THRESHOLD_IN_METERS = 20;
  MapboxMapController _controller;
  GeolocationService _geolocationService = GetIt.instance<GeolocationService>();
  Symbol _userSymbol;
  LatLng _initialUserLocation;
  LatLng _skopjeLatLng = LatLng(41.9981, 21.4254);
  List<PatrolModel> _warnedPatrols = [];
  List<PatrolModel> _displayedPatrols = [];
  Size _deviceSize;
  Timer _timerForCheckingPatrolConfidence;

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
    _addImageFromAsset('police_car_symbol', AppImages.PoliceCarSymbol);
    _addImageFromAsset('user_symbol', AppImages.UserSymbol);
  }

  /// Adds an asset image to the currently displayed style
  Future<void> _addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return _controller.addImage(name, list);
  }

  @override
  Widget build(BuildContext context) {
    _deviceSize = MediaQuery.of(context).size;
    return BlocListener<MapScreenBloc, MapScreenState>(
        listener: (listenerContext, state) {
          if (state is UpdateUserLocationState) {
            debugPrint('Updated location');
            LatLng latLng = LatLng(
                state.locationData.latitude, state.locationData.longitude);

            _addUserSymbol(latLng);
          } else if (state is NewPatrolsArrivedState) {
            List<PatrolModel> newPatrols = state.models;
            for (PatrolModel patrol in newPatrols) {
              if (!_displayedPatrols.contains(patrol)) {
                _addPolicePatrol(patrol);
                if (patrol.distance <=
                    PATROL_DISTANCE_WARDNING_THRESHOLD_IN_METERS) {
                  if (!_warnedPatrols.contains(patrol)) {
                    _warnAboutPatrol(patrol);
                  }
                }
              }
            }
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
                padding: EdgeInsets.all(_deviceSize.width * 0.028),
                child: RaisedButton(
                  elevation: 12,
                  color: Colors.red[800],
                  onPressed: () {
                    _reportPatrol();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(17.0),
                    child: Text(
                      'Report Patrol',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  void _warnAboutPatrol(PatrolModel patrol) {
    setState(() {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.fromLTRB(50, 0, 50, _deviceSize.height * 0.94),
          backgroundColor: Colors.red[700],
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.warning,
                color: Colors.white,
                size: 26,
              ),
              SizedBox(
                width: 20,
              ),
              Center(
                child: Text(
                  'There is a police patrol near you! Be aware!',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 26),
                ),
              ),
            ],
          ),
        ),
      );
    });

    _warnedPatrols.add(patrol);
    Timer.periodic(Duration(seconds: 30), (timer) {
      timer.cancel();
      _verifyPatrol(patrol);
    });
  }

  void _verifyPatrol(PatrolModel patrol) {
    var currentLocation = _geolocationService.CurrentLocationData;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Did you see a police patrol in the last 30s ?'),
            actions: [
              RaisedButton(
                onPressed: () {
                  GetIt.instance<PatrolService>().confirmPatrol(
                      patrol.id,
                      LatLng(
                          currentLocation.latitude, currentLocation.longitude),
                      true);
                  Navigator.pop(context);
                },
                color: Colors.greenAccent,
                child: Text('YES'),
              ),
              RaisedButton(
                onPressed: () {
                  GetIt.instance<PatrolService>().confirmPatrol(
                      patrol.id,
                      LatLng(
                          currentLocation.latitude, currentLocation.longitude),
                      false);
                  Navigator.pop(context);
                },
                color: Colors.redAccent,
                child: Text('NO'),
              ),
            ],
          );
        });
  }

  void _reportPatrol() {
    var currentLocationData =
        GetIt.instance<GeolocationService>().CurrentLocationData;
    if (currentLocationData == null) {
      // TODO: Log this in sentry
      debugPrint('Current GeoLocation Data is null');
      throw new ArgumentError('Current locationdata is null');
    }
    GetIt.instance<PatrolService>().reportNewPatrol(
        LatLng(currentLocationData.latitude, currentLocationData.longitude));
  }

  void _addPolicePatrol(PatrolModel patrol) {
    _controller
        .addSymbol(SymbolOptions(
      geometry: LatLng(patrol.lat, patrol.lon),
      iconImage: AppImages.PoliceCarSymbol,
      iconSize: 0.5,
    ))
        .then((value) {
      _displayedPatrols.add(patrol);
    });
  }

  void _addUserSymbol(LatLng latLng) async {
    if (_userSymbol != null) await _controller.removeSymbol(_userSymbol);
    _controller
        .addSymbol(new SymbolOptions(
      geometry: latLng,
      iconImage: 'user_symbol',
      iconSize: 0.5,
    ))
        .then((newSymbol) {
      print("New Symbol: " + newSymbol.id);
      _userSymbol = newSymbol;
      _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: latLng, zoom: RemoteConfigModel.mapZoomValue)));
    });
  }
}
