import 'package:app/business/operations/linear_task_context.dart';

abstract class LinearTaskAdjuster {
  List<LinearTaskContext> getAdjustmentSteps(LinearTaskContext context);
}