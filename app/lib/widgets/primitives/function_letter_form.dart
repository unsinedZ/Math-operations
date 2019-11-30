import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class FunctionLetterForm extends StatefulWidget {
  final ValueChanged<num> onValueChanged;
  final num initialValue;

  FunctionLetterForm({
    Key key,
    @required this.initialValue,
    @required this.onValueChanged,
  }) : super(key: key);

  @override
  _FunctionLetterFormState createState() => _FunctionLetterFormState(initialValue);
}

class _FunctionLetterFormState extends State<FunctionLetterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  num _argumentsCount;

  _FunctionLetterFormState(int initialValue) : this._argumentsCount = initialValue;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Form(
      key: _formKey,
      child: Container(
        child: Column(
          children: <Widget>[
            Text(
              'Select number of arguments:',
              style: theme.textTheme.title,
            ),
            NumberPicker.integer(
              initialValue: _argumentsCount ?? 1,
              minValue: 1,
              maxValue: 10,
              onChanged: (num newValue) {
                setState(() {
                  _argumentsCount = newValue;
                });
              },
            ),
            RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  widget.onValueChanged(_argumentsCount);
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                'Save',
                style: theme.accentTextTheme.button,
              ),
              color: theme.accentColor,
            ),
          ],
        ),
        margin: EdgeInsets.all(16),
      ),
    );
  }
}
