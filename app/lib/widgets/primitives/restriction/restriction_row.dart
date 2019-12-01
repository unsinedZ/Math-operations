import 'package:app/business/operations/restriction.dart';
import 'package:flutter/material.dart';

class RestrictionRow extends StatelessWidget {
  final Restriction restriction;

  const RestrictionRow({
    Key key,
    @required this.restriction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(8),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _createRowContent(context),
      ),
    );
  }

  List<Widget> _createRowContent(BuildContext context) {
    return <Widget>[
      
    ];
  }
}
