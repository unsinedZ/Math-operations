import 'package:flutter/material.dart';

import 'base_text.dart';

class BaseButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const BaseButton({
    Key key,
    @required this.onPressed,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 4,
      ),
      color: Colors.blueGrey.shade50,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          child: Container(
            child: BaseText(text),
            margin: EdgeInsets.all(6),
            padding: EdgeInsets.all(6),
          ),
          onTap: onPressed,
        ),
      ),
    );
  }
}
