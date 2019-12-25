import 'package:app/widgets/layout/app_layout.dart';
import 'package:flutter/material.dart';

class TaskSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppLayout(
      content: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            ListTile(
              leading: Icon(Icons.table_chart),
              title: Text('Simplex method'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () => Navigator.pushNamed(context, '/SimplexMethod'),
              onLongPress: () => {},
            ),
            ListTile(
              leading: Icon(Icons.table_chart),
              title: Text('Dual simplex method'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () => Navigator.pushNamed(context, '/DualSimplexMethod'),
              onLongPress: () => {},
            ),
          ],
        ).toList(),
      ),
    );
  }
}
