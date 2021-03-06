import 'package:app/business/operations/entities/fraction.dart';
import 'package:app/business/operations/entities/variable.dart';
import 'package:app/widgets/editors/variable_editor.dart';
import 'package:flutter/material.dart';

class FreeMemberEditor extends StatelessWidget {
  final Fraction freeMember;
  final ValueChanged<Fraction> onChanged;

  const FreeMemberEditor({
    Key key,
    @required this.freeMember,
    @required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Variable variable = Variable(
      name: 'free member',
      value: freeMember,
    );
    return VariableEditor(
      variable: variable,
      onChanged: onChanged == null ? null : (x) => onChanged(x.value),
      showSignForPositive: false,
      showName: false,
    );
  }
}
