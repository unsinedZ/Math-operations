import 'package:app/widgets/layout/app_layout.dart';
import 'package:flutter/material.dart';

class TaskSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppLayout(
      ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            ListTile(
              leading: Icon(Icons.table_chart),
              title: Text('Dual simplex method'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () => Navigator.pushNamed(context, '/DualSimplex'),
              onLongPress: () => {},
            ),
            ListTile(
              leading: Icon(Icons.arrow_downward),
              title: Text('Yet not implemented...'),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
          ],
        ).toList(),
      ),
    );
  }
}
