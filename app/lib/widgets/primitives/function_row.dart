import 'package:flutter/material.dart';

import 'function_variable.dart';

class FunctionRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
            left: 16,
          ),
          child: Text(
            'f(x) = ',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        FunctionVariable(
          name: 'x1',
          onPressed: () {},
        ),
        Text('+'),
        FunctionVariable(
          name: 'x2',
          onPressed: () {},
        ),
      ],
    );
  }
}
