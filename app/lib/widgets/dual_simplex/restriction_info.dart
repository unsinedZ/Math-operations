import 'package:app/business/operations/entities/restriction.dart';
import 'package:app/business/operations/entities/variable.dart';
import 'package:app/widgets/editors/free_member_editor.dart';
import 'package:app/widgets/editors/variable_editor.dart';
import 'package:app/widgets/primitives/base_icon.dart';
import 'package:flutter/material.dart';

import 'comparison_info.dart';

class RestrictionInfo extends StatefulWidget {
  final String variableLetter;
  final Restriction restriction;
  final ValueChanged<Restriction> onChanged;
  final bool isReadOnly;
  final bool hideZeroCoefficients;
  final VoidCallback onRemoveClick;
  final bool isRemovable;

  const RestrictionInfo({
    Key key,
    @required this.variableLetter,
    @required this.restriction,
    @required this.onChanged,
    @required this.onRemoveClick,
    this.isRemovable = true,
    this.isReadOnly = false,
    this.hideZeroCoefficients = false,
  }) : super(key: key);

  @override
  _RestrictionInfoState createState() => _RestrictionInfoState();
}

class _RestrictionInfoState extends State<RestrictionInfo> {
  List<Variable> _variables;

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void didUpdateWidget(RestrictionInfo oldWidget) {
    if (oldWidget.restriction != widget.restriction ||
        oldWidget.variableLetter != widget.variableLetter) {
      _init();
    }

    super.didUpdateWidget(oldWidget);
  }

  void _init() {
    int index = 0;
    this._variables = widget.restriction.coefficients
        .map(
          (x) => Variable(
            name: '${widget.variableLetter}${++index}',
            value: x,
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    int index = 0;
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(8),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                ..._variables
                    .where(
                      (x) =>
                          !widget.hideZeroCoefficients ||
                          !x.value.equalsNumber(0),
                    )
                    .map(
                      (x) => VariableEditor(
                        variable: x,
                        onChanged: _checkReadOnly(
                          (v) => _onVariableChanged(x, v),
                        ),
                        showSignForPositive: index++ > 0,
                      ),
                    ),
                Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 4,
                    ),
                    child: ComparisonInfo(
                      comparison: widget.restriction.comparison,
                      onChanged: _checkReadOnly((x) => widget.onChanged(
                            widget.restriction.changeComparison(x),
                          )),
                    )),
                FreeMemberEditor(
                  freeMember: widget.restriction.freeMember,
                  onChanged: _checkReadOnly((x) {
                    widget.onChanged(
                      widget.restriction.changeFreeMember(x),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
        Flexible(
          flex: 0,
          child: Visibility(
            visible: widget.isRemovable,
            child: BaseIcon(
              icon: Icons.delete_outline,
              onPressed: widget.onRemoveClick,
            ),
          ),
        ),
      ],
    );
  }

  void _onVariableChanged(Variable variable, Variable newVariable) {
    int variableIndex = _variables.indexOf(variable);
    int index = 0;
    widget.onChanged(
      widget.restriction.changeCoefficients(
        widget.restriction.coefficients.map((x) {
          if (index++ == variableIndex) {
            return newVariable.value;
          }

          return x;
        }).toList(),
      ),
    );
  }

  T _checkReadOnly<T>(T value) {
    if (widget.isReadOnly) {
      return null;
    }

    return value;
  }
}
