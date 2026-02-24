import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/scan_model.dart';
import '../widgets/scan_card.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan History")),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<ScanModel>('scans').listenable(),
        builder: (context, Box<ScanModel> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text("No scans available"));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (_, index) {
              final scan = box.getAt(index)!;
              return ScanCard(scan: scan, index: index);
            },
          );
        },
      ),
    );
  }
}
