import 'package:app/business/operations/task_adjusters/extremum_to_minimum_adjuster.dart';
import 'simplex_restrictions_free_members_adjuster.dart';
import 'simplex_restrictions_to_equalities_adjuster.dart';
import 'composite_adjuster.dart';

class SimplexAdjuster extends CompositeAdjuster {
  const SimplexAdjuster()
      : super(
          const [
            ExtremumToMinimumAdjuster(),
            SimplexRestrictionsFreeMemberAdjuster(),
            SimplexRestrictionsToEqualitiesAdjuster(),
          ],
        );
}
