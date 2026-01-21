// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pomodoro_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PomodoroInfo _$PomodoroInfoFromJson(Map<String, dynamic> json) =>
    _PomodoroInfo(
      planned: (json['planned'] as num).toInt(),
      actual: (json['actual'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$PomodoroInfoToJson(_PomodoroInfo instance) =>
    <String, dynamic>{'planned': instance.planned, 'actual': instance.actual};
