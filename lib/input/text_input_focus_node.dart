import 'package:flutter/material.dart';

class TextInputFocusNode extends FocusNode {
  final bool ignoreSystemKeyboardShow;

  TextInputFocusNode({
    String? debugLabel,
    FocusOnKeyEventCallback? onKeyEvent,
    FocusOnKeyCallback? onKey,
    bool skipTraversal = false,
    bool canRequestFocus = true,
    this.ignoreSystemKeyboardShow = true,
  }) : super(
          debugLabel: debugLabel,
          onKeyEvent: onKeyEvent,
          onKey: onKey,
          skipTraversal: skipTraversal,
          canRequestFocus: canRequestFocus,
        );
}
