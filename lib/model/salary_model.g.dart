// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salary_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SalaryModelAdapter extends TypeAdapter<SalaryModel> {
  @override
  final int typeId = 2;

  @override
  SalaryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SalaryModel(
      totalSalary: fields[0] as double,
      updatedAt: fields[1] as DateTime?,
      month: fields[2] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, SalaryModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.totalSalary)
      ..writeByte(1)
      ..write(obj.updatedAt)
      ..writeByte(2)
      ..write(obj.month);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SalaryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
