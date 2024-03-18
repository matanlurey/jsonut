import 'package:jsonut/jsonut.dart';

void main() {
  const json = '''
  {
    "name": "John Doe",
    "age": 42,
    "student": false,
    "dogs": [
      "Fido",
      "Rex"
    ]
  }
  ''';

  final object = JsonObject.parse(json);

  print(object['name'].string()); // John Doe
  print(object['age'].number()); // 42
  print(object['student'].boolean()); // false

  // Example of a missing field.
  print(object['email'].stringOrNull()); // null

  // Example of array funsies.
  final dogs = object['dogs'].array().mapUnmodifiable((e) => e.string());

  // We get a real List<String> here at this point.
  // ignore: unnecessary_type_check
  print(dogs is List<String>);
}
