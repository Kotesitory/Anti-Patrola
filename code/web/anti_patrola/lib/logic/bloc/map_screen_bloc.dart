import 'dart:async';
import 'package:anti_patrola/logic/events/event_bus_events.dart';
import 'package:anti_patrola/logic/services/geolocation_service.dart';
import 'package:anti_patrola/logic/services/patrol_service.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'map_screen_events.dart';
import 'map_screen_states.dart';

class MapScreenBloc extends Bloc<MapScreenEvent, MapScreenState> {
  EventBus _eventBus = GetIt.instance<EventBus>();
  GeolocationService _geolocationService = GetIt.instance<GeolocationService>();
  Timer _timer; // TODO: Dispose this on close
  int _sendLocationIntervalInSeconds = 5;
  PatrolService _patrolService = GetIt.instance<PatrolService>();

  MapScreenBloc() : super(InitialState()) {
    _eventBus
        .on<UserLocationEvent>()
        .listen((UserLocationEvent userLocationEvent) {
      this.add(NewUserLocationEvent(userLocationEvent.locationData));
    });

    _timer = Timer.periodic(Duration(seconds: _sendLocationIntervalInSeconds),
        (timer) {
      print('TimerStarted');
      if(!_geolocationService.hasStartedMonitoringForLocation)
        return;

      _sendUserLocation();
    });
  }

  @override
  Stream<MapScreenState> mapEventToState(MapScreenEvent event) async* {
    if (event is InitialEvent) {
      yield InitialState(); // Clears UI
    } else if (event is NewUserLocationEvent) {
      yield UpdateUserLocationState(event.locationData);
    } else if (event is NewPatrolsArrivedEvent) {
      if (event.models.isNotEmpty) yield NewPatrolsArrivedState(event.models);
    }
  }

  void _sendUserLocation() {
    LocationData location = _geolocationService.currentLocationData;
    if (location == null) return;
    LatLng latLng = LatLng(location.latitude, location.longitude);
    _patrolService.getPatrolsNearUser(latLng).then((patrols) {
      this.add(NewPatrolsArrivedEvent(patrols));
    }).catchError((e) => print("ERROR WHILE GETING PATROLS: ${e.toString()}"));
  }
}
