import 'package:app/widgets/primitives/accent_button.dart';
import 'package:flutter/material.dart';

import 'variables_selector.dart';

class IntegersForm extends StatefulWidget {
  final Map<String, bool> selection;
  final ValueChanged<Map<String, bool>> onSelectionChanged;

  IntegersForm({
    Key key,
    @required this.selection,
    @required this.onSelectionChanged,
  }) : super(key: key);

  @override
  _IntegersFormState createState() => _IntegersFormState();
}

class _IntegersFormState extends State<IntegersForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, bool> _currentSelection;

  @override
  void initState() {
    _currentSelection = widget.selection;

    super.initState();
  }

  @override
  void didUpdateWidget(IntegersForm oldWidget) {
    if (widget.selection != oldWidget.selection) {
      _currentSelection = widget.selection;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            VariablesSelector(
              title: 'Select integer variables:',
              variableSelection: _currentSelection,
              onChangeSelection: (variableName, newSelection) {
                setState(() {
                  _currentSelection[variableName] = newSelection;
                });
              },
            ),
            Divider(),
            Center(
              child: AccentButton(
                text: 'Ok',
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    widget.onSelectionChanged(_currentSelection);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
