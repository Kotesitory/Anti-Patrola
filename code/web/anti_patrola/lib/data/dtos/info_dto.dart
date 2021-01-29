import 'package:json_annotation/json_annotation.dart';

part 'info_dto.g.dart';

@JsonSerializable()
class InfoDto{
  int itemCount;
  PatrolSortType sort;

  InfoDto();

  factory InfoDto.fromJson(Map<String, dynamic> json) => _$InfoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$InfoDtoToJson(this);
}

enum PatrolSortType {
  NEWEST_FIRST,
}