import 'validator.dart';

class RequiredValidator implements Validator {
  final String _errorMessage;

  @override
  String get errorMessage => _errorMessage;

  const RequiredValidator(String errorMessage)
      : this._errorMessage = errorMessage;

  @override
  String validate(dynamic value) {
    if (value == null) {
      return _errorMessage;
    }

    if (value is String && value.isEmpty) {
      return _errorMessage;
    }

    return null;
  }
}
