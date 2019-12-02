import 'package:app/business/operations/variable.dart';
import 'package:app/widgets/dual_simplex/variable_info.dart';
import 'package:app/widgets/primitives/base_text.dart';
import 'package:app/widgets/primitives/overflow_safe_bottom_sheet_modal.dart';
import 'package:flutter/material.dart';

import 'variable_form.dart';

class VariableEditor extends StatelessWidget {
  final Variable variable;
  final ValueChanged<Variable> onChanged;
  final bool showSignForPositive;

  const VariableEditor({
    Key key,
    @required this.variable,
    @required this.onChanged,
    this.showSignForPositive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String text = showSignForPositive || variable.value.isNegative()
        ? variable.value.sign
        : '';
    return Row(
      children: <Widget>[
        BaseText(text),
        VariableInfo(
          name: variable.name,
          value: variable.value.abs(),
          onPressed: () => _onFunctionVariablePressed(context),
        ),
      ],
    );
  }

  void _onFunctionVariablePressed(BuildContext context) {
    OverflowSafeBottomSheetModal(
      (_) => VariableForm(
        variable: variable,
        onChanged: onChanged,
      ),
    ).show(context);
  }
}
