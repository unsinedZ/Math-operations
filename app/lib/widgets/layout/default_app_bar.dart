import 'package:flutter/material.dart';

class DefaultAppBar extends AppBar {
  static const String APP_NAME = 'MMDO-ZLP';

  DefaultAppBar({String title}) :
    super(title: _buildTitle());

  static Widget _buildTitle([String title]) {
    return Text(title ?? APP_NAME);
  }
}
