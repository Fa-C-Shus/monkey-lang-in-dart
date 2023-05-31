## monkeydart

![coverage][coverage_badge]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

Generated by the [Very Good CLI][very_good_cli_link] 🤖

Thorsten Ball monkey interpreter written in Dart.

---

## Getting Started 🚀

If the CLI application is available on [pub](https://pub.dev), activate globally via:

```sh
dart pub global activate monkeydart
```

Or locally via:

```sh
dart pub global activate --source=path <path to this package>
```

## Build locally
source: (https://dart.dev/tools/dart-compile)

```sh
$ dart compile ./bin/mkay.dart
# Generates: ./bin/mkay.exe
```


## Usage

```sh
# Lexer command - some environments will expand the arguments, so escaping may be required
$ mkay lexer let x = 5;

# Sample command option
$ mkay lexer --file ./test/fictures/example.txt

# Show CLI version
$ mkay --version

# Show usage help
$ mkay --help
```

## Running Tests with coverage 🧪

To run all unit tests use the following command:

```sh
$ dart pub global activate coverage 1.6.3
$ dart run test --coverage=./coverage
$ dart pub global run coverage:format_coverage --packages=.dart_tool/package_config.json --report-on=lib --lcov -o ./coverage/lcov.info 
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov)
.

```sh
# Generate Coverage Report
$ genhtml -o ./coverage/report ./coverage/lcov.info

# Open Coverage Report
$ open ./coverage/report/index.html
```

---

[coverage_badge]: coverage_badge.svg
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli