import 'package:json_annotation/json_annotation.dart';

part 'patrol_dto.g.dart';

@JsonSerializable()
class PatrolDto{
  String id;
  double lat;
  double lon;
  double confidence;

  PatrolDto();

  factory PatrolDto.fromJson(Map<String, dynamic> json) => _$PatrolDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PatrolDtoToJson(this);
}