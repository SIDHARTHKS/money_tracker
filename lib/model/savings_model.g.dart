// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'savings_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavingsModelAdapter extends TypeAdapter<SavingsModel> {
  @override
  final int typeId = 3;

  @override
  SavingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavingsModel(
      amount: fields[0] as double,
      date: fields[1] as DateTime,
      note: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SavingsModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.amount)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavingsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
