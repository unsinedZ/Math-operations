import 'package:app/business/operations/fraction.dart';
import 'package:app/business/operations/target_function.dart';
import 'package:app/widgets/layout/app_layout.dart';
import 'package:app/widgets/primitives/function_row.dart';
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
    return AppLayout(
      FunctionRow(
        targetFunction: _createDefaultFunction(),
      ),
      title: 'Dual simplex method',
    );
  }

  TargetFunction _createDefaultFunction() {
    return TargetFunction(
      coefficients: [
        Fraction.fromNumber(1),
        Fraction.fromNumber(1),
      ],
    );
  }
}
