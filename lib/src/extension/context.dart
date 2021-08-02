import 'package:flutter/widgets.dart';

extension ContextX on BuildContext {
  /// Provide size of the current context widget
  Size get sizeOfWidget {
    final RenderBox? rb = findRenderObject() as RenderBox?;
    return rb?.size ?? Size.zero;
  }
}
