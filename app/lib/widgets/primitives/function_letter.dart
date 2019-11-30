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
    String text = '$functionLetter($variableLetter)';
    return Row(
      children: <Widget>[
        FlatButton(
          child: Text(text),
          onPressed: () {},
        ),
        Text('=')
      ],
    );
  }
}
