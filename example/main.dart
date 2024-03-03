import 'package:jsonut/jsonut.dart';

void main() {
  const json = '''
  {
    "name": "John Doe",
    "age": 42,
    "student": false,
  }
  ''';

  final object = JsonObject.parse(json);

  print(object.string('name')); // John Doe
  print(object.number('age')); // 42
  print(object.boolean('student')); // false

  // Example of a missing field.
  print(object.stringOr('email')); // null
}
