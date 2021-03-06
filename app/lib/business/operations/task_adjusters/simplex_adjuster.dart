import 'package:app/business/operations/task_adjusters/extremum_to_minimum_adjuster.dart';
import 'composite_adjuster.dart';
import 'restrictions/equal_restrictions_adjuster.dart';
import 'restrictions/greater_equal_restrictions_adjuster.dart';
import 'restrictions/lower_equal_restrictions_adjuster.dart';
import 'restrictions/positive_free_member_adjuster.dart';

class SimplexAdjuster extends CompositeAdjuster {
  const SimplexAdjuster()
      : super(
          const [
            ExtremumToMinimumAdjuster(),
            PositiveFreeMemberAdjuster(),
            LowerEqualRestrictionsAdjuster(),
            GreaterEqualRestrictionsAdjuster(),
            EqualRestrictionsAdjuster(),
          ],
        );
}
