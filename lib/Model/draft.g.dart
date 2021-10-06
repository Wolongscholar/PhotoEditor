// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draft.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DraftAdapter extends TypeAdapter<Draft> {
  @override
  final int typeId = 0;

  @override
  Draft read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Draft(
      fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Draft obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.path);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DraftAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
