import 'package:app/business/operations/fraction.dart';
import 'package:app/business/operations/variable.dart';
import 'package:app/widgets/primitives/accent_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VariableForm extends StatefulWidget {
  final Variable _variable;
  final ValueChanged<Variable> onChanged;
  final VoidCallback onSave;

  const VariableForm({
    Key key,
    @required Variable variable,
    @required this.onChanged,
    @required this.onSave,
  })  : this._variable = variable,
        super(key: key);

  @override
  _State createState() => _State(_variable);
}

class _State extends State<VariableForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Variable _variable;

  _State(this._variable);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Text(
              'Enter ${_variable.name} coefficient:',
              style: theme.textTheme.title,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _FractionPartInput(
                  label: 'Numerator',
                  initialValue: _variable.value.numerator,
                  onValueChanged: (x) {
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        _variable = _variable.changeValue(Fraction.createConst(
                          numerator: x,
                          denominator: _variable.value.denominator,
                        ));
                      });
                    }
                  },
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Text('/'),
                ),
                _FractionPartInput(
                  label: 'Denominator',
                  initialValue: _variable.value.denominator,
                  onValueChanged: (x) {
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        _variable = _variable.changeValue(Fraction.createConst(
                          numerator: _variable.value.numerator,
                          denominator: x,
                        ));
                      });
                    }
                  },
                ),
              ],
            ),
            AccentButton(
              text: 'Save',
              onPressed: _onSave,
            ),
          ],
        ),
      ),
    );
  }

  void _onSave() {
    if (_formKey.currentState.validate()) {
      widget.onChanged(_variable);
      widget.onSave();
    }
  }
}

class _FractionPartInput extends StatelessWidget {
  final String label;
  final int initialValue;
  final ValueChanged<int> onValueChanged;

  const _FractionPartInput({
    Key key,
    @required this.label,
    @required this.initialValue,
    @required this.onValueChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RegExp numberRegex = RegExp(r'^-?\d*$');
    return Container(
      width: 100,
      child: TextFormField(
        keyboardType: TextInputType.numberWithOptions(
          signed: true,
        ),
        inputFormatters: <TextInputFormatter>[
          LengthLimitingTextInputFormatter(5),
          WhitelistingTextInputFormatter(numberRegex),
        ],
        decoration: InputDecoration(
          labelText: label,
        ),
        initialValue: initialValue.toString(),
        onChanged: (x) => onValueChanged(int.parse(x)),
      ),
    );
  }
}
