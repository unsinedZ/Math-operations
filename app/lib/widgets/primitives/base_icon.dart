import 'package:flutter/material.dart';

class BaseIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const BaseIcon({
    Key key,
    @required this.icon,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: CircleBorder(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon),
      ),
      onTap: onPressed,
    );
  }
}
