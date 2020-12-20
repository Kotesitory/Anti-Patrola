import 'package:anti_patrola/data/dtos/patrol_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'patrol_container_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class PatrolContainerDto{
  List<PatrolDto> patrols;

  PatrolContainerDto();

  factory PatrolContainerDto.fromJson(Map<String, dynamic> json) => _$PatrolContainerDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PatrolContainerDtoToJson(this);
}