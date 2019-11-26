abstract class Validator {
  String get errorMessage;
  String validate(dynamic value);
}