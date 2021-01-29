import 'package:flutter/foundation.dart';

class PatrolModel {
  String id;
  double lat;
  double lon;
  double confidence;
  double distance;

  PatrolModel(
      {@required this.id,
      @required this.lat,
      @required this.lon,
      @required this.confidence,
      @required this.distance});

  @override
  @nonVirtual
  bool operator == (Object other){
    if (other is PatrolModel)
      return other.id == this.id;
    
    return false;
  }

  @override
  int get hashCode => id.hashCode;

}
