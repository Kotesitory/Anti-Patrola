import 'dart:async';
import 'package:anti_patrola/logic/services/bloc/map_screen_events.dart';
import 'package:anti_patrola/logic/services/bloc/map_screen_states.dart';
import 'package:anti_patrola/logic/services/events/event_bus_events.dart';
import 'package:anti_patrola/logic/services/geolocation_service.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class MapScreenBloc extends Bloc<MapScreenEvent, MapScreenState> {
  EventBus _eventBus = GetIt.instance<EventBus>();
  GeolocationService _geolocationService = GetIt.instance<GeolocationService>();
  Timer _timer;
  int _sendLocationIntervalInSeconds = 5;

  MapScreenBloc() : super(InitialState()) {
    _eventBus
        .on<UserLocationEvent>()
        .listen((UserLocationEvent userLocationEvent) {
      this.add(NewUserLocationEvent(userLocationEvent.locationData));
    });

    _timer = Timer.periodic(Duration(seconds: _sendLocationIntervalInSeconds),
        (timer) {
      _sendUserLocation();
    });
  }

  @override
  Stream<MapScreenState> mapEventToState(MapScreenEvent event) async* {
    if (event is InitialEvent) {
      yield InitialState(); // Clears UI
    } else if (event is NewUserLocationEvent) {
      yield UpdateUserLocationState(event.locationData);
    }
  }

  void _sendUserLocation() {
    // TODO: Implement sending the user location
    // When the backend receives the user location, calculate the distance and display the near patrols
  }
}
