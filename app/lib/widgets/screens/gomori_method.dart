import 'package:app/business/operations/entities/fraction.dart';
import 'package:app/business/operations/entities/variable.dart';
import 'package:app/widgets/dual_simplex/discrete_task_info.dart';
import 'package:app/widgets/layout/app_layout.dart';
import 'package:app/widgets/primitives/base_card.dart';
import 'package:flutter/material.dart';

class GomoriMethod extends StatefulWidget {
  final String title;

  const GomoriMethod({Key key, this.title}) : super(key: key);

  @override
  _GomoriMethodState createState() => _GomoriMethodState();
}

class _GomoriMethodState extends State<GomoriMethod> {
  Map<Variable, bool> _variableSelection;

  @override
  void initState() {
    _variableSelection = <Variable, bool>{
      Variable(
        name: 'x1',
        value: Fraction.fromNumber(1),
      ): false,
      Variable(
        name: 'x2',
        value: Fraction.fromNumber(1),
      ): false,
      Variable(
        name: 'x3',
        value: Fraction.fromNumber(1),
      ): false,
    };

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: widget.title,
      content: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: 12,
        ),
        scrollDirection: Axis.vertical,
        child: BaseCard(
          child: DiscreteTaskInfo(
            variableSelection: _variableSelection,
            onChangeSelection: (variable, newSelection) {
              setState(() {
                _variableSelection[variable] = newSelection;
              });
            },
          ),
        ),
      ),
    );
  }
}
