import 'validator.dart';

class NotZeroValidator extends Validator {
  final String errorMessage;

  NotZeroValidator([this.errorMessage = 'Cannot be zero']);

  @override
  String validate(String value) {
    if (value != null && num.tryParse(value) == 0) {
      return errorMessage;
    }

    return null;
  }
}
