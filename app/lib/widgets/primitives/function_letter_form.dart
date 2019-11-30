import 'package:flutter/material.dart';

class FunctionLetterForm extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ValueChanged<num> onValueChanged;

  FunctionLetterForm({
    Key key,
    @required this.onValueChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Form(
      key: _formKey,
      child: Container(
        child: Column(
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount of variables:',
              ),
            ),
            RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  Navigator.of(context).pop();
                }
              },
              child: Text('Save'),
              color: theme.primaryColor,
            ),
          ],
        ),
        margin: EdgeInsets.all(16),
      ),
    );
  }
}
