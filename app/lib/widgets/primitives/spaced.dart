import 'package:flutter/material.dart';

class Spaced extends StatelessWidget {
  final Widget child;

  const Spaced({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(6),
      padding: EdgeInsets.all(6),
      child: child,
    );
  }
}
