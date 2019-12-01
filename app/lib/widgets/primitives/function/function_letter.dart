import 'package:app/widgets/primitives/common/base_button.dart';
import 'package:flutter/material.dart';

class FunctionLetter extends StatelessWidget {
  final String functionLetter;
  final String variableLetter;
  final VoidCallback onPressed;

  const FunctionLetter({
    Key key,
    this.functionLetter = 'f',
    this.variableLetter = 'x',
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String text = '$functionLetter($variableLetter)';
    return Row(
      children: <Widget>[
        BaseButton(
          text: text,
          onPressed: onPressed,
        ),
      ],
    );
  }
}
