// ignore_for_file: prefer_const_declarations, prefer_const_constructors

import 'dart:convert' show utf8;

import 'package:checks/checks.dart';
import 'package:jsonut/jsonut.dart';
import 'package:test/test.dart';

void main() {
  group('JsonAny.from', () {
    test('succeeds on boolean', () {
      check<JsonValue>(JsonAny.from(true)).equals(JsonBoolean(true));
    });

    test('succeeds on number', () {
      check<JsonValue>(JsonAny.from(42)).equals(JsonNumber(42));
    });

    test('succeeds on string', () {
      check<JsonValue>(JsonAny.from('hello')).equals(JsonString('hello'));
    });

    test('succeeds on array', () {
      check(JsonAny.from(['hello']))
          .isA<JsonArray>()
          .deepEquals(JsonArray([JsonString('hello')]));
    });

    test('succeeds on object', () {
      check(JsonAny.from({'hello': 'world'}))
          .isA<JsonObject>()
          .deepEquals(JsonObject({'hello': JsonString('world')}));
    });

    test('succeeds on boolean', () {
      check<JsonValue>(JsonAny.from(true)).equals(JsonBoolean(true));
    });

    test('succeeds on null', () {
      check<JsonValue>(JsonAny.from(null)).equals(jsonNull);
    });

    test('fails on custom', () {
      check(
        () => JsonAny.from(Duration.zero),
      ).throws<ArgumentError>();
    });
  });

  group('JsonAny.parse forwards to JsonValue.parse', () {
    test('boolean', () {
      check(JsonAny.parse('true'))
          .has((a) => a.boolean(), 'boolean()')
          .isTrue();
    });

    test('number', () {
      check(JsonAny.parse('42'))
          .has((a) => a.number(), 'number()')
          .equals(JsonNumber(42));
    });

    test('string', () {
      check(JsonAny.parse('"hello"'))
          .has((a) => a.string(), 'string()')
          .equals(JsonString('hello'));
    });

    test('array', () {
      final expected = JsonArray([JsonString('hello')]);
      check(JsonAny.parse('["hello"]'))
          .has((a) => a.array(), 'array()')
          .deepEquals(expected);
    });

    test('object', () {
      final expected = JsonObject({'hello': JsonString('world')});
      check(JsonAny.parse('{"hello":"world"}'))
          .has((a) => a.object(), 'object()')
          .deepEquals(expected);
    });

    test('null', () {
      check(JsonAny.parse('null')).has((a) => a.isNull, 'isNull').isTrue();
    });
  });

  group('JsonAny.parseUtf8', () {
    test('boolean', () {
      check(JsonAny.parseUtf8(utf8.encode('true')))
          .has((a) => a.boolean(), 'boolean()')
          .isTrue();
    });

    test('number', () {
      check(JsonAny.parseUtf8(utf8.encode('42')))
          .has((a) => a.number(), 'number()')
          .equals(JsonNumber(42));
    });

    test('string', () {
      check(JsonAny.parseUtf8(utf8.encode('"hello"')))
          .has((a) => a.string(), 'string()')
          .equals(JsonString('hello'));
    });

    test('array', () {
      final expected = JsonArray([JsonString('hello')]);
      check(JsonAny.parseUtf8(utf8.encode('["hello"]')))
          .has((a) => a.array(), 'array()')
          .deepEquals(expected);
    });

    test('object', () {
      final expected = JsonObject({'hello': JsonString('world')});
      check(JsonAny.parseUtf8(utf8.encode('{"hello":"world"}')))
          .has((a) => a.object(), 'object()')
          .deepEquals(expected);
    });

    test('null', () {
      check(JsonAny.parseUtf8(utf8.encode('null')))
          .has((a) => a.isNull, 'isNull')
          .isTrue();
    });
  });

  group('as', () {
    test('boolean success', () {
      check(JsonAny.from(true)).has((a) => a.as<bool>(), 'as<bool>()').isTrue();
    });

    test('boolean failure', () {
      check(JsonAny.from(42))
          .has((a) => a.as<bool>, 'as<bool>')
          .throws<ArgumentError>()
          .has((e) => e.message, 'message')
          .isA<String>()
        ..contains('Value is JsonNumber')
        ..contains('expected JsonBoolean');
    });

    test('boolean failure coerced to null', () {
      check(JsonAny.from(42))
          .has((a) => a.asOrNull<bool>(), 'asOrNull<bool>()')
          .isNull();
    });

    test('number success', () {
      check(JsonAny.from(42)).has((a) => a.as<int>(), 'as<int>()').equals(42);
    });

    test('number failure', () {
      check(JsonAny.from(true))
          .has((a) => a.as<int>, 'as<int>')
          .throws<ArgumentError>()
          .has((e) => e.message, 'message')
          .isA<String>()
        ..contains('Value is JsonBoolean')
        ..contains('expected JsonNumber');
    });

    test('number failure coerced to null', () {
      check(JsonAny.from(true))
          .has((a) => a.asOrNull<int>(), 'asOrNull<int>()')
          .isNull();
    });

    test('string success', () {
      check(JsonAny.from('hello'))
          .has((a) => a.as<String>(), 'as<String>()')
          .equals('hello');
    });

    test('string failure', () {
      check(JsonAny.from(42))
          .has((a) => a.as<String>, 'as<String>')
          .throws<ArgumentError>()
          .has((e) => e.message, 'message')
          .isA<String>()
        ..contains('Value is JsonNumber')
        ..contains('expected JsonString');
    });

    test('string failure coerced to null', () {
      check(JsonAny.from(42))
          .has((a) => a.asOrNull<String>(), 'asOrNull<String>()')
          .isNull();
    });

    test('array success', () {
      final expected = ['hello'];
      check(JsonAny.from(['hello']))
          .has((a) => a.as<List<String>>(), 'as<List>()')
          .deepEquals(expected);
    });

    test('array failure', () {
      check(JsonAny.from(42))
          .has((a) => a.as<List<Object?>>, 'as<List>')
          .throws<ArgumentError>()
          .has((e) => e.message, 'message')
          .isA<String>()
        ..contains('Value is JsonNumber')
        ..contains('expected JsonArray');
    });

    test('array failure coerced to null', () {
      check(JsonAny.from(42))
          .has((a) => a.asOrNull<List<Object?>>(), 'asOrNull<List>()')
          .isNull();
    });

    test('object success', () {
      final expected = {'hello': 'world'};
      check(JsonAny.from({'hello': 'world'}))
          .has((a) => a.as<Map<String, Object?>>(), 'as<Map>()')
          .deepEquals(expected);
    });

    test('object failure', () {
      check(JsonAny.from(42))
          .has((a) => a.as<Map<String, Object?>>, 'as<Map>')
          .throws<ArgumentError>()
          .has((e) => e.message, 'message')
          .isA<String>()
        ..contains('Value is JsonNumber')
        ..contains('expected JsonObject');
    });

    test('object failure coerced to null', () {
      check(JsonAny.from(42))
          .has((a) => a.asOrNull<Map<String, Object?>>(), 'asOrNull<Map>()')
          .isNull();
    });

    test('null success', () {
      check(JsonAny.from(null)).has((a) => a.as<Null>(), 'as<Null>()').isNull();
    });

    test('null failure', () {
      check(JsonAny.from(42))
          .has((a) => a.as<Null>, 'as<Null>')
          .throws<ArgumentError>()
          .has((e) => e.message, 'message')
          .isA<String>()
        ..contains('Value is JsonNumber')
        ..contains('expected null');
    });

    test('null failure coerced to null', () {
      check(JsonAny.from(42))
          .has((a) => a.asOrNull<Null>(), 'asOrNull<Null>()')
          .isNull();
    });

    test('custom failure', () {
      check(JsonAny.from(42))
          .has((a) => a.as<Duration>, 'as<Duration>')
          .throws<ArgumentError>()
          .has((e) => e.message, 'message')
          .isA<String>()
        ..contains('Value is JsonNumber')
        ..contains('expected Duration');
    });

    test('custom failure coerced to null', () {
      check(JsonAny.from(42))
          .has((a) => a.asOrNull<Duration>(), 'asOrNull<Duration>()')
          .isNull();
    });
  });

  group('boolean', () {
    test('returns a boolean', () {
      check(JsonAny.from(true)).has((a) => a.boolean(), 'boolean()').isTrue();
    });

    test('throws if not a boolean', () {
      check(JsonAny.from(42))
          .has((a) => a.boolean, 'boolean')
          .throws<ArgumentError>()
          .has((e) => e.message, 'message')
          .isA<String>()
        ..contains('Value is JsonNumber')
        ..contains('expected JsonBoolean');
    });

    test('returns null if not a boolean', () {
      check(JsonAny.from(42))
          .has((a) => a.booleanOrNull(), 'booleanOrNull()')
          .isNull();
    });

    test('returns false if not a boolean', () {
      check(JsonAny.from(42))
          .has((a) => a.booleanOrFalse(), 'booleanOrFalse()')
          .isFalse();
    });

    test('isBool if a boolean', () {
      check(JsonAny.from(true)).has((a) => a.isBool, 'isBool').isTrue();
    });

    test('isBool is false if not a boolean', () {
      check(JsonAny.from(42)).has((a) => a.isBool, 'isBool').isFalse();
    });
  });

  group('number', () {
    test('returns a number', () {
      check(JsonAny.from(42))
          .has((a) => a.number(), 'number()')
          .equals(JsonNumber(42));
    });

    test('throws if not a number', () {
      check(JsonAny.from(true))
          .has((a) => a.number, 'number')
          .throws<ArgumentError>()
          .has((e) => e.message, 'message')
          .isA<String>()
        ..contains('Value is JsonBoolean')
        ..contains('expected JsonNumber');
    });

    test('returns null if not a number', () {
      check(JsonAny.from(true))
          .has((a) => a.numberOrNull(), 'numberOrNull()')
          .isNull();
    });

    test('returns 0 if not a number', () {
      check(JsonAny.from(true))
          .has((a) => a.numberOrZero(), 'numberOrZero()')
          .equals(JsonNumber(0));
    });

    test('isNumber if a number', () {
      check(JsonAny.from(42)).has((a) => a.isNumber, 'isNumber').isTrue();
    });

    test('isNumber is false if not a number', () {
      check(JsonAny.from(true)).has((a) => a.isNumber, 'isNumber').isFalse();
    });
  });

  group('string', () {
    test('returns a string', () {
      check(JsonAny.from('hello'))
          .has((a) => a.string(), 'string()')
          .equals(JsonString('hello'));
    });

    test('throws if not a string', () {
      check(JsonAny.from(42))
          .has((a) => a.string, 'string')
          .throws<ArgumentError>()
          .has((e) => e.message, 'message')
          .isA<String>()
        ..contains('Value is JsonNumber')
        ..contains('expected JsonString');
    });

    test('returns null if not a string', () {
      check(JsonAny.from(42))
          .has((a) => a.stringOrNull(), 'stringOrNull()')
          .isNull();
    });

    test('returns an empty string if not a string', () {
      check(JsonAny.from(42))
          .has((a) => a.stringOrEmpty(), 'stringOrEmpty()')
          .equals(JsonString(''));
    });

    test('isString if a string', () {
      check(JsonAny.from('hello')).has((a) => a.isString, 'isString').isTrue();
    });

    test('isString is false if not a string', () {
      check(JsonAny.from(42)).has((a) => a.isString, 'isString').isFalse();
    });
  });

  group('array', () {
    test('returns an array', () {
      final expected = JsonArray([JsonString('hello')]);
      check(JsonAny.from(['hello']))
          .has((a) => a.array(), 'array()')
          .deepEquals(expected);
    });

    test('throws if not an array', () {
      check(JsonAny.from(42))
          .has((a) => a.array, 'array')
          .throws<ArgumentError>()
          .has((e) => e.message, 'message')
          .isA<String>()
        ..contains('Value is JsonNumber')
        ..contains('expected JsonArray');
    });

    test('returns null if not an array', () {
      check(JsonAny.from(42))
          .has((a) => a.arrayOrNull(), 'arrayOrNull()')
          .isNull();
    });

    test('returns an empty array if not an array', () {
      check(JsonAny.from(42))
          .has((a) => a.arrayOrEmpty(), 'arrayOrEmpty()')
          .deepEquals(JsonArray([]));
    });

    test('isArray if an array', () {
      check(JsonAny.from(['hello'])).has((a) => a.isArray, 'isArray').isTrue();
    });

    test('isArray is false if not an array', () {
      check(JsonAny.from(42)).has((a) => a.isArray, 'isArray').isFalse();
    });
  });

  group('object', () {
    test('returns an object', () {
      final expected = JsonObject({'hello': JsonString('world')});
      check(JsonAny.from({'hello': 'world'}))
          .has((a) => a.object(), 'object()')
          .deepEquals(expected);
    });

    test('throws if not an object', () {
      check(JsonAny.from(42))
          .has((a) => a.object, 'object')
          .throws<ArgumentError>()
          .has((e) => e.message, 'message')
          .isA<String>()
        ..contains('Value is JsonNumber')
        ..contains('expected JsonObject');
    });

    test('returns null if not an object', () {
      check(JsonAny.from(42))
          .has((a) => a.objectOrNull(), 'objectOrNull()')
          .isNull();
    });

    test('returns an empty object if not an object', () {
      check(JsonAny.from(42))
          .has((a) => a.objectOrEmpty(), 'objectOrEmpty()')
          .deepEquals(JsonObject({}));
    });

    test('isObject if an object', () {
      check(JsonAny.from({'hello': 'world'}))
          .has((a) => a.isObject, 'isObject')
          .isTrue();
    });

    test('isObject is false if not an object', () {
      check(JsonAny.from(42)).has((a) => a.isObject, 'isObject').isFalse();
    });
  });

  test('isNull', () {
    check(JsonAny.from(null)).has((a) => a.isNull, 'isNull').isTrue();
  });
}
