import 'package:flutter/foundation.dart';

class Fraction {
  final int numerator;
  final int denominator;

  String get sign => isNegative() ? '-' : '+';

  const Fraction._({
    @required int numerator,
    @required int denominator,
  })  : this.numerator = numerator,
        this.denominator = denominator;

  const Fraction.fromNumber(int number)
      : this._(
          numerator: number,
          denominator: 1,
        );

  static Fraction createConst({
    @required int numerator,
    @required int denominator,
  }) {
    if (denominator == 0) throw Exception('Dividing by 0 is forbidden.');

    if (denominator < 0) {
      numerator *= -1;
      denominator *= -1;
    }

    int gcd = _greatestCommonDivisor(numerator.abs(), denominator.abs());
    return Fraction._(
      numerator: numerator ~/ gcd,
      denominator: denominator ~/ gcd,
    );
  }

  bool isNegative() {
    return numerator < 0 && denominator > 0 || numerator > 0 && denominator < 0;
  }

  bool isPositive() {
    return numerator < 0 && denominator < 0 || numerator > 0 && denominator > 0;
  }

  Fraction abs() {
    return Fraction._(
      numerator: numerator.abs(),
      denominator: denominator.abs(),
    );
  }

  Fraction invert() {
    return Fraction.createConst(
      numerator: this.denominator,
      denominator: this.numerator,
    );
  }

  bool equalsNumber(int number) {
    return this == Fraction.fromNumber(number);
  }

  Fraction operator *(Fraction other) {
    if (other == null) throw Exception('Can not operate with `null`.');

    return Fraction.createConst(
      numerator: this.numerator * other.numerator,
      denominator: this.denominator * other.denominator,
    );
  }

  Fraction operator /(Fraction other) {
    if (other == null) throw Exception('Can not operate with `null`.');

    return this * other.invert();
  }

  Fraction operator +(Fraction other) {
    if (other == null) throw Exception('Can not operate with `null`.');

    return Fraction.createConst(
      numerator: this.numerator * other.denominator +
          other.numerator * this.denominator,
      denominator: this.denominator * other.denominator,
    );
  }

  Fraction operator -(Fraction other) {
    if (other == null) throw Exception('Can not operate with `null`.');

    return this + other * const Fraction.fromNumber(-1);
  }

  bool operator >(Fraction other) {
    return this.numerator * other.denominator -
            this.denominator * other.numerator >
        0;
  }

  bool operator <(Fraction other) {
    return this.numerator * other.denominator -
            this.denominator * other.numerator <
        0;
  }

  bool operator >=(Fraction other) {
    return !(this < other);
  }

  bool operator <=(Fraction other) {
    return !(this > other);
  }

  @override
  bool operator ==(other) {
    if (other == null) return false;

    if (!(other is Fraction)) return false;

    return this.numerator == other.numerator &&
        this.denominator == other.denominator;
  }

  @override
  int get hashCode {
    int code = super.hashCode;
    code += 11 * this.numerator.hashCode;
    code += 13 * this.denominator.hashCode;
    return code;
  }

  static int _greatestCommonDivisor(int number1, int number2) {
    if (number1 < 0) number1 *= -1;

    if (number2 < 0) number2 *= -1;

    if (number2 == 0) return number1;

    return _greatestCommonDivisor(number2, number1 % number2);
  }

  @override
  String toString() {
    if (numerator == 0) return '0';

    if (denominator == 1) return numerator.toString();

    return '($numerator/$denominator)';
  }
}
