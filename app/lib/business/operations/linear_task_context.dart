import 'package:app/business/operations/linear_task.dart';
import 'package:flutter/foundation.dart';

class LinearTaskContext {
  final LinearTask linearTask;
  final List<int> additionalVariableIndices;
  final List<int> artificialVariableIndices;

  LinearTaskContext({
    @required this.linearTask,
    @required this.additionalVariableIndices,
    @required this.artificialVariableIndices,
  });
}
