import 'package:app/business/operations/fraction.dart';
import 'package:flutter/material.dart';

import 'base_button.dart';

class FreeMember extends StatelessWidget {
  final Fraction freeMember;

  const FreeMember({
    Key key,
    this.freeMember,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseButton(
      text: freeMember.toString(),
      onPressed: () {},
    );
  }
}
