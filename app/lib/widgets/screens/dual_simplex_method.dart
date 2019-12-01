import 'package:app/business/operations/fraction.dart';
import 'package:app/business/operations/restriction.dart';
import 'package:app/business/operations/target_function.dart';
import 'package:app/widgets/layout/app_layout.dart';
import 'package:app/widgets/primitives/function/function_row.dart';
import 'package:app/widgets/primitives/restriction/restriction_row.dart';
import 'package:flutter/material.dart';

class DualSimplexMethod extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DualSimplexState();
  }
}

class _DualSimplexState extends State<DualSimplexMethod> {
  TargetFunction _targetFunction;
  List<Restriction> _restrictions;

  _DualSimplexState() {
    this._targetFunction = _createDefaultFunction();
    this._restrictions = _createDefaultRestrictions();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return AppLayout(
      title: 'Dual simplex method',
      content: Column(
        children: <Widget>[
          _CardWrapper(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FunctionRow(
                  targetFunction: _targetFunction,
                ),
                Divider(),
                ..._restrictions
                    .map((x) => RestrictionRow(
                          restriction: x,
                          variableLetter: _targetFunction.variableLetter,
                        ))
                    .toList(),
                Divider(),
                Center(
                  child: RaisedButton(
                    onPressed: () {},
                    child: Text(
                      'Solve',
                      style: theme.accentTextTheme.button,
                    ),
                    color: theme.accentColor,
                  ),
                ),
              ],
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

  List<Restriction> _createDefaultRestrictions() {
    return <Restriction>[
      Restriction(
        coefficients: [
          Fraction.fromNumber(1),
          Fraction.fromNumber(-2),
        ],
        comparison: ExpressionComparison.LowerOrEqual,
        freeMember: Fraction.fromNumber(4),
      ),
      Restriction(
        coefficients: [
          Fraction.fromNumber(3),
          Fraction.fromNumber(-1),
        ],
        comparison: ExpressionComparison.LowerOrEqual,
        freeMember: Fraction.fromNumber(-1),
      ),
    ];
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
            margin: EdgeInsets.all(12),
            elevation: 12,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: _child,
            ),
          ),
        ),
      ],
    );
  }
}
