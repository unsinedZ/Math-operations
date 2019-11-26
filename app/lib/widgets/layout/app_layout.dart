import 'package:flutter/material.dart';

import 'default_app_bar.dart';

class AppLayout extends StatelessWidget {
  final Widget _body;

  const AppLayout(this._body, {Key key, Widget body}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(),
      body: this._body,
    );
  }
}