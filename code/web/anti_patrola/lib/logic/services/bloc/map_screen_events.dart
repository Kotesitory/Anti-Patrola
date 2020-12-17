import 'package:equatable/equatable.dart';
import 'package:location/location.dart';

abstract class MapScreenEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialEvent extends MapScreenEvent {}

class NewUserLocationEvent extends MapScreenEvent {
  final LocationData locationData;
  NewUserLocationEvent(this.locationData);

  @override
  List<Object> get props => [locationData];
}
