import 'package:example/test_scan_gun_withod_textfield.dart';
import 'package:flutter/material.dart';
import 'package:scan_gun/scan_gun.dart';

void main() {
  TextInputBinding();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'scan_gun_demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('扫码枪测试'),
        ),
        body: const TestScanGun(),
      ),
    );
  }
}
