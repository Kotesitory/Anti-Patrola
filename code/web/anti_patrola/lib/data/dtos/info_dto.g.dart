// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InfoDto _$InfoDtoFromJson(Map<String, dynamic> json) {
  return InfoDto()
    ..itemCount = json['itemCount'] as int
    ..sort = _$enumDecodeNullable(_$PatrolSortTypeEnumMap, json['sort']);
}

Map<String, dynamic> _$InfoDtoToJson(InfoDto instance) => <String, dynamic>{
      'itemCount': instance.itemCount,
      'sort': _$PatrolSortTypeEnumMap[instance.sort],
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$PatrolSortTypeEnumMap = {
  PatrolSortType.NEWEST_FIRST: 'NEWEST_FIRST',
};
