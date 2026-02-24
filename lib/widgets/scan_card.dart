import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import '../models/scan_model.dart';

class ScanCard extends StatelessWidget {
  final ScanModel scan;
  final int index;

  const ScanCard({
    super.key,
    required this.scan,
    required this.index,
  });

  bool get isQr =>
      scan.type.toLowerCase().contains('qr');

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(scan.time),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          _roundedAction(
            icon: Icons.copy,
            label: "Copy",
            color: Colors.blue,
            onTap: () {
              Clipboard.setData(ClipboardData(text: scan.value));
              Fluttertoast.showToast(msg: "Copied to clipboard");
            },
          ),
          _roundedAction(
            icon: Icons.share,
            label: "Share",
            color: Colors.green,
            onTap: () {
              Share.share(scan.value);
            },
          ),
          _roundedAction(
            icon: Icons.delete,
            label: "Delete",
            color: Colors.red,
            onTap: () {
              Hive.box<ScanModel>('scans').deleteAt(index);
            },
          ),
        ],
      ),
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isQr
                      ? Colors.deepPurple.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isQr ? Icons.qr_code_2 : Icons.view_week,
                  color: isQr ? Colors.deepPurple : Colors.orange,
                  size: 28,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isQr
                            ? Colors.deepPurple.withOpacity(0.15)
                            : Colors.orange.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isQr ? "QR CODE" : "BARCODE",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color:
                          isQr ? Colors.deepPurple : Colors.orange,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      scan.value,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      DateFormat('dd MMM yyyy • hh:mm a')
                          .format(scan.time),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roundedAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SlidableAction(
      onPressed: (_) => onTap(),
      backgroundColor: color,
      foregroundColor: Colors.white,
      icon: icon,
      label: label,
      borderRadius: BorderRadius.circular(16),
    );
  }
}
