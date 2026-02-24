import 'package:hive/hive.dart';

part 'scan_model.g.dart';

@HiveType(typeId: 0)
class ScanModel extends HiveObject {
  @HiveField(0)
  final String value;

  @HiveField(1)
  final String type;

  @HiveField(2)
  final DateTime time;

  ScanModel({
    required this.value,
    required this.type,
    required this.time,
  });
}
