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
}

enum ExpressionComparison {
  LowerOrEqual,
  GreaterOrEqual,
  Equal,
}