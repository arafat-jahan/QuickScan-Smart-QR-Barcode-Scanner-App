import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/scan_model.dart';
import 'screens/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ScanModelAdapter());
  await Hive.openBox<ScanModel>('scans');

  runApp(const QuickScanApp());
}

class QuickScanApp extends StatelessWidget {
  const QuickScanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QuickScan App',
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorSchemeSeed: Colors.deepPurple,
      ),
      home: const HomePage(),
    );
  }
}
