import 'package:anti_patrola/data/dtos/patrol_container_dto.dart';
import 'package:anti_patrola/data/dtos/patrol_dto.dart';
import 'package:anti_patrola/data/models/patrol_model.dart';
import 'package:anti_patrola/data/network.dart';
import 'package:anti_patrola/logic/services/auth_service.dart';
import 'package:get_it/get_it.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class PatrolService{
  Network _network = GetIt.instance<Network>();
  AuthService _authService = GetIt.instance<AuthService>();
  static const double _RADIUS_FOR_PATROLS = 500.0;

  /// Returns a [List<PatrolModel>] of patrols info. 
  /// Throws [UnauthorizedAccessException] if token is invalid/expired/missing
  /// Throws [NetworkException] if something goes else wrong
  Future<List<PatrolModel>> getPatrols() async {
    String authToken = await _authService.readToken();
    PatrolContainerDto dto = await _network.getActivePatrols(authToken);
    if (dto == null)
      return [];

    return dto.patrols.map((p) {
      return PatrolModel(id: p.id, confidence: p.confidence, lat: p.lat, lon: p.lon, distance: p.distance);
    }).toList();
  }

  /// Returns a [List<PatrolModel>] of patrols info that are in the user radius
  /// Throws [UnauthorizedAccessException] if token is invalid/expired/missing
  /// Throws [NetworkException] if something goes else wrong
  Future<List<PatrolModel>> getPatrolsNearUser(LatLng userLocation) async {
    String authToken = await _authService.readToken();
    PatrolContainerDto dto = await _network.getActivePatrolsInRadius(authToken, userLocation.latitude, userLocation.longitude, _RADIUS_FOR_PATROLS);
    if(dto == null){
      return [];
    }

    return dto.patrols.map((p) {
      return PatrolModel(id: p.id, confidence: p.confidence, lat: p.lat, lon: p.lon, distance: p.distance);
    }).toList();
  }

  /// Reports a patrol at the [lat], [lon] coordinates, returns true if report went smoothly
  /// Throws [UnauthorizedAccessException] if token is invalid/expired/missing
  /// Throws [TooManyRequestsException] if you try to report two or more patrols
  /// in a quick succession
  /// Throws [InvalidRequestException] if not all parameters are provided in the request
  /// Throws [NetworkException] if something goes else wrong
  Future<bool> reportNewPatrol(LatLng userLocation) async {
    String authToken = await _authService.readToken();
    return await _network.reportPatrol(userLocation.latitude, userLocation.longitude, authToken);
  } 

  /// Reportspatrol with id [patrolId] at the [userLat], [userLon] coordinates
  /// Returns a [PatrolDto] with the new confidence level of the patrol or NULL if
  /// something goes wrong
  /// The [confirmation] paramater refers to whether the user is  confirming 
  /// or denying the patrols existence
  /// Throws [UnauthorizedAccessException] if token is invalid/expired/missing
  /// Throws [ForbiddenActionException] if the patrols is owned by this user, 
  /// the user has already confirmed/denied this patrol, user is not in range of the patrol,
  /// an invalid patrol id is passed or the patrol is too old.
  /// Throws [InvalidRequestException] if not all parameters are provided in the request
  /// Throws [NetworkException] if something goes else wrong
  Future<PatrolModel> confirmPatrol(String patrolId, LatLng userLocation, bool confirmation) async {
    String authToken = await _authService.readToken();
    PatrolDto dto = await _network.confirmPatrol(patrolId, userLocation.latitude, userLocation.longitude, confirmation, authToken);
    if(dto == null){
      return null;
    }
    
    return PatrolModel(id: dto.id, confidence: dto.confidence, lat: dto.lat, lon: dto.lon, distance: null);
  } 
}