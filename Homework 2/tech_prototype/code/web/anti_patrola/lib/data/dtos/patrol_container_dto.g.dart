// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patrol_container_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatrolContainerDto _$PatrolContainerDtoFromJson(Map<String, dynamic> json) {
  return PatrolContainerDto()
    ..patrols = (json['patrols'] as List)
        ?.map((e) =>
            e == null ? null : PatrolDto.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$PatrolContainerDtoToJson(PatrolContainerDto instance) =>
    <String, dynamic>{
      'patrols': instance.patrols?.map((e) => e?.toJson())?.toList(),
    };
