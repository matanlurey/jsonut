/// A minimal utility kit for working with JSON in a type-safe manner.
library jsonut;

// No imports beyond the dart SDK are allowed here, to ensure that it can be
// used in any environment, and without resolving any dependencies. Remember,
// this is a utility library, not a full-blown package.

import 'dart:convert' as dart;

/// A zero-cost wrapper around any JSON value including `null`.
///
/// This type mostly exists to provide a common supertype for all JSON values,
/// but otherwise has no behavior or properties of its own. To model an object
/// that intentionally is unknown (could be any type of JSON value), see the
/// [JsonAny] type (and [asAny]).
///
/// ## Safety
///
/// It is undefined behavior to cast (i.e. using `as` or a similar method such
/// as [List.cast]) an [Object] to a [JsonValue] if it is not a valid JSON
/// value.
///
/// For example, casting a [Duration] to a [JsonValue] fails during encoding:
///
/// ```dart
/// import 'dart:convert';
///
/// import 'package:jsonut/jsonut.dart';
///
/// void main() {
///   final value = Duration(seconds: 1);
///   jsonEncode(value); // Throws
/// }
/// ```
///
/// See also:
/// - [JsonAny.from]
extension type const JsonValue._(Object? _value) {
  static T _parseAndCastAs<T extends JsonValue?>(String json) {
    final value = dart.json.decode(json);
    if (value is T) {
      return value;
    }
    throw ArgumentError.value(
      value,
      'json',
      'Decoded value is ${value.runtimeType}, expected $T',
    );
  }

  static String _typeToString<T>() {
    if (T == JsonAny) {
      return 'JsonAny';
    }
    if (T == JsonBool) {
      return 'JsonBool';
    }
    if (T == JsonNumber) {
      return 'JsonNumber';
    }
    if (T == JsonString) {
      return 'JsonString';
    }
    if (T == JsonArray) {
      return 'JsonArray';
    }
    if (T == JsonObject) {
      return 'JsonObject';
    }
    return T.toString();
  }

  /// Converts this object into a [JsonAny].
  JsonAny asAny() => JsonAny._(_value);
}

/// A zero-cost wrapper around any JSON value including `null`.
///
/// Unlike [JsonValue], this type provides helper methods to convert the value
/// to a specific type, or to check its type. For each possible JSON type, there
/// is a cooresponding set of methods to:
///
/// - Convert the value to the specific type (e.g. [boolean], [booleanOrNull]).
/// - Check if the value is of the specific type (e.g. [isBool]).
///
/// ## Example
///
/// ```dart
/// import 'package:jsonut/jsonut.dart';
///
/// void main() {
///   final value = JsonAny.parse('{"key": true}');
///   final object = value.object();
///   print(object['key'].boolean()); // true
/// }
/// ```
///
/// ## Safety
///
/// It is undefined behavior to cast (i.e. using `as` or a similar method such
/// as [List.cast]) an [Object] to a [JsonAny] if it is not a valid JSON value.
/// See [JsonValue] for more information.
extension type const JsonAny._(Object? _value) implements JsonValue {
  /// Converts the given [value] to a [JsonValue].
  ///
  /// If the given [value] is not a valid JSON value, an error is thrown.
  factory JsonAny.from(Object? value) {
    switch (value) {
      case JsonString _:
      case JsonNumber _:
      case JsonBool _:
      case JsonArray _:
      case JsonObject _:
      case null:
        return JsonAny._(value);
      default:
        throw ArgumentError.value(
          value,
          'value',
          'Not a valid JSON value.',
        );
    }
  }

  /// Parses and returns the given [input] as a JSON value.
  ///
  /// If parsing fails, a [FormatException] is thrown.
  factory JsonAny.parse(String input) => JsonValue._parseAndCastAs(input);

  /// Whether the value is `null`.
  bool get isNull => _value == null;

