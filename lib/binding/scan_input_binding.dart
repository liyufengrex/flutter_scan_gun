import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scan_gun/input/text_input_focus_node.dart';

// 使用方法：在runApp()方法前初始化
class TextInputBinding extends WidgetsFlutterBinding
    with TextInputBindingMixin {}

mixin TextInputBindingMixin on WidgetsFlutterBinding {
  @override
  BinaryMessenger createBinaryMessenger() {
    return TextInputBinaryMessenger(super.createBinaryMessenger());
  }
}

class TextInputBinaryMessenger extends BinaryMessenger {
  TextInputBinaryMessenger(this.origin);

  final BinaryMessenger origin;

  // Flutter 的 Framework 层发送信息到 Flutter 引擎，会走这个方法
  @override
  Future<ByteData?>? send(
    String channel,
    ByteData? message,
  ) {
    if (channel == SystemChannels.textInput.name) {
      final methodCall = SystemChannels.textInput.codec.decodeMethodCall(
        message,
      );
      switch (methodCall.method) {
        case 'TextInput.show':
          final FocusNode? focus = FocusManager.instance.primaryFocus;
          if (focus != null &&
              focus is TextInputFocusNode &&
              focus.ignoreSystemKeyboardShow) {
            return Future.value(
              SystemChannels.textInput.codec.encodeSuccessEnvelope(null),
            );
          }
          break;
        default:
          break;
      }
    }
    return origin.send(channel, message);
  }

  // Flutter 引擎 发送信息到 Flutter 的 Framework 层的回调，无需处理
  @override
  void setMessageHandler(
    String channel,
    MessageHandler? handler,
  ) {
    origin.setMessageHandler(
      channel,
      handler,
    );
  }

  //无需处理
  @override
  Future<void> handlePlatformMessage(
    String channel,
    ByteData? data,
    PlatformMessageResponseCallback? callback,
  ) {
    return origin.handlePlatformMessage(
      channel,
      data,
      callback,
    );
  }
}
