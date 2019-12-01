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
      title: 'Dual simplex method',
      content: Column(
        children: <Widget>[
          _CardWrapper(
            child: FunctionRow(
              targetFunction: _createDefaultFunction(),
            ),
          ),
        ],
      ),
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

class _CardWrapper extends StatelessWidget {
  final Widget _child;

  const _CardWrapper({
    Key key,
    @required Widget child,
  })  : this._child = child,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Card(
            child: _child,
          ),
        ),
      ],
    );
  }
}
