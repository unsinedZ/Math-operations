import 'package:flutter/material.dart';

class EmptyTableCell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 24,
        ),
        child: Text(' '),
      ),
    );
  }
}
