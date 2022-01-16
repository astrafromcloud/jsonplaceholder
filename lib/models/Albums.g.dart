// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Albums.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AlbumsAdapter extends TypeAdapter<Albums> {
  @override
  final int typeId = 2;

  @override
  Albums read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Albums(
      userId: fields[0] as int,
      id: fields[1] as int,
      title: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Albums obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.title);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlbumsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
