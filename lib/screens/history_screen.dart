import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/scan_model.dart';
import '../widgets/scan_card.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Scan History",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<ScanModel>('scans').listenable(),
        builder: (context, Box<ScanModel> box, _) {
          if (box.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.history, size: 60, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "No scans available",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: box.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, index) {
              final scan = box.getAt(index)!;

              return Dismissible(
                key: Key(scan.key.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  scan.delete();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Scan deleted")),
                  );
                },
                child: ScanCard(scan: scan, index: index),
              );
            },
          );
        },
      ),
    );
  }
}