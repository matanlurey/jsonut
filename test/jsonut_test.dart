import 'package:checks/checks.dart';
import 'package:jsonut/jsonut.dart';
import 'package:test/test.dart';

final _assertionsEnabled = () {
  var enabled = false;
  assert(enabled = true, '');
  return enabled;
}();

void main() {
  group('JsonBool', () {
    test('should parse a JSON string representing a boolean', () {
      expect(JsonBoolean.parse('true'), true);
    });

    test('should throw when parsing a string is not valid JSON', () {
      expect(() => JsonBoolean.parse('invalid'), throwsFormatException);
    });

    test('should throw when parsing a string is not a boolean', () {
      expect(() => JsonBoolean.parse('null'), throwsArgumentError);
      expect(() => JsonBoolean.parse('42'), throwsArgumentError);
    });

    test('should be usable as a boolean', () {
      const value = JsonBoolean(true);
      expect(value, isTrue);
    });

    test('should be usable as a JsonValue', () {
      const JsonValue _ = JsonBoolean(true);
    });
  });

  group('JsonNumber', () {
    test('should parse a JSON string representing an integer', () {
      expect(JsonNumber.parse('42'), 42);
    });

    test('should parse a JSON string representing a double', () {
      expect(JsonNumber.parse('42.6'), 42.6);
    });

    test('should throw when parsing a string is not valid JSON', () {
      expect(() => JsonNumber.parse('invalid'), throwsFormatException);
    });

    test('should throw when parsing a string is not a number', () {
      expect(() => JsonNumber.parse('null'), throwsArgumentError);
      expect(() => JsonNumber.parse('true'), throwsArgumentError);
    });

    test('should be usable as a number', () {
      const value = JsonNumber(42);
      expect(value.toInt(), 42);
    });

    test('should be usable as a JsonValue', () {
      const JsonValue _ = JsonNumber(42);
    });
  });

  group('JsonString', () {
    test('should parse a JSON string', () {
      expect(JsonString.parse('"John Doe"'), 'John Doe');
    });

    test('should throw when parsing a string is not valid JSON', () {
      expect(() => JsonString.parse('invalid'), throwsFormatException);
    });

    test('should throw when parsing a string is not a string', () {
      expect(() => JsonString.parse('null'), throwsArgumentError);
      expect(() => JsonString.parse('42'), throwsArgumentError);
    });

    test('should be usable as a string', () {
      const value = JsonString('John Doe');
      expect(value.toString(), 'John Doe');
    });

    test('should be usable as a JsonValue', () {
      const JsonValue _ = JsonString('John Doe');
    });
  });

  group('JsonArray', () {
    test('should parse a JSON string representing an array', () {
      expect(JsonArray.parse('[1, 2, 3]'), [1, 2, 3]);
    });

    test('should throw when parsing a string is not valid JSON', () {
      expect(() => JsonArray.parse('invalid'), throwsFormatException);
    });

    test('should throw when parsing a string is not an array', () {
      expect(() => JsonArray.parse('null'), throwsArgumentError);
      expect(() => JsonArray.parse('42'), throwsArgumentError);
    });

    test('should be usable as a list', () {
      final value = JsonArray([
        const JsonNumber(1),
        const JsonNumber(2),
        const JsonNumber(3),
      ]);
      expect(value, [1, 2, 3]);
    });

    test('should be usable as a JsonValue', () {
      final JsonValue _ = JsonArray([
        const JsonNumber(1),
        const JsonNumber(2),
        const JsonNumber(3),
      ]);
    });

    test('elements are a JsonAny', () {
      final array = JsonArray([
        const JsonNumber(1),
        const JsonString('two'),
        const JsonBoolean(true),
      ]);
      expect(array[0].number(), 1);
      expect(array[1].string(), 'two');
      expect(array[2].boolean(), true);
    });

    test(
      'can be easily converted into an unmodifiable list of something',
      () {
        const json = '''
          [
            "one",
            "two",
            "three"
          ]
        ''';
        final array = JsonArray.parse(json).cast<JsonString>();
        final list = array.mapUnmodifiable((e) => e.toUpperCase());
        check(list).deepEquals(['ONE', 'TWO', 'THREE']);
      },
    );
  });

  group('JsonObject', () {
    test('should parse a JSON string representing an object', () {
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
      expect(object['name'].string(), 'John Doe');
      expect(object['age'].number(), 42);
      expect(object['student'].boolean(), false);
      expect(object['dogs'].array(), ['Fido', 'Rex']);
    });

    test('should throw when parsing a string is not valid JSON', () {
      expect(() => JsonObject.parse('invalid'), throwsFormatException);
    });

    test('should throw when parsing a string is not an object', () {
      expect(() => JsonObject.parse('null'), throwsArgumentError);
      expect(() => JsonObject.parse('42'), throwsArgumentError);
    });

    test('should be usable as a map', () {
      final object = JsonObject({
        'name': const JsonString('John Doe'),
        'age': const JsonNumber(42),
        'student': const JsonBoolean(false),
      });
      expect(object['name'], 'John Doe');
      expect(object['age'], 42);
      expect(object['student'], false);
    });

    test('should be usable as a JsonValue', () {
      final JsonValue _ = JsonObject({
        'name': const JsonString('John Doe'),
        'age': const JsonNumber(42),
        'student': const JsonBoolean(false),
      });
    });

    test('should get a value at a path', () {
      // Nested object with "a": {"b": {"c": 42}}
      final object = JsonObject({
        'a': JsonObject({
          'b': JsonObject({
            'c': const JsonNumber(42),
          }),
        }),
      });
      expect(object.deepGet(['a', 'b', 'c']).number(), 42);
    });

    test(
      'in debug mode, deepGet failure is informative',
      () {
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
          e
              .has((e) => e.message, 'message')
              .equals('At a->f: f is not an object.');
        });
      },
      skip: !_assertionsEnabled,
    );
  });

  group('JsonAny', () {
    test(
      'in debug mode, a cast error from another type is informative',
      () {
        const value = 42 as JsonAny;
        check(value.boolean).throws<ArgumentError>().which((e) {
          e
              .has((e) => e.message, 'message')
              .equals('Value is int, expected JsonBool.');
        });
      },
      skip: !_assertionsEnabled,
    );
  });

  test('as() can represent a `null` value', () {
    final value = JsonAny.from(null);
    expect(value.isNull, isTrue);
  });

  test('as() can represent a non-JSON primitive', () {
    final value = JsonAny.from(42);
    expect(value.as<int>(), 42);
  });

  test('asOrNull() returns the object if it exists', () {
    const json = '''
      {
        "subtitle": "The quick brown fox jumps over the lazy dog."
      }
    ''';
    final object = JsonObject.parse(json);
    final subTitle = object['subtitle'].asOrNull<String>();
    check(subTitle).equals('The quick brown fox jumps over the lazy dog.');
  });

  test('should default to false', () {
    final value = JsonAny.from(null);
    expect(value.booleanOrFalse(), isFalse);
  });

  test('should default to 0', () {
    final value = JsonAny.from(null);
    expect(value.numberOrZero(), 0);
  });

  test('should default to an empty string', () {
    final value = JsonAny.from(null);
    expect(value.stringOrEmpty(), '');
  });

  test('should default to an empty list', () {
    final value = JsonAny.from(null);
    expect(value.arrayOrEmpty(), isEmpty);
  });

  test('should default to an empty map', () {
    final value = JsonAny.from(null);
    expect(value.objectOrEmpty(), isEmpty);
  });
}
