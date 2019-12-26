import 'package:app/business/operations/entities/fraction.dart';
import 'package:app/business/operations/entities/variable.dart';
import 'package:app/business/validation/not_zero_validator.dart';
import 'package:app/business/validation/required_validator.dart';
import 'package:app/business/validation/validator.dart';
import 'package:app/widgets/primitives/accent_button.dart';
import 'package:app/widgets/primitives/base_text.dart';
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
  int _numerator;
  int _denominator;

  Validator _numeratorValidator;
  Validator _denominatorValidator;

  _State(this._variable)
      : this._numerator = _variable.value.numerator,
        this._denominator = _variable.value.denominator;

  @override
  void initState() {
    _numeratorValidator = RequiredValidator();
    _denominatorValidator = Validator.combine(
      [
        RequiredValidator(),
        NotZeroValidator(),
      ],
    );
    super.initState();
  }

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _FractionPartInput(
                  label: 'Numerator',
                  initialValue: _numerator,
                  onValueChanged: (x) {
                    setState(() {
                      _numerator = x;
                    });
                  },
                  validator: _numeratorValidator.validate,
                ),
                SizedBox(
                  height: 80,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: BaseText('/'),
                      ),
                    ],
                  ),
                ),
                _FractionPartInput(
                  label: 'Denominator',
                  allowZero: false,
                  initialValue: _denominator,
                  onValueChanged: (x) {
                    setState(() {
                      _denominator = x;
                    });
                  },
                  validator: _denominatorValidator.validate,
                ),
              ],
            ),
            Center(
              child: AccentButton(
                text: 'Save',
                onPressed: _onSave,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSave() {
    if (_formKey.currentState.validate()) {
      widget.onChanged(
        _variable = _variable.changeValue(
          Fraction.createConst(
            numerator: _numerator,
            denominator: _denominator,
          ),
        ),
      );
      widget.onSave();
    }
  }
}

class _FractionPartInput extends StatelessWidget {
  final String label;
  final int initialValue;
  final ValueChanged<int> onValueChanged;
  final bool allowZero;
  final FormFieldValidator<String> validator;

  const _FractionPartInput({
    Key key,
    @required this.label,
    @required this.initialValue,
    @required this.onValueChanged,
    this.allowZero = true,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RegExp numberRegex = RegExp(r'^-?[0-9]*$');
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
        validator: validator,
      ),
    );
  }
}
