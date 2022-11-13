// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_secret.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AccountSecretAdapter extends TypeAdapter<AccountSecret> {
  @override
  final int typeId = 1;

  @override
  AccountSecret read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AccountSecret(
      fields[1] as String,
      fields[2] as String?,
      fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AccountSecret obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.accessToken)
      ..writeByte(2)
      ..write(obj.refreshToken)
      ..writeByte(3)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountSecretAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountSecret _$AccountSecretFromJson(Map<String, dynamic> json) =>
    AccountSecret(
      json['token'] as String,
      json['refreshToken'] as String?,
      json['userId'] as String?,
    );

Map<String, dynamic> _$AccountSecretToJson(AccountSecret instance) =>
    <String, dynamic>{
      'token': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'userId': instance.userId,
    };
