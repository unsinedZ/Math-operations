import 'package:app/business/operations/fraction.dart';
import 'package:flutter/material.dart';

class SimplexTableValue extends StatelessWidget {
  final Fraction value;

  const SimplexTableValue({
    Key key,
    @required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: Center(
        child: Text(value.toString()),
      ),
    );
  }
}
