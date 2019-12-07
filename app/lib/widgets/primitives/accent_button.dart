import 'package:flutter/material.dart';

class AccentButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const AccentButton({
    Key key,
    @required this.text,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return RaisedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: theme.accentTextTheme.button,
      ),
      color: theme.accentColor,
    );
  }
}
