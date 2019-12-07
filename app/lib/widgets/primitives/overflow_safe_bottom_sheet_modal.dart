import 'package:flutter/material.dart';

class OverflowSafeBottomSheetModal {
  final WidgetBuilder contentBuilder;

  OverflowSafeBottomSheetModal(this.contentBuilder);

  void show(BuildContext context) {
    MediaQueryData query = MediaQuery.of(context);
    bool isScrollControlled = query.orientation == Orientation.landscape;
    BoxConstraints boxConstraints = BoxConstraints(
      maxHeight: query.size.height * .9,
    );
    showModalBottomSheet(
      context: context,
      isScrollControlled: isScrollControlled,
      builder: (x) => ConstrainedBox(
        constraints: boxConstraints,
        child: contentBuilder(x),
      ),
    );
  }
}
