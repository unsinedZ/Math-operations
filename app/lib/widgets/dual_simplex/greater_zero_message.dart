import 'package:app/business/operations/entities/target_function.dart';
import 'package:app/widgets/dual_simplex/comment_info.dart';
import 'package:flutter/material.dart';

class GreaterZeroMessage extends StatelessWidget {
  final TargetFunction targetFunction;

  const GreaterZeroMessage({
    Key key,
    @required this.targetFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String indices =
        List.generate(this.targetFunction.coefficients.length, (i) => i + 1)
            .join(', ');
    return CommentInfo(
      comment: 'xᵢ ≥ 0, i = $indices.',
      addDivider: false,
    );
  }
}
