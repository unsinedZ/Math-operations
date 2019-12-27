import 'package:app/business/operations/entities/variable.dart';
import 'package:app/widgets/dual_simplex/variable_info.dart';
import 'package:app/widgets/primitives/base_text.dart';
import 'package:app/widgets/primitives/overflow_safe_bottom_sheet_modal.dart';
import 'package:flutter/material.dart';

import 'variable_form.dart';

class VariableEditor extends StatelessWidget {
  final Variable variable;
  final ValueChanged<Variable> onChanged;
  final bool showSignForPositive;
  final bool showName;

  const VariableEditor({
    Key key,
    @required this.variable,
    @required this.onChanged,
    this.showSignForPositive = false,
    this.showName = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Visibility(
          visible: showSignForPositive || variable.value.isNegative(),
          child: BaseText(variable.value.sign),
        ),
        VariableInfo(
          name: showName ? variable.name : '',
          value: variable.value.abs(),
          onPressed: () => _onPressed(context),
        ),
      ],
    );
  }

  void _onPressed(BuildContext context) {
    if (onChanged == null) {
      return;
    }

    OverflowSafeBottomSheetModal(
      (c) => VariableForm(
        variable: variable,
        onChanged: onChanged,
        onSave: () => Navigator.of(c).pop(),
      ),
    ).show(context);
  }
}
