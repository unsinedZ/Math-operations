import 'package:app/business/operations/task_adjusters/restrictions/dual_simplex_greater_equal_restrictions_adjuster.dart';
import 'package:app/business/operations/task_adjusters/restrictions/equal_restrictions_adjuster.dart';
import 'package:app/business/operations/task_adjusters/restrictions/lower_equal_restrictions_adjuster.dart';

import 'composite_adjuster.dart';
import 'extremum_to_minimum_adjuster.dart';

class DualSimplexAdjuster extends CompositeAdjuster {
  const DualSimplexAdjuster()
      : super(
          const [
            ExtremumToMinimumAdjuster(),
            DualSimplexGreaterEqualRestrictionsAdjuster(),
            LowerEqualRestrictionsAdjuster(),
            EqualRestrictionsAdjuster(),
          ],
        );
}
