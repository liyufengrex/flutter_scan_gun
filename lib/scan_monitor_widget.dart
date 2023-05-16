import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:visibility_detector/visibility_detector.dart';
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
    this.focusLooper = false,
    this.focusLooperDuration = const Duration(seconds: 2),
  }) : super(key: key);

  @override
  _ScanMonitorWidgetState createState() => _ScanMonitorWidgetState();
}

class _ScanMonitorWidgetState extends State<ScanMonitorWidget> {
  late final TextInputFocusNode scanNode;
  late final GlobalKey<EditableTextState> scanKey;

  Timer? _focusLooper;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    scanNode = widget.scanNode ?? TextInputFocusNode();
    scanKey = widget.scanKey ?? GlobalKey<EditableTextState>();
    widget.textFiledNode?.addListener(_listenTextFiledFocus);
  }

  @override
  void dispose() {
    _closeFocusLooper();
    widget.textFiledNode?.removeListener(_listenTextFiledFocus);
    super.dispose();
  }

  void _requestFocus() {
    if (!scanNode.hasFocus){
      scanNode.requestFocus();
    }
    scanKey.currentState?.requestKeyboard();
  }

  void _listenTextFiledFocus() {
    if (widget.textFiledNode != null && !widget.textFiledNode!.hasFocus) {
      //当外部 textFiled 焦点取消后，马上切换为扫码的焦点
      scanNode.requestFocus();
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    }
  }

  void _closeFocusLooper() {
    if (_focusLooper != null) {
      if (_focusLooper!.isActive) {
        _focusLooper?.cancel();
      }
      _focusLooper = null;
    }
  }

  //保证扫码焦点不消失
  void _checkScanAble() {
    if (_isVisible) {
      final textFileHasFocus = widget.textFiledNode != null && widget.textFiledNode!.hasFocus;
      if (!textFileHasFocus) {
        _requestFocus();
      }
      if (widget.focusLooper) {
        _closeFocusLooper();
        _focusLooper ??= Timer(
          widget.focusLooperDuration,
          _checkScanAble,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final child = InputWithKeyboardWidget(
      focusNode: scanNode,
      editableKey: scanKey,
      onSubmit: (value) {
        widget.onSubmit(value);
      },
      childBuilder: (context) {
        return widget.childBuilder(context);
      },
    );
    return VisibilityDetector(
            key: widget.key ?? GlobalKey(debugLabel: 'default_scan_key'),
            child: child,
            onVisibilityChanged: (visibilityInfo) {
              final newVisible = visibilityInfo.visibleFraction > 0;
              if (_isVisible != newVisible) {
                _isVisible = newVisible;
                _checkScanAble();
              }
            },
          );
  }
}
