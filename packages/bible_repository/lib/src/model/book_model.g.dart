// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookModelImpl _$$BookModelImplFromJson(Map<String, dynamic> json) =>
    _$BookModelImpl(
      name: json['name'] as String,
      referenceId: _referenceFromJson(json['reference_id'] as String),
      chapters: (json['chapters'] as List<dynamic>)
          .map((e) => ChapterModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$BookModelImplToJson(_$BookModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'reference_id': _referenceToJson(instance.referenceId),
      'chapters': instance.chapters,
    };
