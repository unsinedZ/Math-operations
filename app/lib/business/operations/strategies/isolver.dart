import 'package:app/business/operations/entities/solution_status.dart';

abstract class ISolver<T> {
  bool canBeApplied(T context);
  SolutionStatus solve(T context);
}