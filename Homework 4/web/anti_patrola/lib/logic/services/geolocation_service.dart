import 'package:anti_patrola/logic/events/event_bus_events.dart';
import 'package:event_bus/event_bus.dart';
import 'package:get_it/get_it.dart';
import 'package:location/location.dart';

class GeolocationService {
  EventBus _eventBus = GetIt.instance<EventBus>();
  Location location = new Location();
  bool _serviceEnabled = false;
  LocationData _locationData;
  bool _hasStartedMonitoring = false;

  GeolocationService() {
    location.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation != null) {
        _eventBus.fire(UserLocationEvent(currentLocation));
      }

      _initializeAsync();

      print(
          'Lat: ${currentLocation.latitude} ::: Lon: ${currentLocation.longitude}');
    });
  }

  _initializeAsync() async {
    await startMonitoringLocation();
  }

  bool get hasStartedMonitoringForLocation {
    return _hasStartedMonitoring;
  }

  LocationData get currentLocationData {
    if (_locationData != null) {
      print("::: LOCATION");
      return _locationData;
    } 

    return null;
  }

  Future<void> startMonitoringLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        throw Exception('Error retriving the location!');
      }
    }

    PermissionStatus _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        throw Exception('Permission is not granted!');
      }
    }

    _locationData = await location.getLocation();
    _hasStartedMonitoring = true;
  }
}
