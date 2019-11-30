import 'package:flutter/material.dart';

class FunctionText extends StatelessWidget {
  final String text;

  const FunctionText(
    this.text, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
      ),
    );
  }
}
