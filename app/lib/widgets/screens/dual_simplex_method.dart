import 'package:app/widgets/layout/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DualSimplexMethod extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DualSimplexState();
  }
}

class _DualSimplexState extends State<DualSimplexMethod> {
  @override
  Widget build(BuildContext context) {
    return AppLayout(
      Form(
        child: Column(
          children: <Widget>[],
        ),
      ),
    );
  }
}
