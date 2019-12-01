import 'package:flutter/material.dart';

class BaseText extends StatelessWidget {
  final String text;

  const BaseText(
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
