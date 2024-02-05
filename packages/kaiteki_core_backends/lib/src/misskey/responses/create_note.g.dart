// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateNoteResponse _$CreateNoteResponseFromJson(Map<String, dynamic> json) =>
    CreateNoteResponse(
      Note.fromJson(json['createdNote'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateNoteResponseToJson(CreateNoteResponse instance) =>
    <String, dynamic>{
      'createdNote': instance.createdNote,
    };
