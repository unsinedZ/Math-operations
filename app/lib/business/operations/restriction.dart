import 'fraction.dart';

class Restriction {
  final List<Fraction> coefficients;
  final Fraction freeMember;
  final ExpressionComparison comparison;

  const Restriction({
    this.coefficients,
    this.freeMember,
    this.comparison,
  });

  Restriction changeComparison(ExpressionComparison newComparison) {
    return Restriction(
      coefficients: this.coefficients,
      freeMember: this.freeMember,
      comparison: newComparison,
    );
  }

  Restriction changeCoefficients(List<Fraction> newCoefficients) {
    return Restriction(
      coefficients: newCoefficients,
      freeMember: this.freeMember,
      comparison: this.comparison,
    );
  }
}

enum ExpressionComparison {
  LowerOrEqual,
  GreaterOrEqual,
  Equal,
}

class ExpressionComparisonStringifier {
  static String stringify(ExpressionComparison comparison) {
    switch (comparison) {
      case ExpressionComparison.Equal:
        return '=';
      case ExpressionComparison.GreaterOrEqual:
        return '>=';
      case ExpressionComparison.LowerOrEqual:
        return '<=';
      default:
        throw Exception('Not supported.');
    }
  }
}
