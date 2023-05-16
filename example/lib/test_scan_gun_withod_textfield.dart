import 'package:example/test_scan_gun_with_textfield.dart';
import 'package:flutter/material.dart';
import 'package:scan_gun/scan_gun.dart';

///无输入框交互，获取扫码结果
class TestScanGun extends StatefulWidget {
  const TestScanGun({Key? key}) : super(key: key);

  @override
  _TestScanGunState createState() => _TestScanGunState();
}

class _TestScanGunState extends State<TestScanGun> {
  String? scanData;

  Widget body() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('场景1：无交互获取扫码结果：${scanData ?? ''}'),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return const Dialog(
                    child: TestScanGun2(),
                  );
                },
              );
            },
            child: const Text('弹窗测试场景2'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScanMonitorWidget(
      childBuilder: (context) {
        return body();
      },
      // focusLooper: true,
      onSubmit: (String result) {
        //接收到扫码结果
        setState(() {
          scanData = result;
        });
      },
    );
  }
}
