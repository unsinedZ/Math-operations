import 'package:app/business/operations/strategies/gomory_first_strategy.dart';
import 'package:app/widgets/screens/gomori_method.dart';
import 'package:flutter/material.dart';

import 'business/operations/strategies/dual_simplex_method_strategy.dart';
import 'business/operations/strategies/simplex_method_strategy.dart';
import 'business/operations/task_adjusters/dual_simplex_adjuster.dart';
import 'business/operations/task_adjusters/simplex_adjuster.dart';
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
        '/SimplexMethod': (context) => SimplexMethod(
              title: "Simplex method",
              taskAdjuster: SimplexAdjuster(),
              simplexMethodStrategy: const SimplexMethodStrategy(),
            ),
        '/DualSimplexMethod': (context) => SimplexMethod(
              title: "Dual simplex method",
              taskAdjuster: const DualSimplexAdjuster(),
              simplexMethodStrategy: const DualSimplexMethodStrategy(),
            ),
        '/FirstGomoriMethod': (context) => GomoriMethod(
              title: 'Gomori method #1',
              strategy: const GomoriFirstStrategy(),
            ),
      },
    );
  }
}
