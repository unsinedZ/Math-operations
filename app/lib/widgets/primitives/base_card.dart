import 'package:flutter/material.dart';

class BaseCard extends StatelessWidget {
  final Widget child;

  const BaseCard({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Card(
            margin: EdgeInsets.all(12),
            elevation: 12,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}
