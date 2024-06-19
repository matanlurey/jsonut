// ignore_for_file: prefer_const_constructors

import 'dart:convert' show utf8;

import 'package:checks/checks.dart';
import 'package:jsonut/jsonut.dart';
import 'package:test/test.dart';

void main() {
  test('JsonObject converts for free from Map<String, JsonValue>', () {
    final original = <String, JsonValue>{'key': JsonString('value')};
    final converted = JsonObject(original);
    check<Object>(converted).identicalTo(original);
  });

  test('JsonObject.parse', () {
    check(
      JsonObject.parse('{"key":"value"}'),
    ).deepEquals(JsonObject({'key': JsonString('value')}));
  });

  test('JsonObject.parse invalid', () {
    check(
      () => JsonObject.parse('invalid'),
    ).throws<FormatException>();
  });

  test('JsonObject.parseUtf8', () {
    check(
      JsonObject.parseUtf8(utf8.encode('{"key":"value"}')),
    ).deepEquals({'key': JsonString('value')});
  });

  test('JsonObject.parseUtf8 invalid', () {
    check(
      () => JsonObject.parseUtf8(utf8.encode('invalid')),
    ).throws<FormatException>();
  });

  test('JsonObject can be cast to another type', () {
    final object = JsonObject({'key': JsonString('value')}).cast<JsonString>();
    check(object).deepEquals({'key': JsonString('value')});
  });

  test('operator[] returns a JsonAny', () {
    final object = JsonObject({'key': JsonString('value')});
    check(object['key'])
        .has((a) => a.string(), 'string()')
        .equals(JsonString('value'));
  });

  test('operator[]= sets a JsonValue', () {
    final object = JsonObject({'key': JsonString('value')});
    object['key'] = JsonNumber(42);
    check(object['key'])
        .has((a) => a.number(), 'number()')
        .equals(JsonNumber(42));
  });

  test('deepGet returns a value at a path', () {
    // Nested object with "a": {"b": {"c": 42}}
    final object = JsonObject({
      'a': JsonObject({
        'b': JsonObject({
          'c': const JsonNumber(42),
        }),
      }),
    });
    check(object.deepGet(['a', 'b', 'c']).number()).equals(JsonNumber(42));
    check(
      object.deepGet(['a', 'b', 'c'].map((a) => a)).number(),
      because: 'deepGet should accept an Iterable.',
    ).equals(JsonNumber(42));
  });

  test('deepGetOrNull', () {
    // Nested object with "a": {"b": {"c": 42}}
    final object = JsonObject({
      'a': JsonObject({
        'b': JsonObject({
          'c': const JsonNumber(42),
        }),
      }),
    });
    check(
      object.deepGetOrNull(['a', 'b', 'c']).number(),
    ).equals(JsonNumber(42));
    check(object.deepGetOrNull(['a', 'b', 'd'])).isNull();
  });

  test('returns an informative error message', () {
    // Nested object with "a": {"b": {"c": 42}}
    final object = JsonObject({
      'a': JsonObject({
        'b': JsonObject({
          'c': const JsonNumber(42),
        }),
      }),
    });
    check(() => object.deepGet(['a', 'f', 'c', 'd']))
        .throws<ArgumentError>()
        .which((e) {
      e.has((e) => e.message, 'message').equals('At a->f: f is not an object.');
    });
  });

  test('convert multiple fields to another object', () {
    final ({
      String name,
      int age,
      bool student,
    }) person;
    final object = JsonObject({
      'name': JsonString('John Doe'),
      'age': JsonNumber(42),
      'student': JsonBoolean(false),
    });
    person = object.convert(
      (fields) => (
        name: fields['name'].as(),
        age: fields['age'].as(),
        student: fields['student'].as(),
      ),
    );
    check(person).equals(
      (
        name: 'John Doe',
        age: 42,
        student: false,
      ),
    );
  });

  test('convert refuses async work', () {
    final object = JsonObject({
      'name': JsonString('John Doe'),
      'age': JsonNumber(42),
      'student': JsonBoolean(false),
    });
    check(
      () => object.convert(
        (fields) async => (
          name: fields['name'].as<String>(),
          age: fields['age'].as<int>(),
          student: fields['student'].as<bool>(),
        ),
      ),
    ).throws<ArgumentError>();
  });

  test('convert failure is caught', () {
    final object = JsonObject({
      'name': JsonNumber(42),
      'age': JsonNumber(42),
      'student': JsonBoolean(false),
    });
    check(
      () => object.convert(
        (fields) => (
          name: fields['name'].as<String>(),
          age: fields['age'].as<int>(),
          student: fields['student'].as<bool>(),
        ),
      ),
    ).throws<ArgumentError>();
  });
}
