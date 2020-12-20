// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patrol_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatrolDto _$PatrolDtoFromJson(Map<String, dynamic> json) {
  return PatrolDto()
    ..id = json['id'] as String
    ..lat = (json['lat'] as num)?.toDouble()
    ..lon = (json['lon'] as num)?.toDouble()
    ..confidence = (json['confidence'] as num)?.toDouble()
    ..distance = (json['distance'] as num)?.toDouble();
}

Map<String, dynamic> _$PatrolDtoToJson(PatrolDto instance) => <String, dynamic>{
      'id': instance.id,
      'lat': instance.lat,
      'lon': instance.lon,
      'confidence': instance.confidence,
      'distance': instance.distance,
    };
