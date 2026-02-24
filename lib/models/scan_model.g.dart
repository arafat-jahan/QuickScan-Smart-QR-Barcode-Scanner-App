
part of 'scan_model.dart';

class ScanModelAdapter extends TypeAdapter<ScanModel> {
  @override
  final int typeId = 0;

  @override
  ScanModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScanModel(
      value: fields[0] as String,
      type: fields[1] as String,
      time: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ScanModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.value)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ScanModelAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}
