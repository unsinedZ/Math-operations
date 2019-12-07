import 'package:flutter/material.dart';

import 'default_app_bar.dart';

class AppLayout extends StatelessWidget {
  final Widget _body;
  final String title;

  const AppLayout({
    @required Widget content,
    Key key,
    this.title,
  })  : this._body = content,
        super(key: key);

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
