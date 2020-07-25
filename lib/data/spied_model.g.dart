// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spied_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SpiedModelAdapter extends TypeAdapter<SpiedModel> {
  @override
  final int typeId = 0;

  @override
  SpiedModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SpiedModel(
      (fields[0] as Map)?.cast<dynamic, dynamic>(),
      fields[1] as String,
      fields[3] as Uint8List,
      fields[2] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, SpiedModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.rect)
      ..writeByte(1)
      ..write(obj.word)
      ..writeByte(2)
      ..write(obj.aspectRatio)
      ..writeByte(3)
      ..write(obj.finalImage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpiedModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
