import 'package:app/business/operations/linear_task_context.dart';
import 'package:app/business/operations/task_adjusters/linear_task_adjuster.dart';

class CompositeAdjuster implements LinearTaskAdjuster {
  final List<LinearTaskAdjuster> _adjusters;

  const CompositeAdjuster(this._adjusters);

  List<LinearTaskContext> getAdjustmentSteps(LinearTaskContext context) {
    return _generateAdjustmentSteps(context).toList();
  }

  Iterable<LinearTaskContext> _generateAdjustmentSteps(
    LinearTaskContext task,
  ) sync* {
    for (LinearTaskAdjuster adjuster in _adjusters) {
      List<LinearTaskContext> adjusted = adjuster.getAdjustmentSteps(task);
      for (LinearTaskContext adjustedTask in adjusted) {
        yield adjustedTask;
      }
    }
  }
}
