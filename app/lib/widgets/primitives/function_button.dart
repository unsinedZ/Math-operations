import 'package:flutter/material.dart';

import 'function_text.dart';

class FunctionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const FunctionButton({
    Key key,
    @required this.onPressed,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        child: FunctionText(text),
        padding: EdgeInsets.symmetric(
          horizontal: 12,
        ),
        margin: EdgeInsets.symmetric(
          vertical: 12,
        ),
      ),
      onTap: onPressed,
    );
  }
}
