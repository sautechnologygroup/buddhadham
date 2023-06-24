import 'package:buddhadham/utils/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().backgroundColor,
      appBar: AppBar(
        title: Center(
          child: Text(
            'เกี่ยวกับ',
            style: GoogleFonts.sarabun(),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'พุทธธรรม',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            const Text(
              'ยินดีต้อนรับสู่แอปพลิเคชันพุทธศาสนาภาษาไทย',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
