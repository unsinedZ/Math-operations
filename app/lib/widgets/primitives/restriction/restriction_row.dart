import 'package:app/business/operations/fraction.dart';
import 'package:app/business/operations/restriction.dart';
import 'package:app/business/operations/variable.dart';
import 'package:app/widgets/primitives/common/base_button.dart';
import 'package:app/widgets/primitives/common/base_text.dart';
import 'package:app/widgets/primitives/common/variable.dart' as primitive;
import 'package:flutter/material.dart';

class RestrictionRow extends StatefulWidget {
  final String _variableLetter;
  final Restriction _restriction;

  const RestrictionRow({
    Key key,
    @required Restriction restriction,
    @required String variableLetter,
  })  : this._restriction = restriction,
        this._variableLetter = variableLetter,
        super(key: key);

  @override
  _RestrictionRowState createState() =>
      _RestrictionRowState(_restriction, _variableLetter);
}

class _RestrictionRowState extends State<RestrictionRow> {
  Restriction _restriction;
  String _variableLetter;
  List<Variable> _variables;

  _RestrictionRowState(Restriction restriction, String variableLetter) {
    this._restriction = restriction;
    this._variableLetter = variableLetter;

    int index = 0;
    this._variables = restriction.coefficients
        .map((x) => Variable(
              name: '$variableLetter${index + 1}',
              value: x,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(8),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _createRowContent(context),
      ),
    );
  }

  List<Widget> _createRowContent(BuildContext context) {
    int index = 0;
    return <Widget>[
      ..._variables
          .map((x) => _createVariable(
                context: context,
                variable: x,
                showSignForPositive: index++ > 0,
              ))
          .reduce((x, y) => x..addAll(y)),
      _createComparisonSign(),
      _createFreeMember(_restriction.freeMember),
    ];
  }

  List<Widget> _createVariable({
    BuildContext context,
    Variable variable,
    bool showSignForPositive = false,
  }) {
    var result = <Widget>[];
    if (showSignForPositive || variable.value.isNegative()) {
      result.add(BaseText(variable.value.isNegative() ? '-' : '+'));
    }

    result.add(primitive.Variable(
      name: variable.name,
      value: variable.value.abs(),
      onPressed: () => _onVariablePressed(context, variable),
    ));
    return result;
  }

  Widget _createComparisonSign() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 4,
      ),
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButton(
          value: _restriction.comparison,
          items: ExpressionComparison.values
              .map((x) => DropdownMenuItem(
                    value: x,
                    child:
                        BaseText(ExpressionComparisonStringifier.stringify(x)),
                  ))
              .toList(),
          onChanged: _onComparisonChanged,
        ),
      ),
    );
  }

  void _onComparisonChanged(ExpressionComparison comparison) {
    setState(() {
      _restriction = _restriction.changeComparison(comparison);
    });
  }

  Widget _createFreeMember(Fraction freeMember) {
    return BaseButton(
      text: freeMember.toString(),
      onPressed: () {},
    );
  }

  void _onVariablePressed(BuildContext context, Variable variable) {}
}
