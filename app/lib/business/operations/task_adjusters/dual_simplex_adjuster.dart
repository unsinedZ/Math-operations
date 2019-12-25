import 'composite_adjuster.dart';
import 'extremum_to_minimum_adjuster.dart';
import 'dual_simplex_restrictions_to_equalities_adjuster.dart';
import 'dual_simplex_basis_creator.dart';

class DualSimplexAdjuster extends CompositeAdjuster {
  const DualSimplexAdjuster()
      : super(
          const [
            ExtremumToMinimumAdjuster(),
            DualSimplexRestrictionsToEqualitiesAdjuster(),
            DualSimplexBasisCreator(),
          ],
        );
}
