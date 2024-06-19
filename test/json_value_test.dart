// ignore_for_file: prefer_const_declarations, prefer_const_constructors

import 'dart:convert' show utf8;

import 'package:checks/checks.dart';
import 'package:jsonut/jsonut.dart';
import 'package:test/test.dart';

void main() {
  group('parse', () {
    test('invalid json', () {
      check(
        () => JsonValue.parse('invalid'),
      ).throws<FormatException>();
    });

    test('null success', () {
      check(JsonValue.parse('null')).equals(jsonNull);
    });

    test('boolean success', () {
      check(JsonValue.parse('true')).isA<JsonBoolean>().isTrue();
    });

    test('boolean failure', () {
      check(
        () => JsonValue.parse<JsonBoolean>('42'),
      ).throws<FormatException>().has((e) => e.message, 'message')
        ..contains('is JsonNumber')
        ..contains('expected JsonBoolean');
    });

    test('number success', () {
      check(JsonValue.parse('42')).equals(JsonNumber(42));
    });

    test('number failure', () {
      check(
        () => JsonValue.parse<JsonNumber>('true'),
      ).throws<FormatException>().has((e) => e.message, 'message')
        ..contains('is JsonBoolean')
        ..contains('expected JsonNumber');
    });

    test('string success', () {
      check(JsonValue.parse('"hello"')).equals(JsonString('hello'));
    });

    test('string failure', () {
      check(
        () => JsonValue.parse<JsonString>('42'),
      ).throws<FormatException>().has((e) => e.message, 'message')
        ..contains('is JsonNumber')
        ..contains('expected JsonString');
    });

    test('array success', () {
      final expected = JsonArray([JsonString('hello')]);
      check(
        JsonValue.parse('["hello"]'),
      ).isA<List<Object?>>().deepEquals(expected);
    });

    test('array failure', () {
      check(
        () => JsonValue.parse<JsonArray>('42'),
      ).throws<FormatException>().has((e) => e.message, 'message')
        ..contains('is JsonNumber')
        ..contains('expected JsonArray');
    });

    test('object success', () {
      final expected = JsonObject({'hello': JsonString('world')});
      check(
        JsonValue.parse('{"hello": "world"}'),
      ).isA<Map<String, Object?>>().deepEquals(expected);
    });

    test('object failure', () {
      check(
        () => JsonValue.parse<JsonObject>('42'),
      ).throws<FormatException>().has((e) => e.message, 'message')
        ..contains('is JsonNumber')
        ..contains('expected JsonObject');
    });
  });

  group('parseUtf8', () {
    test('invalid json', () {
      check(
        () => JsonValue.parseUtf8(utf8.encode('invalid')),
      ).throws<FormatException>();
    });

    test('boolean success', () {
      check(JsonValue.parseUtf8(utf8.encode('true')))
          .isA<JsonBoolean>()
          .isTrue();
    });

    test('boolean failure', () {
      check(
        () => JsonValue.parseUtf8<JsonBoolean>(utf8.encode('42')),
      ).throws<FormatException>().has((e) => e.message, 'message')
        ..contains('is JsonNumber')
        ..contains('expected JsonBoolean');
    });

    test('number success', () {
      check(JsonValue.parseUtf8(utf8.encode('42'))).equals(JsonNumber(42));
    });

    test('number failure', () {
      check(
        () => JsonValue.parseUtf8<JsonNumber>(utf8.encode('true')),
      ).throws<FormatException>().has((e) => e.message, 'message')
        ..contains('is JsonBoolean')
        ..contains('expected JsonNumber');
    });

    test('string success', () {
      check(JsonValue.parseUtf8(utf8.encode('"hello"')))
          .equals(JsonString('hello'));
    });

    test('string failure', () {
      check(
        () => JsonValue.parseUtf8<JsonString>(utf8.encode('42')),
      ).throws<FormatException>().has((e) => e.message, 'message')
        ..contains('is JsonNumber')
        ..contains('expected JsonString');
    });

    test('array success', () {
      final expected = JsonArray([JsonString('hello')]);
      check(
        JsonValue.parseUtf8(utf8.encode('["hello"]')),
      ).isA<List<Object?>>().deepEquals(expected);
    });

    test('array failure', () {
      check(
        () => JsonValue.parseUtf8<JsonArray>(utf8.encode('42')),
      ).throws<FormatException>().has((e) => e.message, 'message')
        ..contains('is JsonNumber')
        ..contains('expected JsonArray');
    });

    test('object success', () {
      final expected = JsonObject({'hello': JsonString('world')});
      check(
        JsonValue.parseUtf8(utf8.encode('{"hello": "world"}')),
      ).isA<Map<String, Object?>>().deepEquals(expected);
    });

    test('object failure', () {
      check(
        () => JsonValue.parseUtf8<JsonObject>(utf8.encode('42')),
      ).throws<FormatException>().has((e) => e.message, 'message')
        ..contains('is JsonNumber')
        ..contains('expected JsonObject');
    });
  });

  test('convert any JsonValue to a JsonAny', () {
    final a = true as JsonValue;
    check(a).has((a) => a.asAny().boolean(), 'asAny().boolean()').isTrue();
  });
}
