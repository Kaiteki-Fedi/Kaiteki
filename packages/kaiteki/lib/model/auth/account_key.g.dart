// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_key.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AccountKeyAdapter extends TypeAdapter<AccountKey> {
  @override
  final int typeId = 0;

  @override
  AccountKey read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AccountKey(
      fields[0] as BackendType<BackendAdapter>?,
      fields[1] as String,
      fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AccountKey obj) {
    writer
      ..writeByte(3)
      ..writeByte(2)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.host)
      ..writeByte(0)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountKeyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountKey _$AccountKeyFromJson(Map<String, dynamic> json) => AccountKey(
      $enumDecodeNullable(_$BackendTypeEnumMap, json['type'],
          unknownValue: JsonKey.nullForUndefinedEnumValue),
      json['host'] as String,
      json['username'] as String,
    );

Map<String, dynamic> _$AccountKeyToJson(AccountKey instance) =>
    <String, dynamic>{
      'username': instance.username,
      'host': instance.host,
      'type': _$BackendTypeEnumMap[instance.type],
    };

const _$BackendTypeEnumMap = {
  BackendType.mastodon: 'mastodon',
  BackendType.glitch: 'glitch',
  BackendType.pleroma: 'pleroma',
  BackendType.misskey: 'misskey',
  BackendType.akkoma: 'akkoma',
  BackendType.foundkey: 'foundkey',
  BackendType.calckey: 'calckey',
};
