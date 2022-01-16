// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Comments.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CommentsAdapter extends TypeAdapter<Comments> {
  @override
  final int typeId = 3;

  @override
  Comments read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Comments(
      postId: fields[0] as int,
      id: fields[1] as int,
      name: fields[2] as String,
      body: fields[3] as String,
      email: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Comments obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.postId)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.body)
      ..writeByte(4)
      ..write(obj.email);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommentsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
