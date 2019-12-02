import 'extremum.dart';
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

  LinearTask changeTargetFunction(TargetFunction newTargetFunction) {
    return LinearTask(
      targetFunction: newTargetFunction,
      restrictions: this.restrictions,
      extremum: this.extremum,
    );
  }

  LinearTask changeRestrictions(List<Restriction> newRestrictions) {
    return LinearTask(
      targetFunction: this.targetFunction,
      restrictions: newRestrictions,
      extremum: this.extremum,
    );
  }
  
  LinearTask changeExtremum(Extremum newExtremum) {
    return LinearTask(
      targetFunction: this.targetFunction,
      restrictions: this.restrictions,
      extremum: newExtremum,
    );
  }
}