// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_secret.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClientSecretAdapter extends TypeAdapter<ClientSecret> {
  @override
  final int typeId = 2;

  @override
  ClientSecret read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClientSecret(
      fields[1] as String,
      fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ClientSecret obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.clientId)
      ..writeByte(2)
      ..write(obj.clientSecret);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClientSecretAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientSecret _$ClientSecretFromJson(Map<String, dynamic> json) => ClientSecret(
      json['id'] as String,
      json['secret'] as String,
    );

Map<String, dynamic> _$ClientSecretToJson(ClientSecret instance) =>
    <String, dynamic>{
      'id': instance.clientId,
      'secret': instance.clientSecret,
    };
