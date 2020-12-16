import 'package:anti_patrola/data/dtos/patrol_container_dto.dart';
import 'package:anti_patrola/data/dtos/patrol_dto.dart';
import 'package:anti_patrola/exceptions/network_exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'network_utils.dart';

class Network{
  static const String _BASE_URL = 'http://localhost/';
  //static const String _BASE_URL = 'http://18.220.147.217/';
  //static const String _BASE_URL = 'http://antipatrola.ml/';
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

  /// Returns all active patrols (reported in the last 1.5h) as a [PatrolContainerDto]
  /// or NULL if something goes wrong
  /// Throws [UnauthorizedAccessException] if token is invalid/expired/missing
  /// Throws [NetworkException] if something goes else wrong
  Future<PatrolContainerDto> getActivePatrols(String authToken) async {
    Dio dio = _prepareDioWithAuthTokenHeader(authToken: authToken);
    String url = _formatUrlForPatrolReq();
    try{
      Response jsonResponse = await dio.get(url);
      PatrolContainerDto patrolDto = PatrolContainerDto.fromJson(jsonResponse.data['data']);
      return patrolDto;
    } on DioError catch (e){
      throw NetworkUtils.mapDioErrorToException(e);
    } catch (e) {
      // TODO: Log here
      debugPrint(e.toString());
      return null;
    }
  }

  /// Reports a patrol at the [lat], [lon] coordinates, returns true if report went smoothly
  /// Throws [UnauthorizedAccessException] if token is invalid/expired/missing
  /// Throws [TooManyRequestsException] if you try to report two or more patrols
  /// in a quick succession
  /// Throws [InvalidRequestException] if not all parameters are provided in the request
  /// Throws [NetworkException] if something goes else wrong
  Future<bool> reportPatrol(double lat, double lon, String authToken) async {
    Dio dio = _prepareDioWithAuthTokenHeader(authToken: authToken);
    String url = _formatUrlForPatrolReq();
    Map<String, dynamic> data = {
      "lat": lat,
      "lon": lon,
    };
    try{
      await dio.post(url, data: data);
      return true;
    } on DioError catch(e) {
      throw NetworkUtils.mapDioErrorToException(e);
    } catch (e) {
      // TODO: Log here
      debugPrint(e.toString());
      return false;
    }
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
  Future<PatrolDto> confirmPatrol(String patrolId, double userLat, double userLon, bool confirmation, String authToken) async {
    Dio dio = _prepareDioWithAuthTokenHeader(authToken: authToken);
    String url = _formatUrlForPatrolConfirm();
    Map<String, dynamic> data = {
      "user_lat": userLat,
      "user_lon": userLon,
      "confirmation": confirmation,
      "patrol_id": patrolId,
    };

    try{
      Response jsonResponse = await dio.post(url, data: data);
      PatrolDto patrolDto = PatrolDto.fromJson(jsonResponse.data);
      return patrolDto;
    } on DioError catch (e){
      throw NetworkUtils.mapDioErrorToException(e);
    } catch (e) {
      // TODO: Log here
      debugPrint(e.toString());
      return null;
    }
    
  }
}