import 'package:app/widgets/primitives/base_text.dart';
import 'package:flutter/material.dart';

class CommentInfo extends StatelessWidget {
  final String comment;
  final bool addDivider;

  const CommentInfo({
    Key key,
    @required this.comment,
    this.addDivider = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: comment != null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Visibility(
            visible: addDivider,
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BaseText(comment),
          ),
        ],
      ),
    );
  }
}
