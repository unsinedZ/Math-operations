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

  Restriction changeFreeMember(Fraction newFreeMember) {
    return Restriction(
      coefficients: this.coefficients,
      freeMember: newFreeMember,
      comparison: this.comparison,
    );
  }
}

enum ExpressionComparison {
  LowerOrEqual,
  GreaterOrEqual,
  Equal,
}

extension ExpressionComparisonExtension on ExpressionComparison {
  stringify() {
    switch (this) {
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

  invert() {
    if (this == ExpressionComparison.GreaterOrEqual)
      return ExpressionComparison.LowerOrEqual;

    if (this == ExpressionComparison.LowerOrEqual)
      return ExpressionComparison.GreaterOrEqual;

    return this;
  }
}
