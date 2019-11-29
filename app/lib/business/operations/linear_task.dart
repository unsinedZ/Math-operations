import 'target_function.dart';
import 'restriction.dart';

class LinearTask {
  final TargetFunction targetFunction;
  final List<Restriction> restrictions;
  final Extremum extremum;

  const LinearTask({
    this.targetFunction,
    this.extremum,
    this.restrictions,
  });
}

enum Extremum {
  min,
  max,
}