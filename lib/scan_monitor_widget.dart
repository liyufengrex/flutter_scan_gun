import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'input/input_with_keyboard_widget.dart';
import 'input/text_input_focus_node.dart';

///扫码监听（包含TextFiled与scan同时存在的场景）
class ScanMonitorWidget extends StatefulWidget {
  final ChildBuilder childBuilder;
  final TextInputFocusNode? scanNode;
  final FocusNode? textFiledNode;
  final GlobalKey<EditableTextState>? scanKey;
  final void Function(String) onSubmit;

  //是否开启焦点轮询
  final bool focusLooper;
  final Duration focusLooperDuration;

  const ScanMonitorWidget({
    Key? key,
    required this.childBuilder,
    this.scanNode,
    this.textFiledNode,
    this.scanKey,
    required this.onSubmit,
    this.focusLooper = true,
    this.focusLooperDuration = const Duration(seconds: 2),
  }) : super(key: key);

  @override
  _ScanMonitorWidgetState createState() => _ScanMonitorWidgetState();
}

class _ScanMonitorWidgetState extends State<ScanMonitorWidget> {
  late final TextInputFocusNode scanNode;
  late final GlobalKey<EditableTextState> scanKey;

  @override
  void initState() {
    super.initState();
    scanNode = widget.scanNode ?? TextInputFocusNode();
    scanKey = widget.scanKey ?? GlobalKey<EditableTextState>();
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
      scanKey.currentState?.requestKeyboard();
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InputWithKeyboardWidget(
      focusNode: scanNode,
      editableKey: scanKey,
      onSubmit: (value) {
        widget.onSubmit(value);
      },
      childBuilder: (context) {
        return widget.childBuilder(context);
      },
    );
  }
}
