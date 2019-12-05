import 'validator.dart';

class RequiredValidator extends Validator {
  final String errorMessage;

  RequiredValidator([this.errorMessage = 'Value is required']);

  @override
  String validate(String value) {
    return value == null || value.isEmpty ? errorMessage : null;
  }
}
