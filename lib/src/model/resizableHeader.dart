import 'package:flutter/material.dart';

class ResizableHeader {
  String columnName;
  late final ValueNotifier<double> _width;
  late double dragStart;
  late double minWidth;

  ValueNotifier<double> get currentWidth => _width;

  ResizableHeader(this.columnName, {double? width, double? minWidth}) {
    _width = ValueNotifier<double>(width ?? 100);
    dragStart = width ?? 100;
    this.minWidth = minWidth ?? 5;
  }

  void setWidth(double width) {
    _width.value = width;
  }
}
