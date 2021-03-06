import 'fraction.dart';

class TargetFunction {
  static const String DEFAULT_FUNCTION_LETTER = 'f';
  static const String DEFAULT_VARIABLE_LETTER = 'x';

  final String functionLetter;
  final String variableLetter;
  final List<Fraction> coefficients;
  final Fraction freeMember;

  const TargetFunction({
    this.functionLetter = DEFAULT_FUNCTION_LETTER,
    this.variableLetter = DEFAULT_VARIABLE_LETTER,
    this.coefficients,
    this.freeMember = const Fraction.fromNumber(0),
  });

  TargetFunction changeCoefficients(List<Fraction> newCoefficients) {
    return TargetFunction(
      functionLetter: this.functionLetter,
      variableLetter: this.variableLetter,
      coefficients: newCoefficients,
      freeMember: this.freeMember,
    );
  }

  TargetFunction changeVariableLetter(String newLetter) {
    return TargetFunction(
      functionLetter: this.functionLetter,
      variableLetter: newLetter,
      coefficients: this.coefficients,
      freeMember: this.freeMember,
    );
  }
}
