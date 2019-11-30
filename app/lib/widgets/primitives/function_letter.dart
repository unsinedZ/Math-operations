import 'package:flutter/material.dart';

class FunctionLetter extends StatelessWidget {
  final String functionLetter;
  final String variableLetter;

  const FunctionLetter({
    this.functionLetter,
    this.variableLetter,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(functionLetter),
        Text('($variableLetter)'),
        Text(' = '),
      ],
    );
  }
}
