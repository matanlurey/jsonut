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
/// - [JsonAny.tryFrom]
extension type const JsonValue._(Object? _value) {
  static T _parse<T extends JsonValue?>(String json) {
    final value = dart.json.decode(json);
    return value is T
        ? value
        : throw FormatException(
            'Invalid JSON value: expected $T but got ${value.runtimeType}',
            json,
          );
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
/// - Convert the value to the specific type (e.g. [boolean], [booleanOr]).
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
    return tryFrom(value) ?? (throw ArgumentError.value(value, 'value'));
  }

  /// Parses and returns the given [input] as a JSON value.
  ///
  /// If parsing fails, a [FormatException] is thrown.
  factory JsonAny.parse(String input) => JsonValue._parse(input);

  /// Tries to convert the given [value] to a [JsonValue].
  ///
  /// If the given [value] is not a valid JSON value, `null` is returned.
  static JsonAny? tryFrom(Object? value) {
    return switch (value) {
      JsonBool _ ||
      JsonNumber _ ||
      JsonString _ ||
      JsonArray _ ||
      JsonObject _ ||
      null =>
        JsonAny._(value),
      _ => null,
    };
  }

  /// Whether the value is `null`.
  bool get isNull => _value == null;

  /// Returns the value as a boolean.
  ///
  /// If the value is not a boolean, an error is thrown.
  JsonBool boolean() => _value as JsonBool;

  /// Returns the value as a boolean, or `null` if it is not a boolean.
  JsonBool? booleanOr() => _value is JsonBool ? _value : null;

  /// Whether the value is a boolean.
  bool get isBool => _value is JsonBool;

  /// Returns the value as a number.
  ///
  /// If the value is not a number, an error is thrown.
  JsonNumber number() => _value as JsonNumber;

  /// Returns the value as a number, or `null` if it is not a number.
  JsonNumber? numberOr() => _value is JsonNumber ? _value : null;

  /// Whether the value is a number.
  bool get isNumber => _value is JsonNumber;

  /// Returns the value as a string.
  ///
  /// If the value is not a string, an error is thrown.
  JsonString string() => _value as JsonString;

  /// Returns the value as a string, or `null` if it is not a string.
  JsonString? stringOr() => _value is JsonString ? _value : null;

  /// Whether the value is a string.
  bool get isString => _value is JsonString;

  /// Returns the value as an array.
  ///
  /// If the value is not an array, an error is thrown.
  JsonArray array() => _value as JsonArray;

  /// Returns the value as an array, or `null` if it is not an array.
  JsonArray? arrayOr() => _value is JsonArray ? _value : null;

  /// Whether the value is an array.
  bool get isArray => _value is JsonArray;

  /// Returns the value as an object.
  ///
  /// If the value is not an object, an error is thrown.
  JsonObject object() => _value as JsonObject;

  /// Returns the value as an object, or `null` if it is not an object.
  JsonObject? objectOr() => _value is JsonObject ? _value : null;

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
  factory JsonBool.parse(String input) => JsonValue._parse(input);
}

/// A zero-cost wrapper around a JSON number.
///
/// This type exists to provide a subtype of [JsonValue] that is a number.
extension type const JsonNumber(num _value) implements JsonValue, num {
  /// Parses and returns the given [input] as a number.
  ///
  /// If parsing fails, or the result is not a number, a [FormatException] is
  /// thrown.
  factory JsonNumber.parse(String input) => JsonValue._parse(input);
}

/// A zero-cost wrapper around a JSON string.
///
/// This type exists to provide a subtype of [JsonValue] that is a string.
extension type const JsonString(String _value) implements JsonValue, String {
  /// Parses and returns the given [input] as a string.
  ///
  /// If parsing fails, or the result is not a string, a [FormatException] is
  /// thrown.
  factory JsonString.parse(String input) => JsonValue._parse(input);
}

/// A zero-cost wrapper around a JSON array.
///
/// This type exists to provide a subtype of [JsonValue] that is an array.
extension type const JsonArray._(List<JsonAny> _value)
    implements JsonValue, List<JsonValue> {
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
  factory JsonArray.parse(String input) => JsonValue._parse(input);
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
///   print(object.string('name')); // John Doe
///   print(object.number('age')); // 42
///   print(object.stringOr('email')); // null
/// }
/// ```
extension type const JsonObject._(Map<String, JsonAny?> _value)
    implements JsonValue, Map<String, JsonAny?> {
  /// Returns and treats the given [value] as a JSON object.
  ///
  /// This is a zero-cost operation, and is provided as a convenience so that
  /// you can treat a map of [String] to [JsonValue] as a JSON object without
  /// needing to create a new instance.
  factory JsonObject(Map<String, JsonValue> value) {
    return JsonObject._(value as Map<String, JsonAny?>);
  }

  /// Parses and returns the given [input] as an object.
  ///
  /// If parsing fails, or the result is not an object, a [FormatException] is
  /// thrown.
  factory JsonObject.parse(String input) => JsonValue._parse(input);

  /// Returns the value of the field as a boolean.
  ///
  /// If the field does not exist, or is not a boolean, an error is thrown.
  JsonBool boolean(String key) => _value[key]!.boolean();

  /// Returns the value of the field as a boolean, or `null` otherwise.
  JsonBool? booleanOr(String key) => _value[key]?.booleanOr();

  /// Returns the value of the field as a number.
  ///
  /// If the field does not exist, or is not a number, an error is thrown.
  JsonNumber number(String key) => _value[key]!.number();

  /// Returns the value of the field as a number, or `null` otherwise.
  JsonNumber? numberOr(String key) => _value[key]?.numberOr();

  /// Returns the value of the field as a string.
  ///
  /// If the field does not exist, or is not a string, an error is thrown.
  JsonString string(String key) => _value[key]!.string();

  /// Returns the value of the field as a string, or `null` otherwise.
  JsonString? stringOr(String key) => _value[key]?.stringOr();

  /// Returns the value of the field as an array.
  ///
  /// If the field does not exist, or is not an array, an error is thrown.
  JsonArray array(String key) => _value[key]!.array();

  /// Returns the value of the field as an array, or `null` otherwise.
  JsonArray? arrayOr(String key) => _value[key]?.arrayOr();

  /// Returns the value of the field as an object.
  ///
  /// If the field does not exist, or is not an object, an error is thrown.
  JsonObject object(String key) => _value[key]!.object();

  /// Returns the value of the field as an object, or `null` otherwise.
  JsonObject? objectOr(String key) => _value[key]?.objectOr();
}
