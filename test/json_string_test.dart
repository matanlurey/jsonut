// ignore_for_file: prefer_const_constructors

import 'dart:convert' show utf8;

import 'package:checks/checks.dart';
import 'package:jsonut/jsonut.dart';
import 'package:test/test.dart';

void main() {
  test('JsonString.parse', () {
    check(JsonString.parse('"hello"')).equals(JsonString('hello'));
  });

  test('JsonString.parse invalid', () {
    check(
      () => JsonString.parse('invalid'),
    ).throws<FormatException>();
  });

  test('JsonString.parseUtf8', () {
    check(JsonString.parseUtf8(utf8.encode('"hello"')))
        .equals(JsonString('hello'));
  });

  test('JsonString.parseUtf8 invalid', () {
    check(
      () => JsonString.parseUtf8(utf8.encode('invalid')),
    ).throws<FormatException>();
  });
}
