import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scan_gun/forbid_keypad_window/editable_text.dart'
    as forbid; //禁止键盘弹出的 EditableText

typedef ChildBuilder = Widget Function(BuildContext context);

///借助输入框的焦点能力，获取扫码枪内容
class InputWithKeyboardWidget extends StatefulWidget {
  //非必传，如果传，可通过focusNode监听获取当前扫码可用状态，hasFocus时为可用；
  //也可通过 focusNode requestFocus 方法，强制扫码获取焦点，保证扫码能力；
  final FocusNode? focusNode;
  final ChildBuilder? childBuilder;
  final void Function(String)? onSubmit;

  const InputWithKeyboardWidget({
    Key? key,
    this.childBuilder,
    this.onSubmit,
    this.focusNode,
  }) : super(key: key);

  @override
  InputWithKeyboardWidgetState createState() => InputWithKeyboardWidgetState();
}

class InputWithKeyboardWidgetState extends State<InputWithKeyboardWidget> {
  final controller = TextEditingController();
  late final FocusNode focusNode;
  late final Widget edtWidget;

  @override
  void initState() {
    super.initState();
    focusNode = widget.focusNode ?? FocusNode();
    edtWidget = RepaintBoundary(
      child: forbid.EditableText(
        controller: controller,
        focusNode: focusNode,
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        backgroundCursorColor: Colors.white,
        showCursor: false,
        autofocus: true,
        onSubmitted: _onSubmit,
      ),
    );
  }

  void requestKeyboard() {
    focusNode.requestFocus();
  }

  void _onSubmit(value) {
    //把输入的结果回调出去
    if (widget.onSubmit != null) {
      widget.onSubmit!(value);
    }
    //清空本次结果，要求每次都是独立的结果
    controller.clear();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    //结束后继续获取焦点
    requestKeyboard();
  }

  @override
  Widget build(BuildContext context) {
    final Widget child = widget.childBuilder == null
        ? Container()
        : widget.childBuilder!(context);
    return Stack(
      children: [
        //让输入框保持隐藏
        Offstage(child: edtWidget, offstage: true),
        child,
      ],
    );
  }
}
