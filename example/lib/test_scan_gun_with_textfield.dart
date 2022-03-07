import 'package:flutter/material.dart';
import 'package:scan_gun/scan_gun.dart';

///带输入框交互，获取扫码结果
class TestScanGun2 extends StatefulWidget {
  const TestScanGun2({Key? key}) : super(key: key);

  @override
  _TestScanGun2State createState() => _TestScanGun2State();
}

class _TestScanGun2State extends State<TestScanGun2> {
  FocusNode textFiledNode = FocusNode();
  TextEditingController controller = TextEditingController();

  Widget body() {
    const border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(color: Colors.white, width: 1),
    );
    return Center(
      child: TextField(
        focusNode: textFiledNode,
        controller: controller,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 15),
          filled: true,
          hintText: '场景2：测试带输入框交互，焦点切换',
          hintStyle: TextStyle(color: Colors.grey),
          enabledBorder: border,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 400,
      padding: const EdgeInsets.all(30),
      child: ScanMonitorWidget(
        textFiledNode: textFiledNode,
        onSubmit: (value) {
          setState(() {
            controller.text = value;
          });
        },
        childBuilder: (context) {
          return body();
        },
      ),
    );
  }
}
