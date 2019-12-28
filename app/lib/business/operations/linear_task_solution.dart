import 'package:flutter/foundation.dart';

import 'entities/fraction.dart';
import 'entities/solution_status.dart';
import 'entities/target_function.dart';
import 'simplex_table/simplex_table_context.dart';
import 'simplex_table/simplex_table_solution_extractor.dart';

class LinearTaskSolution {
  final SolutionStatus status;
  final String functionName;
  final String variableName;
  final List<Fraction> variableCoefficients;
  final Fraction functionValue;
  final String customMessage;

  const LinearTaskSolution._({
    @required this.status,
    @required this.functionName,
    @required this.variableName,
    @required this.variableCoefficients,
    @required this.functionValue,
    this.customMessage,
  });

  const LinearTaskSolution.message({
    @required SolutionStatus status,
    @required String customMessage,
  }) : this._(
          status: status,
          functionName: null,
          variableName: null,
          variableCoefficients: null,
          functionValue: null,
          customMessage: customMessage,
        );

  static LinearTaskSolution create(SolutionStatus status,
      TargetFunction targetFunction, SimplexTableContext context) {
    return LinearTaskSolution._(
      status: status,
      functionName: targetFunction.functionLetter,
      variableName: targetFunction.variableLetter,
      variableCoefficients:
          SimplexTableSolutionExtractor().extractSolution(context),
      functionValue: context.simplexTable.estimations.functionValue,
    );
  }

  LinearTaskSolution shortenTo(int variableCoefficientsCount) {
    return LinearTaskSolution._(
      status: this.status,
      functionName: this.functionName,
      variableName: this.variableName,
      variableCoefficients:
          this.variableCoefficients.take(variableCoefficientsCount).toList(),
      functionValue: this.functionValue,
    );
  }

  LinearTaskSolution changeFunctionValue(Fraction newValue) {
    return LinearTaskSolution._(
      status: this.status,
      functionName: this.functionName,
      variableName: this.variableName,
      variableCoefficients: this.variableCoefficients,
      functionValue: newValue,
      customMessage: this.customMessage,
    );
  }
}