  /// Returns the value cast to the given type [T].
  ///
  /// This method is useful when you know the type of the value, and want to
  /// avoid the overhead of checking the type and casting it manually. For
  /// example:
  ///
  /// ```dart
  /// final class Employee {
  ///   const Employee({required this.name, required this.age});
  ///
  ///   factory Employee.fromJson(JsonObject object) {
  ///     return Employee(
  ///       name: object['name'].as(),
  ///       age: object['age'].as(),
  ///     );
  ///   }
  ///
  ///   final String name;
  ///   final int age;
  /// }
  /// ```
  T as<T>() {
    assert(
      () {
        // If the value is not of the expected type, throw an error.
        if (_value is! T) {
          throw ArgumentError.value(
            _value,
            'value',
            'Value is ${_value.runtimeType}, expected ${JsonValue._typeToString<T>()}.',
          );
        }

        return true;
      }(),
      '',
    );
    return _value as T;
  }

  /// Returns the value cast to the given type [T], or `null` otherwise.
  T? asOrNull<T>() => _value is T ? _value : null;

  /// Returns the value as a boolean.
  ///
  /// If the value is not a boolean, an error is thrown.
  JsonBool boolean() => as();

  /// Returns the value as a boolean, or `null` if it is not a boolean.
  JsonBool? booleanOrNull() => asOrNull();

  /// Returns the value as a boolean, or `false` if it is not a boolean.
  JsonBool booleanOrFalse() => booleanOrNull() ?? const JsonBool(false);

  /// Whether the value is a boolean.
  bool get isBool => _value is JsonBool;

  /// Returns the value as a number.
  ///
  /// If the value is not a number, an error is thrown.
  JsonNumber number() => as();

  /// Returns the value as a number, or `null` if it is not a number.
  JsonNumber? numberOrNull() => asOrNull();

  /// Returns the value as a number, or `0` if it is not a number.
  JsonNumber numberOrZero() => numberOrNull() ?? const JsonNumber(0);

  /// Whether the value is a number.
  bool get isNumber => _value is JsonNumber;

  /// Returns the value as a string.
  ///
  /// If the value is not a string, an error is thrown.
  JsonString string() => as();

  /// Returns the value as a string, or `null` if it is not a string.
  JsonString? stringOrNull() => asOrNull();

  /// Returns the value as a string, or an empty string if it is not a string.
  JsonString stringOrEmpty() => stringOrNull() ?? const JsonString('');

  /// Whether the value is a string.
  bool get isString => _value is JsonString;

  /// Returns the value as an array.
  ///
  /// If the value is not an array, an error is thrown.
  JsonArray array() => as();

  /// Returns the value as an array, or `null` if it is not an array.
  JsonArray? arrayOrNull() => asOrNull();

  /// Returns the value as an array, or an empty array if it is not an array.
  // ignore: prefer_const_constructors
  JsonArray arrayOrEmpty() => arrayOrNull() ?? JsonArray._([]);

  /// Whether the value is an array.
  bool get isArray => _value is JsonArray;

  /// Returns the value as an object.
  ///
  /// If the value is not an object, an error is thrown.
  JsonObject object() => as();

  /// Returns the value as an object, or `null` if it is not an object.
  JsonObject? objectOrNull() => asOrNull();

  /// Returns the value as an object, or an empty object if it is not an object.
  // ignore: prefer_const_constructors
  JsonObject objectOrEmpty() => objectOrNull() ?? JsonObject._({});

  /// Whether the value is an object.
  bool get isObject => _value is JsonObject;
}

/// A zero-cost wrapper around a JSON boolean.
///
/// This type exists to provide a subtype of [JsonValue] that is a boolean.
extension type const JsonBool(bool _value) implements JsonValue, bool {
  /// Parses and returns the given [input] as a boolean.
  ///
  /// If parsing fails, or the result is not a boolean, a [FormatException] is
  /// thrown.
  factory JsonBool.parse(String input) => JsonValue._parseAndCastAs(input);
}

/// A zero-cost wrapper around a JSON number.
///
/// This type exists to provide a subtype of [JsonValue] that is a number.
extension type const JsonNumber(num _value) implements JsonValue, num {
  /// Parses and casts the given [input] as a number.
  ///
  /// If parsing fails a [FormatException] is thrown.
  factory JsonNumber.parse(String input) => JsonValue._parseAndCastAs(input);
}

/// A zero-cost wrapper around a JSON string.
///
/// This type exists to provide a subtype of [JsonValue] that is a string.
extension type const JsonString(String _value) implements JsonValue, String {
  /// Parses and casts the given [input] as a string.
  ///
  /// If parsing fails a [FormatException] is thrown.
  factory JsonString.parse(String input) => JsonValue._parseAndCastAs(input);
}

