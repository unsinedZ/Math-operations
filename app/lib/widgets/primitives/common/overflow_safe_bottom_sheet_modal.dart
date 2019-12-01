import 'package:flutter/material.dart';

class OverflowSafeBottomSheetModal {
  final WidgetBuilder contentBuilder;

  OverflowSafeBottomSheetModal(this.contentBuilder);

  void show(BuildContext context) {
    MediaQueryData query = MediaQuery.of(context);
    bool isScrollControlled = query.orientation == Orientation.landscape;
    showModalBottomSheet(
      context: context,
      isScrollControlled: isScrollControlled,
      builder: (x) => _OptionalConstraint(
        shouldApplyConstraint: isScrollControlled,
        child: contentBuilder(x),
      ),
    );
  }
}

class _OptionalConstraint extends StatelessWidget {
  final Widget child;
  final bool shouldApplyConstraint;

  const _OptionalConstraint({
    Key key,
    @required this.child,
    @required this.shouldApplyConstraint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!shouldApplyConstraint) return child;

    MediaQueryData query = MediaQuery.of(context);
    BoxConstraints boxConstraints = BoxConstraints(
      maxHeight: query.size.height * .9,
    );
    return ConstrainedBox(
      constraints: boxConstraints,
      child: child,
    );
  }
}
