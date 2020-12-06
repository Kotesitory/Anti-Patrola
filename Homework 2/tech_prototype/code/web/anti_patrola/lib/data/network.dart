import 'package:anti_patrola/data/dtos/patrol_container_dto.dart';
import 'package:anti_patrola/data/dtos/patrol_dto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class Network{
  static const String _BASE_URL = 'http://localhost:5000/';
  static const int _CONN_TIMEOUT_MILISECONDS = 15000;


  Dio _prepareDioWithAuthTokenHeader({@required String authToken}) {
    Dio dio = Dio(BaseOptions(connectTimeout: _CONN_TIMEOUT_MILISECONDS, followRedirects: true));
    if (authToken != null && authToken.isNotEmpty) {
      dio.options.headers['authorization'] = 'Bearer $authToken';
    }

    return dio;
  }

  String _formatUrlForPatrolReq() {
    return _BASE_URL + 'api/patrols';
  }

  String _formatUrlForPatrolConfirm() {
    return _BASE_URL + 'api/patrols/confirm';
  }

  /// Throws 
  Future<PatrolContainerDto> getActivePatrols(String authToken) async {
    Dio dio = _prepareDioWithAuthTokenHeader(authToken: authToken);
    String url = _formatUrlForPatrolReq();
    
    // TODO: Error handling and method contract
    try{
      Response jsonResponse = await dio.get(url);
      int status = jsonResponse.data['status'];
      if(status == 200){
        PatrolContainerDto patrolDto = PatrolContainerDto.fromJson(jsonResponse.data['data']);
        return patrolDto;
      } else {
        return null;
      }
    } catch(e){
      debugPrint(e.toString());
    }
  }

  /// Throws 
  Future<bool> reportPatrol(double lat, double lon, String authToken) async {
    Dio dio = _prepareDioWithAuthTokenHeader(authToken: authToken);
    String url = _formatUrlForPatrolReq();
    Map<String, dynamic> data = {
      "lat": lat,
      "lon": lon,
    };
    Response jsonResponse = await dio.post(url, data: data);
    int status = jsonResponse.data['status'];
    return status == 200;
    // TODO: Error handling and method contract
    // TODO: Handle case when user tries to report a patrol multiple times
  }

  /// Throws 
  Future<PatrolDto> confirmPatrol(String patrolId, double userLat, double userLon, bool confirmation, String authToken) async {
    Dio dio = _prepareDioWithAuthTokenHeader(authToken: authToken);
    String url = _formatUrlForPatrolConfirm();
    Map<String, dynamic> data = {
      "user_lat": userLat,
      "user_lon": userLon,
      "confirmation": confirmation,
      "patrol_id": patrolId,
    };
    Response jsonResponse = await dio.post(url, data: data);
    int status = jsonResponse.data['status'];
    if(status == 200){
      PatrolDto patrolDto = PatrolDto.fromJson(jsonResponse.data);
      return patrolDto;
    } else {
      return null;
    }
    // TODO: Error handling and method contract
  }
}