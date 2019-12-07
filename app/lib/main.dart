import 'package:flutter/material.dart';

import 'business/operations/dual_simplex_method_strategy.dart';
import 'business/operations/task_adjusters/dual_simplex_adjuster.dart';
import 'widgets/screens/simplex_method.dart';
import 'widgets/screens/task_selector.dart';

void main() => runApp(MmdoZlpApp());

class MmdoZlpApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskSelector(),
      routes: <String, WidgetBuilder>{
        // '/SimplexMethod': (context) => SimplexMethod(
        //       taskAdjuster: SimplexAdjuster(),
        //       simplexMethodStrategy: SimplexMethodStrategy(),
        //     ),
        '/DualSimplexMethod': (context) => SimplexMethod(
              taskAdjuster: DualSimplexAdjuster(),
              simplexMethodStrategy: DualSimplexMethodStrategy(),
            ),
      },
    );
  }
}
