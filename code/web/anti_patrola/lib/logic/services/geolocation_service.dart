import 'package:location/location.dart';

class GeolocationService {
  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  GeolocationService() {
    location.onLocationChanged.listen((LocationData currentLocation) {
      // Call blocProvider and send the location
      print(
          'Lat: ${currentLocation.latitude} ::: Lon: ${currentLocation.longitude}');
    });

    _startMonitoringLocation();
  }

  void _startMonitoringLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        throw Exception('Error retriving the location!');
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        throw Exception('Permission is not granted!');
      }
    }

    _locationData = await location.getLocation();
  }
}
