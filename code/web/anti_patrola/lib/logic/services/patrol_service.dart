import 'package:anti_patrola/data/dtos/patrol_container_dto.dart';
import 'package:anti_patrola/data/dtos/patrol_dto.dart';
import 'package:anti_patrola/data/models/patrol_model.dart';
import 'package:anti_patrola/data/network.dart';
import 'package:anti_patrola/logic/services/auth_service.dart';
import 'package:get_it/get_it.dart';

class PatrolService{
  Network _network = GetIt.instance<Network>();
  AuthService _authService = GetIt.instance<AuthService>();

  // TODO: Code contract
  Future<List<PatrolModel>> getPatrols() async {
    String authToken = await _authService.readToken();
    PatrolContainerDto dto = await _network.getActivePatrols(authToken);
    return dto.patrols.map((p) {
      PatrolModel(id: p.id, confidence: p.confidence, lat: p.lat, lon: p.lon);
    }).toList();
  }

  // TODO: Code contract
  Future<bool> reportNewPatrol(double lat, double lon) async {
    String authToken = await _authService.readToken();
    return await _network.reportPatrol(lat, lon, authToken);
  } 

  // TODO: Code contract
  Future<PatrolModel> confirmPatrol(String patrolId, double userLat, double userLon, bool confirmation) async {
    String authToken = await _authService.readToken();
    PatrolDto dto = await _network.confirmPatrol(patrolId, userLat, userLon, confirmation, authToken);
    return PatrolModel(id: dto.id, confidence: dto.confidence, lat: dto.lat, lon: dto.lon);
  } 
}