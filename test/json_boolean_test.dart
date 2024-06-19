import 'dart:convert' show utf8;

import 'package:checks/checks.dart';
import 'package:jsonut/jsonut.dart';
import 'package:test/test.dart';

void main() {
  test('JsonBoolean.parse', () {
    check(JsonBoolean.parse('true')).isTrue();
  });

  test('JsonBoolean.parse invalid', () {
    check(
      () => JsonBoolean.parse('invalid'),
    ).throws<FormatException>();
  });

  test('JsonBoolean.parseUtf8', () {
    check(JsonBoolean.parseUtf8(utf8.encode('true'))).isTrue();
  });

  test('JsonBoolean.parseUtf8 invalid', () {
    check(
      () => JsonBoolean.parseUtf8(utf8.encode('invalid')),
    ).throws<FormatException>();
  });
}
