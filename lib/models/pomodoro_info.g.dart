// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pomodoro_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PomodoroInfoImpl _$$PomodoroInfoImplFromJson(Map<String, dynamic> json) =>
    _$PomodoroInfoImpl(
      planned: (json['planned'] as num).toInt(),
      actual: (json['actual'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$PomodoroInfoImplToJson(_$PomodoroInfoImpl instance) =>
    <String, dynamic>{'planned': instance.planned, 'actual': instance.actual};
