import 'package:anti_patrola/data/models/patrol_model.dart';
import 'package:equatable/equatable.dart';
import 'package:location/location.dart';

abstract class MapScreenState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialState extends MapScreenState {}

class UpdateUserLocationState extends MapScreenState {
  final LocationData locationData;
  UpdateUserLocationState(this.locationData);

  @override
  List<Object> get props => [locationData];
}

class NewPatrolsArrivedState extends MapScreenState {
  List<PatrolModel> models;

  NewPatrolsArrivedState(this.models);

  @override
  List<Object> get props => [models];
}
