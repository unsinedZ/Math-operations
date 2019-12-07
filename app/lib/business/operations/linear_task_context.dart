import 'package:app/business/operations/linear_task.dart';
import 'package:flutter/foundation.dart';

class LinearTaskContext {
  final LinearTask linearTask;
  final List<int> additionalVariableIndices;
  final List<int> artificialVariableIndices;

  LinearTaskContext({
    @required this.linearTask,
    this.additionalVariableIndices,
    this.artificialVariableIndices,
  });

  LinearTaskContext changeLinearTask(LinearTask newTask) {
    return LinearTaskContext(
      linearTask: newTask,
      additionalVariableIndices: this.additionalVariableIndices,
      artificialVariableIndices: this.artificialVariableIndices,
    );
  }

  LinearTaskContext changeAdditionalVariableIndexes(List<int> newIndexes) {
    return LinearTaskContext(
      linearTask: this.linearTask,
      additionalVariableIndices: newIndexes,
      artificialVariableIndices: this.artificialVariableIndices,
    );
  }

  LinearTaskContext changeArtificialVariableIndexes(List<int> newIndexes) {
    return LinearTaskContext(
      linearTask: this.linearTask,
      additionalVariableIndices: this.additionalVariableIndices,
      artificialVariableIndices: newIndexes,
    );
  }
}
