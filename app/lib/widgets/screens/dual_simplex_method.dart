import 'package:app/widgets/layout/app_layout.dart';
import 'package:flutter/material.dart';

class DualSimplexMethod extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DualSimplexState();
  }
}

class _DualSimplexState extends State<DualSimplexMethod> {
  @override
  Widget build(BuildContext context) {
    const fields = const [
      'x1',
      'x2',
      'x3',
      'x4',
    ];
    return AppLayout(
      Form(
        child: Row(
          children: [
            Text('f(x) = '),
            ...fields.map((field) {
              return Flexible(
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: field,
                        ),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Flexible(
                      child: Text('* $field +'),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
