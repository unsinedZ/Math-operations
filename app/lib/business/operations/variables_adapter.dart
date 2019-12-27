import 'package:app/business/operations/entities/variable.dart';

class VariablesAdapter {
  List<int> adaptNamesIntoIndices(List<String> names) {
    var nonNumRegex = RegExp(r'[^\d]');
    return names
        .map(
          (x) => int.parse(
            Variable.unwrapVariableName(x).replaceAll(nonNumRegex, ''),
          ),
        )
        .toList();
  }
}
