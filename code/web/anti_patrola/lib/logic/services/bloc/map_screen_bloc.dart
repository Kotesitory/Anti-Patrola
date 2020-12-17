import 'package:anti_patrola/logic/services/bloc/map_screen_events.dart';
import 'package:anti_patrola/logic/services/bloc/map_screen_states.dart';
import 'package:anti_patrola/logic/services/events/event_bus_events.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class MapScreenBloc extends Bloc<MapScreenEvent, MapScreenState> {
  EventBus _eventBus = GetIt.instance<EventBus>();
  MapScreenBloc() : super(InitialState()) {
    _eventBus
        .on<UserLocationEvent>()
        .listen((UserLocationEvent userLocationEvent) {
      this.add(NewUserLocationEvent(userLocationEvent.locationData));
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
}
