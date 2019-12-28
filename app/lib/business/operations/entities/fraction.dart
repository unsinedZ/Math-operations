import 'dart:math';

import 'package:flutter/foundation.dart';

class Fraction {
  final List<Fraction> indefiniteNumberCoefficients;

  final int numerator;
  final int denominator;

  String get sign => isNegative() ? '-' : '+';

  const Fraction._({
    @required int numerator,
    @required int denominator,
    List<Fraction> indefiniteNumberCoefficients = const <Fraction>[],
  })  : this.numerator = numerator,
        this.denominator = denominator,
        this.indefiniteNumberCoefficients = indefiniteNumberCoefficients;

  const Fraction.fromNumber(int number)
      : this._(
          numerator: number,
          denominator: 1,
        );

  static Fraction createConst({
    @required int numerator,
    @required int denominator,
    List<Fraction> indefiniteNumberCoefficients = const <Fraction>[],
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

  bool isDefined() =>
      indefiniteNumberCoefficients.every((x) => x.equalsNumber(0));

  bool isNegative() {
    if (!isDefined()) {
      return indefiniteNumberCoefficients.any((x) => x.isNegative());
    }

    return numerator < 0 && denominator > 0 || numerator > 0 && denominator < 0;
  }

  bool isPositive() {
    if (!isDefined()) {
      return indefiniteNumberCoefficients.any((x) => x.isPositive());
    }

    return numerator < 0 && denominator < 0 || numerator > 0 && denominator > 0;
  }

  bool isInteger() {
    return isDefined() && denominator == 1;
  }

  int integerPart() {
    if (!isDefined()) {
      throw Exception('Fraction has indefinite coefficients.');
    }

    return numerator ~/ denominator;
  }

  Fraction fractionalPart() {
    if (!isDefined()) {
      throw Exception('Fraction has indefinite coefficients.');
    }

    Fraction result = this - Fraction.fromNumber(integerPart());
    if (!this.isNegative()) {
      return result;
    }

    return Fraction.fromNumber(1) - result.abs();
  }

  Fraction abs() {
    return Fraction._(
      numerator: numerator.abs(),
      denominator: denominator.abs(),
      indefiniteNumberCoefficients: this.indefiniteNumberCoefficients.map(
            (x) => x.abs(),
          ),
    );
  }

  Fraction invert() {
    if (!isDefined()) {
      throw Exception('Fraction has indefinite coefficients.');
    }

    return Fraction.createConst(
      numerator: this.denominator,
      denominator: this.numerator,
    );
  }

  bool equalsNumber(int number) {
    if (!isDefined()) {
      return false;
    }

    return this == Fraction.fromNumber(number);
  }

  Fraction operator *(Fraction other) {
    if (!isDefined() && !other.isDefined()) {
      throw Exception('Error operating indefinite fractions.');
    }

    if (!isDefined()) {
      return other * this;
    }

    // `this` is always defined
    return Fraction.createConst(
      numerator: this.numerator * other.numerator,
      denominator: this.denominator * other.denominator,
      indefiniteNumberCoefficients:
          other.indefiniteNumberCoefficients.map((x) => x * this).toList(),
    );
  }

  Fraction operator /(Fraction other) {
    return this * other.invert();
  }

  Fraction operator +(Fraction other) {
    return Fraction.createConst(
      numerator: this.numerator * other.denominator +
          other.numerator * this.denominator,
      denominator: this.denominator * other.denominator,
      indefiniteNumberCoefficients:
          this.indefiniteNumberCoefficients.additionWith(
                other.indefiniteNumberCoefficients,
              ),
    );
  }

  Fraction operator -(Fraction other) {
    return this + other * const Fraction.fromNumber(-1);
  }

  bool operator >(Fraction other) {
    var cs = this
        .indefiniteNumberCoefficients
        .differenceWith(other.indefiniteNumberCoefficients);
    var notZero = cs.firstWhere(
      (x) => !x.equalsNumber(0),
      orElse: () => Fraction.fromNumber(0),
    );
    if (notZero.isPositive()) {
      return true;
    }

    if (notZero.isNegative()) {
      return false;
    }

    return this.numerator * other.denominator -
            this.denominator * other.numerator >
        0;
  }

  bool operator <(Fraction other) {
    var cs = this
        .indefiniteNumberCoefficients
        .differenceWith(other.indefiniteNumberCoefficients);
    var notZero = cs.firstWhere(
      (x) => !x.equalsNumber(0),
      orElse: () => Fraction.fromNumber(0),
    );
    if (notZero.isPositive()) {
      return false;
    }

    if (notZero.isNegative()) {
      return true;
    }

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

    return this
            .indefiniteNumberCoefficients
            .sameAs(other.indefiniteNumberCoefficients) &&
        this.numerator == other.numerator &&
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
    if (numerator == 0) {
      return '0';
    }

    if (denominator == 1) {
      return numerator.toString();
    }

    return '($numerator/$denominator)';
  }
}

extension SafeExtensions on List<Fraction> {
  safeAt(int index) {
    if (this.length < index) {
      return this[index];
    }

    return Fraction.fromNumber(0);
  }

  List<Fraction> additionWith(List<Fraction> other) {
    int length = max(this.length, other.length);
    return List.generate(length, (i) => this.safeAt(i) + other.safeAt(i));
  }

  List<Fraction> differenceWith(List<Fraction> other) {
    int length = max(this.length, other.length);
    return List.generate(length, (i) => this.safeAt(i) - other.safeAt(i));
  }

  bool sameAs(List<Fraction> other) {
    int length = max(this.length, other.length);
    return List.generate(length, (i) => this.safeAt(i) == other.safeAt(i))
        .every(
      (x) => x,
    );
  }
}
