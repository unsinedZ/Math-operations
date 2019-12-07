import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class ScrollIntegerEditor extends StatefulWidget {
  final String text;
  final int initialValue;
  final ValueChanged<int> onChanged;
  final int minValue;
  final int maxValue;

  ScrollIntegerEditor({
    Key key,
    @required this.text,
    @required this.initialValue,
    @required this.onChanged,
    @required this.minValue,
    @required this.maxValue,
  }) : super(key: key);

  @override
  _ScrollIntegerEditorState createState() => _ScrollIntegerEditorState();
}

class _ScrollIntegerEditorState extends State<ScrollIntegerEditor> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int _argumentsCount;

  @override
  void initState() {
    _argumentsCount = widget.initialValue;
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
              widget.text,
              style: theme.textTheme.title,
            ),
            NumberPicker.integer(
              initialValue: _argumentsCount,
              minValue: widget.minValue,
              maxValue: widget.maxValue,
              onChanged: (num newValue) {
                setState(() {
                  _argumentsCount = newValue;
                });
              },
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
      widget.onChanged(_argumentsCount);
      Navigator.of(context).pop();
    }
  }
}
