import 'package:flutter/cupertino.dart';

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
      this.distance});
}
