import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../models/scan_model.dart';
import '../widgets/scan_card.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: Column(
          children: [

            /// 🔥 Premium Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Scan History",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.4,
                    ),
                  ),
                  Icon(
                    Icons.history_rounded,
                    color: Color(0xFF6A5AE0),
                    size: 28,
                  ),
                ],
              ),
            ),

            /// 🔥 Content Section
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                ),
                child: ValueListenableBuilder(
                  valueListenable:
                  Hive.box<ScanModel>('scans').listenable(),
                  builder: (context, Box<ScanModel> box, _) {

                    if (box.isEmpty) {
                      return _emptyState();
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.all(24),
                      itemCount: box.length,
                      separatorBuilder: (_, __) =>
                      const SizedBox(height: 20),
                      itemBuilder: (context, index) {

                        final scan = box.getAt(index)!;

                        return Dismissible(
                          key: Key(scan.key.toString()),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 28),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF4D4F),
                              borderRadius:
                              BorderRadius.circular(22),
                            ),
                            child: const Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                          confirmDismiss: (_) async {
                            return await _confirmDelete(context);
                          },
                          onDismissed: (_) {
                            HapticFeedback.mediumImpact();
                            scan.delete();
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text("Scan deleted"),
                                behavior:
                                SnackBarBehavior.floating,
                              ),
                            );
                          },
                          child: GestureDetector(
                            onLongPress: () =>
                                _showActionSheet(context, scan),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(22),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.04),
                                    blurRadius: 18,
                                    offset:
                                    const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius:
                                BorderRadius.circular(22),
                                child: ScanCard(
                                  scan: scan,
                                  index: index,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 Empty State
  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.qr_code_scanner_rounded,
              size: 72,
              color: Colors.grey,
            ),
            SizedBox(height: 20),
            Text(
              "No Scans Yet",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Your scanned QR codes and barcodes will appear here.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 Confirm Delete Dialog
  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.delete_outline,
                  size: 40, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                "Delete Scan?",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                "This action cannot be undone.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () =>
                          Navigator.pop(context, false),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () =>
                          Navigator.pop(context, true),
                      child: const Text("Delete"),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  /// 🔥 Professional Action Sheet
  void _showActionSheet(
      BuildContext context, ScanModel scan) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Container(
                height: 5,
                width: 40,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              _actionButton(
                icon: Icons.copy_rounded,
                label: "Copy",
                onTap: () {
                  Clipboard.setData(
                      ClipboardData(text: scan.value));
                  Navigator.pop(context);
                },
              ),

              const SizedBox(height: 14),

              _actionButton(
                icon: Icons.share_rounded,
                label: "Share",
                onTap: () {
                  Navigator.pop(context);
                  Share.share(scan.value);
                },
              ),

              const SizedBox(height: 14),

              _actionButton(
                icon: Icons.delete_rounded,
                label: "Delete",
                isDanger: true,
                onTap: () {
                  Navigator.pop(context);
                  scan.delete();
                },
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  /// 🔥 Professional Action Button
  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 16, horizontal: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: isDanger
              ? Colors.red.withOpacity(0.08)
              : Colors.grey.withOpacity(0.05),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDanger
                    ? Colors.red.withOpacity(0.15)
                    : const Color(0xFF6A5AE0)
                    .withOpacity(0.12),
              ),
              child: Icon(
                icon,
                size: 22,
                color: isDanger
                    ? Colors.red
                    : const Color(0xFF6A5AE0),
              ),
            ),
            const SizedBox(width: 18),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDanger
                    ? Colors.red
                    : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}