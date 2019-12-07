import 'package:app/business/operations/restriction.dart';
import 'package:app/widgets/primitives/base_text.dart';
import 'package:flutter/material.dart';

class ComparisonInfo extends StatelessWidget {
  final ExpressionComparison comparison;
  final ValueChanged<ExpressionComparison> onChanged;

  const ComparisonInfo({
    Key key,
    @required this.comparison,
    @required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      alignedDropdown: true,
      child: DropdownButton(
        value: comparison,
        items: ExpressionComparison.values
            .map((x) => DropdownMenuItem(
                  value: x,
                  child: BaseText(
                    ExpressionComparisonStringifier.stringify(x),
                  ),
                ))
            .toList(),
        onChanged: onChanged,
        disabledHint: BaseText(
          ExpressionComparisonStringifier.stringify(comparison),
        ),
      ),
    );
  }
}
