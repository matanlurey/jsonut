# JSON Utility Kit

A minimal utility kit for working with JSON in a type-safe manner.

![GitHub Actions Workflow Status](https://github.com/matanlurey/jsonut.dart/actions/workflows/dart.yml/badge.svg)

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
  print(person.string('name')); // John Doe
  print(person.number('age')); // 42
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
  jsonut: ^0.1.0
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
