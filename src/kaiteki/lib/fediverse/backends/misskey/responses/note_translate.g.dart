// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_translate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteTranslateResponse _$NoteTranslateResponseFromJson(
        Map<String, dynamic> json) =>
    NoteTranslateResponse(
      json['sourceLang'] as String,
      json['text'] as String,
    );

Map<String, dynamic> _$NoteTranslateResponseToJson(
        NoteTranslateResponse instance) =>
    <String, dynamic>{
      'sourceLang': instance.sourceLang,
      'text': instance.text,
    };
