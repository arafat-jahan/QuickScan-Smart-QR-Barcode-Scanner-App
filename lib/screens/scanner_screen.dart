import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';

import '../models/scan_model.dart';
import '../widgets/scan_overlay.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage>
    with SingleTickerProviderStateMixin {
  bool _hasPermission = false;
  bool _isDetecting = false;

  late final MobileScannerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
    );
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      setState(() => _hasPermission = true);
    } else {
      Fluttertoast.showToast(msg: "Camera permission required");
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasPermission) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Scan QR / Barcode"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [

          MobileScanner(
            controller: _controller,
            onDetect: (capture) async {
              if (_isDetecting) return;

              final barcode = capture.barcodes.first;
              if (barcode.rawValue == null) return;

              setState(() => _isDetecting = true);

              await Hive.box<ScanModel>('scans').add(
                ScanModel(
                  value: barcode.rawValue!,
                  type: barcode.format.name,
                  time: DateTime.now(),
                ),
              );

              await Future.delayed(const Duration(milliseconds: 600));

              Fluttertoast.showToast(msg: "Scan Successful");
              Navigator.pop(context);
            },
          ),


          Container(
            color: Colors.black.withOpacity(0.5),
          ),


          Center(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),


          ScanOverlay(isDetecting: _isDetecting),


          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Text(
              "Align QR / Barcode inside the frame",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
