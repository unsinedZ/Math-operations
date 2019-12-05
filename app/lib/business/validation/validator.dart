abstract class Validator {
  String validate(String value);

  static Validator combine(List<Validator> validators) {
    return _CombinedValidator(validators);
  }
}

class _CombinedValidator extends Validator {
  final List<Validator> validators;

  _CombinedValidator(this.validators);

  @override
  String validate(String value) {
    for (Validator validator in validators) {
      String result = validator.validate(value);
      if (result != null) return result;
    }

    return null;
  }
}
