import 'package:app/business/operations/target_function.dart';
import 'package:app/widgets/primitives/base_text.dart';
import 'package:flutter/material.dart';

class GreaterZeroMessage extends StatelessWidget {
  final TargetFunction targetFunction;

  const GreaterZeroMessage({
    Key key,
    @required this.targetFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String indices = List.generate(this.targetFunction.coefficients.length, (i) => i + 1).join(', ');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          BaseText('xᵢ ≥ 0,'),
          BaseText('i = $indices')
        ],
      ),
    );
  }
}
