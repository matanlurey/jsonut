import 'package:jsonut/jsonut.dart';

void main() {
  const json = '''
  {
    "name": "John Doe",
    "age": 42,
    "student": false
  }
  ''';

  final object = JsonObject.parse(json);

  print(object['name'].string()); // John Doe
  print(object['age'].number()); // 42
  print(object['student'].boolean()); // false

  // Example of a missing field.
  print(object['email'].stringOrNull()); // null
}
