import 'package:hive/hive.dart';
import '../models/scan_model.dart';

class HiveService {
  static const String boxName = 'scans';

  static Future<void> addScan(ScanModel scan) async {
    final box = Hive.box<ScanModel>(boxName);
    await box.add(scan);
  }

  static List<ScanModel> getScans() {
    return Hive.box<ScanModel>(boxName).values.toList().reversed.toList();
  }

  static Future<void> deleteScan(int index) async {
    await Hive.box<ScanModel>(boxName).deleteAt(index);
  }
}
