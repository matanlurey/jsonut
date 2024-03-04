<!-- https://dart.dev/tools/pub/package-layout#changelog -->

# 0.2.0+1

- Fixed a bug where `JsonArray`'s elements were `JsonValue` not `JsonAny`.

# 0.2.0

- Added `.as` and `.asOrNull` methods to `JsonAny` for inference casting:

  ```dart
  final class Employee {
    const Employee({required this.name});
    final String name;
  }

  final object = JsonObject.parse('{"name": "John Doe"}');
  final employee = Employee(name: object['name'].as());
  ```

- **Breaking change:** `<JsonAny>.{type}Or` renamed to `<JsonAny>.{type}OrNull`
  to better reflect the behavior of the method, and be idiomatic with other Dart
  APIs:

  ```diff
  - print(any.stringOr('name'));
  + print(any.stringOrNull('name'));
  ```

- **Breaking change:** `<JsonType>.parse` only throws a `FormatException` if the
  input is not valid JSON, and an `ArgumentError` if the input is not the
  expected type. This makes the behavior more consistent with other Dart APIs.

- **Breaking change:** Reduced the API of `JsonObject` to remove `.{type}()`
  methods in favor of just providing a custom `[]` operator tht returns
  `JsonAny` instances.

  ```diff
  - print(person.string('name'));
  + print(person['name'].string());
  ```

  Saving roughly ~2 characters per call wasn't worth the additional complexity.

# 0.1.0

- Initial development release.
