import 'package:flutter/material.dart';

import 'input/input_with_keyboard_widget.dart';

///扫码监听（包含TextFiled与scan同时存在的场景）
class ScanMonitorWidget extends StatefulWidget {
  final ChildBuilder childBuilder;
  final FocusNode? scanNode;
  final FocusNode? textFiledNode;
  final void Function(String) onSubmit;

  const ScanMonitorWidget({
    Key? key,
    required this.childBuilder,
    this.scanNode,
    this.textFiledNode,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _ScanMonitorWidgetState createState() => _ScanMonitorWidgetState();
}

class _ScanMonitorWidgetState extends State<ScanMonitorWidget> {
  late final FocusNode scanNode;

  @override
  void initState() {
    super.initState();
    scanNode = widget.scanNode ?? FocusNode();
    widget.textFiledNode?.addListener(_listenTextFiledFocus);
  }

  @override
  void dispose() {
    widget.textFiledNode?.removeListener(_listenTextFiledFocus);
    super.dispose();
  }

  void _listenTextFiledFocus() {
    if (widget.textFiledNode != null && !widget.textFiledNode!.hasFocus) {
      //当外部 textFiled 焦点取消后，马上切换为扫码的焦点
      scanNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return InputWithKeyboardWidget(
      focusNode: scanNode,
      onSubmit: (value) {
        widget.onSubmit(value);
      },
      childBuilder: (context) {
        return widget.childBuilder(context);
      },
    );
  }
}
