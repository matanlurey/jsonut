import 'package:jsonut/jsonut.dart';
import 'package:test/test.dart';

void main() {
  group('JsonBool', () {
    test('should parse a JSON string representing a boolean', () {
      expect(JsonBool.parse('true'), true);
    });

    test('should throw when parsing a string is not valid JSON', () {
      expect(() => JsonBool.parse('invalid'), throwsFormatException);
    });

    test('should throw when parsing a string is not a boolean', () {
      expect(() => JsonBool.parse('null'), throwsArgumentError);
      expect(() => JsonBool.parse('42'), throwsArgumentError);
    });

    test('should be usable as a boolean', () {
      const value = JsonBool(true);
      expect(value, isTrue);
    });

    test('should be usable as a JsonValue', () {
      const JsonValue _ = JsonBool(true);
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
        'student': const JsonBool(false),
      });
      expect(object['name'], 'John Doe');
      expect(object['age'], 42);
      expect(object['student'], false);
    });

    test('should be usable as a JsonValue', () {
      final JsonValue _ = JsonObject({
        'name': const JsonString('John Doe'),
        'age': const JsonNumber(42),
        'student': const JsonBool(false),
      });
    });
  });
}
