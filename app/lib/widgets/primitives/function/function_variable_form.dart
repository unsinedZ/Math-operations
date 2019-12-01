import 'package:app/business/operations/fraction.dart';
import 'package:app/business/operations/variable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FunctionVariableForm extends StatefulWidget {
  final Variable _variable;
  final ValueChanged<Fraction> onValueChanged;

  const FunctionVariableForm({
    Key key,
    @required Variable variable,
    @required ValueChanged<Fraction> onValueChanged,
  })  : this._variable = variable,
        this.onValueChanged = onValueChanged,
        super(key: key);

  @override
  _State createState() => _State(_variable);
}

class _State extends State<FunctionVariableForm> {
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
            RaisedButton(
              onPressed: _onSave,
              child: Text(
                'Save',
                style: theme.accentTextTheme.button,
              ),
              color: theme.accentColor,
            ),
          ],
        ),
      ),
    );
  }

  void _onSave() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      widget.onValueChanged(_variable.value);
      Navigator.of(context).pop();
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
