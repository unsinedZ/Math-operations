import 'package:flutter/material.dart';

import 'default_app_bar.dart';

class AppLayout extends StatelessWidget {
  final Widget _body;
  final String title;

  const AppLayout(
    this._body, {
    this.title,
    Key key,
    Widget body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: title,
      ),
      body: this._body,
    );
  }
}
