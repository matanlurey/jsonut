# JSON Utility Kit

A minimal utility kit for working with JSON in a type-safe manner.

[![GitHub Actions Workflow Status](https://github.com/matanlurey/jsonut.dart/actions/workflows/dart.yml/badge.svg)](https://github.com/matanlurey/jsonut/actions/workflows/dart.yml)
[![Coverage Status](https://coveralls.io/repos/github/matanlurey/jsonut/badge.svg?branch=main)](https://coveralls.io/github/matanlurey/jsonut?branch=main)
[![Pub Package](https://img.shields.io/pub/v/jsonut.svg)](https://pub.dev/packages/jsonut)
[![Dartdoc reference](https://img.shields.io/badge/dartdoc-reference-blue.svg)](https://pub.dev/documentation/jsonut/latest/)

<!-- See https://dart.dev/guides/libraries/writing-package-pages -->

By default, Dart [offers very little](https://dart.dev/guides/json) in the way
of JSON parsing and serialization. While upcoming features like
[macros][working-feature-macros][^1] are promising, they are not yet available
(as of 2024-03-1). This package uses a (at the time of writing) new language
feature, [extension types](https://dart.dev/language/extension-types) to provide
lightweight, type-safe JSON parsing:

```dart
import 'package:jsonut/jsonut.dart';

void main() {
  final string = '{"name": "John Doe", "age": 42}';
  final person = JsonObject.parse(string);
  print(person['name'].string()); // John Doe
  print(person['age'].number()); // 42
}
```

[working-feature-macros]: https://github.com/dart-lang/language/tree/3c846917d835fd54526c9fc02ac066ee8afa76a5/

[^1]: Macros could be used to _enhance_ this package once available!

## Features

- 🦺 **Typesafe**: JSON parsing and serialization is type-safe and easy to use.
- 💨 **Lightweight**: No dependencies, code generation, or reflection.
- 💪🏽 **Flexible**: Parse lazily or validate eagerly, as needed.
- 🚫 **No Bullshit**: Use as little or as much as you need.

## Getting Started

Simply add the package to your `pubspec.yaml`:

```yaml
dependencies:
  jsonut: ^0.4.0
```

Or use the command line:

```sh
dart pub add jsonut
```

```sh
flutter packages add jsonut
```

Or, even just copy paste the code (a _single_ `.dart` file) into your project:

```sh
curl -o lib/jsonut.dart https://raw.githubusercontent.com/matanlurey/jsonut/main/lib/jsonut.dart
```

## Benchmarks

A basic decoding benchmark is included in the `benchmark/` directory. To run it:

```sh
# JIT
dart run benchmark/decode.dart

# AOT
dart compile exe benchmark/decode.dart
./benchmark/decode.exe
```

On my machine™, a M2 MacBook Pro, there is roughly a <10% overhead compared to
just using the `object['...'] as ...` pattern, or dynamic calls in JIT mode. In AOT mode, `jsonut` is faster than dynamic calls, and ~3% slower at decoding.

In short, the overhead is minimal compared to the benefits.

## Contributing

The following are guidelines for contributing to this package:

- **Issues**: Open an issue for any non-trivial change you'd like to make.
- **Pull Requests**: Open a PR against the `main` branch.
- **Testing**: Add tests for any new functionality or behavior changes.
- **Dependencies**: Avoid adding dependencies (dev-dependencies are fine~ish).

To check code coverage locally, run:

```sh
# Generate coverage report
dart run coverage:test_with_coverage -- -P coverage

# Open coverage report if you have `genhtml` installed
genhtml coverage/lcov.info -o coverage/html && open coverage/html/index.html
```
