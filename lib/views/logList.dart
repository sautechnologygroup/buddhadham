import 'package:flutter/material.dart';

class LogListScreen extends StatefulWidget {
  const LogListScreen({Key? key}) : super(key: key);

  @override
  State<LogListScreen> createState() => _LogListScreenState();
}

class _LogListScreenState extends State<LogListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('รายการบันทึก'))),
    );
  }
}
