// ignore_for_file: prefer_const_constructors

import 'dart:convert' show utf8;

import 'package:checks/checks.dart';
import 'package:jsonut/jsonut.dart';
import 'package:test/test.dart';

void main() {
  test('JsonArray converts for free from List<JsonValue>', () {
    final original = <JsonValue>[JsonString('hello')];
    final converted = JsonArray(original);
    check<Object>(converted).identicalTo(original);
  });

  test('JsonArray.parse', () {
    check(
      JsonArray.parse('["hello"]'),
    ).deepEquals(JsonArray([JsonString('hello')]));
  });

  test('JsonArray.parse invalid', () {
    check(
      () => JsonArray.parse('invalid'),
    ).throws<FormatException>();
  });

  test('JsonArray.parseUtf8', () {
    check(
      JsonArray.parseUtf8(utf8.encode('["hello"]')),
    ).deepEquals([JsonString('hello')]);
  });

  test('JsonArray.parseUtf8 invalid', () {
    check(
      () => JsonArray.parseUtf8(utf8.encode('invalid')),
    ).throws<FormatException>();
  });

  test('JsonArray can be cast to another type', () {
    final array = JsonArray([JsonString('hello')]).cast<JsonString>();
    check(array).deepEquals(<JsonString>[JsonString('hello')]);
  });

  test('JsonIterable.mapUnmodifiable', () {
    final Iterable<JsonValue> iterable = [JsonString('42')];
    final mapped = iterable.mapUnmodifiable(
      (e) => num.parse(e.asAny().string()),
    );
    check(() => mapped.add(24)).throws<Object>();
    check(mapped).deepEquals([42]);
  });
}