/// A zero-cost wrapper around a JSON array.
///
/// This type exists to provide a subtype of [JsonValue] that is an array.
extension type const JsonArray._(List<JsonAny> _value)
    implements JsonValue, List<JsonAny> {
  /// Returns and treats the given [value] as a JSON array.
  ///
  /// This is a zero-cost operation, and is provided as a convenience so that
  /// you can treat a list of [JsonValue] as a JSON array without needing to
  /// create a new instance.
  factory JsonArray(List<JsonValue> value) {
    return JsonArray._(value as List<JsonAny>);
  }

  /// Parses and returns the given [input] as a array.
  ///
  /// If parsing fails, or the result is not a array, a [FormatException] is
  /// thrown.
  factory JsonArray.parse(String input) => JsonValue._parseAndCastAs(input);
}

/// A zero-cost wrapper around a JSON object.
///
/// This type exists to provide a subtype of [JsonValue] that is an object.
///
/// Similar to [JsonAny], this type provides helper methods to read fields.
///
/// ## Example
///
/// ```dart
/// import 'package:jsonut/jsonut.dart';
///
/// void main() {
///   const json = '{"name": "John Doe", "age": 42}';
///   final object = JsonObject.parse(json);
///   print(object['name'].string()); // John Doe
///   print(object['age].number()); // 42
///   print(object['email'].stringOrNull()); // null
/// }
/// ```
extension type const JsonObject._(Map<String, JsonAny> fields)
    implements JsonValue, Map<String, JsonAny> {
  /// Returns and treats the given [value] as a JSON object.
  ///
  /// This is a zero-cost operation, and is provided as a convenience so that
  /// you can treat a map of [String] to [JsonValue] as a JSON object without
  /// needing to create a new instance.
  factory JsonObject(Map<String, JsonValue> value) {
    return JsonObject._(value as Map<String, JsonAny>);
  }

  /// Parses and casts the given [input] as an object.
  ///
  /// If parsing fails a [FormatException] is thrown.
  factory JsonObject.parse(String input) => JsonValue._parseAndCastAs(input);

  /// Returns a zero-cost wrapper for the field with the given [name].
  ///
  /// This method shadows the `[]` operator to provide a type-safe way to access
  /// fields in the JSON object without needing to cast the result or check its
  /// type or nullability.
  JsonAny operator [](String name) => JsonAny._(fields[name]);

  /// Given a path of [keys], returns the value at that path.
  JsonAny deepGet(Iterable<String> keys) {
    // In debug mode, print the attempted path and where it failed.
    // For example, ['a', 'b', 'c', 'd'], and if 'b' is not a map, print:
    // a->b->c: b is not a map.
    if (keys is! List) {
      keys = keys.toList();
    }
    assert(
      () {
        // The first N - 1 keys should be objects.
        var map = fields;
        for (var i = 0; i < keys.length - 1; i++) {
          final key = keys.elementAt(i);
          if (map[key] is! JsonObject) {
            throw ArgumentError.value(
              keys,
              'keys',
              'At ${keys.take(i + 1).join('->')}: $key is not an object.',
            );
          }
          map = (map[key] as JsonAny).object();
        }
        return true;
      }(),
      '',
    );

    // In release mode, just return the value.
    //
    // For every key except the last one, assume that the value is an object.
    // For the last key, return it as a JsonAny.
    var value = this as JsonAny;
    for (final key in keys) {
      value = value.object()[key];
    }
    return value;
  }
}

/// Provides helper methods to work with [Iterable]s of [JsonValue].
extension JsonIterable<E extends JsonValue> on Iterable<E> {
  /// Returns an unmodifiable list of the elements of this iterable.
  ///
  /// The elements are mapped using the given [toElement] function:
  ///
  /// ```dart
  /// final list = JsonArray([1, 2, 3]);
  /// final mapped = list.mapUnmodifiableList((value) => value.number());
  /// print(mapped); // [1, 2, 3]
  /// ```
  List<T> mapUnmodifiable<T>(T Function(E) toElement) {
    return List.unmodifiable(map(toElement));
  }
}
