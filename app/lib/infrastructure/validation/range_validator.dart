import 'package:flutter/foundation.dart';

import 'validator.dart';

class RangeValidator implements Validator {
  final String _errorMessage;
  final num minValue;
  final num maxValue;

  RangeValidator(String errorMessage, {
    @required this.minValue,
    @required this.maxValue
  }) :
    this._errorMessage = errorMessage {
      if (minValue > maxValue)
        throw Exception('Min value can not be greater than max value.');
    }
  
  @override
  String get errorMessage => _errorMessage;

  @override
  String validate(value) {
    if (!(value is num))
      throw Exception('Only numbers can be validated with Range.');

    num numValue = value;
    if (numValue >= minValue && numValue <= maxValue)
      return null;

    return errorMessage;
  }
}