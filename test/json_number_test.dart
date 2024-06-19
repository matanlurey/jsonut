// ignore_for_file: prefer_const_constructors

import 'dart:convert' show utf8;

import 'package:checks/checks.dart';
import 'package:jsonut/jsonut.dart';
import 'package:test/test.dart';

void main() {
  test('JsonNumber.parse', () {
    check(JsonNumber.parse('42')).equals(JsonNumber(42));
  });

  test('JsonNumber.parse double', () {
    check(JsonNumber.parse('42.6')).equals(JsonNumber(42.6));
  });

  test('JsonNumber.parse invalid', () {
    check(
      () => JsonNumber.parse('invalid'),
    ).throws<FormatException>();
  });

  test('JsonNumber.parseUtf8', () {
    check(JsonNumber.parseUtf8(utf8.encode('42'))).equals(JsonNumber(42));
  });

  test('JsonNumber.parseUtf8 double', () {
    check(JsonNumber.parseUtf8(utf8.encode('42.6'))).equals(JsonNumber(42.6));
  });

  test('JsonNumber.parseUtf8 invalid', () {
    check(
      () => JsonNumber.parseUtf8(utf8.encode('invalid')),
    ).throws<FormatException>();
  });
}
