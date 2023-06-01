/*
 * Project: interpreter
 * Created Date: Monday May 29th 2023 6:31:52 pm
 * Author: Fa C Shus (paul@facshus.com)
 * -----
 * Last Modified: Monday, 29th May 2023 6:31:52 pm
 * Modified By: Fa C Shus (paul@facshus.com)
 * -----
 * Copyright (c) 2021 - 2023 FaCShus Systems
 * License: MIT
 */

// import 'package:mason_logger/mason_logger.dart';
import 'package:monkeydart/monkeydart.dart';
import 'package:monkeydart/src/interpreter/parser.dart';
import 'package:test/test.dart';

class InfixTrial {
  InfixTrial({
    required this.input,
    required this.leftOperand,
    required this.operator,
    required this.rightOperand,
  });
  final String input;
  final int leftOperand;
  final String operator;
  final int rightOperand;
}

/* ===========================
Test Helper Functions
=========================== */ 

bool testIntegerLiteral(dynamic actual, int value) {
  expect(actual, isA<IntegerLiteral>());
  expect((actual as IntegerLiteral).value, equals(value));
  expect(actual.tokenLiteral(), equals(value.toString()));
  return true;
}

bool testIdentifier(dynamic actual, String value) {
  expect(actual, isA<Identifier>());
  expect((actual as Identifier).value, equals(value));
  expect(actual.tokenLiteral(), equals(value));
  return true;
}

bool testLiteralExpression(dynamic actual, dynamic expected) {
  if (expected is int) {
    return testIntegerLiteral(actual, expected);
  } else if (expected is String) {
    return testIdentifier(actual, expected);
  // } else if (expected is bool) {
  //   return testBooleanLiteral(actual, expected);
  }
  throw Exception('type of actual not handled');
}

bool testInfixExpression(
  dynamic actual,
  dynamic left,
  String operator,
  dynamic right,
) {
  expect(actual, isA<InfixExpression>());
  expect((actual as InfixExpression).operator, equals(operator));
  testLiteralExpression((actual as InfixExpression).left, left);
  testLiteralExpression((actual as InfixExpression).right, right);
  return true;
}

// bool testBooleanLiteral(dynamic actual, bool value) {
//   expect(actual, isA<BooleanLiteral>());
//   expect((actual as BooleanLiteral).value, equals(value));
//   expect(actual.tokenLiteral(), equals(value.toString()));
//   return true;
// }


void main() {
  group('Parser', () {
    // late Logger logger;
    late Lexer lexer;
    late Map<String, List<String>> positiveLetTests;
    late Map<String, List<String>> negativeLetTests;
    late Map<String, List<String>> positiveReturnTests;
    // late Map<String, List<String>> negativeReturnTests;

    setUp(() {
      // logger = Logger();
      // ~ is an illegal token
      positiveLetTests = {
        '''
        let x = 5;
        let y = 10;
        let foobar = 838383;''': ['x', 'y', 'foobar']
      };
      positiveReturnTests = {
        '''
        return 5;
        return 10;
        return 993322;''': ['x', 'y', 'foobar']
      };
      negativeLetTests = {
        '''
        let x 5;
        let = 10;
        let 838383;''': ['x', 'y', 'foobar']
      };
      lexer = Lexer(positiveLetTests.keys.first);
    });
    test('should return a Parser when initialized', () {
      // arrange

      // act
      final actual = Parser(lexer);

      // assert
      expect(actual, isA<Parser>());
    });

    test(
      'should return a Program w/ 3 let stmts when parseProgram is called',
      () async {
        // arrange
        final actual = Parser(lexer);

        // act
        final program = actual.parseProgram();

        // assert
        expect(program, isNotNull);
        expect(program.statements.length, equals(3));

        for (var i = 0; i < positiveLetTests.values.first.length; i++) {
          expect(program.statements[i], isA<LetStatement>());
          expect(program.statements[i].token, const Token.let());
          expect(
            (program.statements[i] as LetStatement).name.value,
            equals(positiveLetTests.values.first[i]),
          );
          expect(
            (program.statements[i] as LetStatement).name.tokenLiteral(),
            equals(positiveLetTests.values.first[i]),
          );
          expect(actual.errors, isEmpty);
        }
      },
    );
    test(
      'should return a Program w/ 3 return stmts when parseProgram is called',
      () async {
        // arrange
        lexer = Lexer(positiveReturnTests.keys.first);
        final actual = Parser(lexer);

        // act
        final program = actual.parseProgram();

        // assert
        expect(program, isNotNull);
        expect(program.statements.length, equals(3));

        for (var i = 0; i < positiveReturnTests.values.first.length; i++) {
          expect(program.statements[i], isA<ReturnStatement>());
          expect(program.statements[i].token, const Token.return_());
          expect(
            (program.statements[i] as ReturnStatement).tokenLiteral(),
            equals('return'),
          );
          expect(actual.errors, isEmpty);
        }
      },
    );

    test(
      'should return errors when parseProgram is called with illegal tokens',
      () async {
        // arrange
        lexer = Lexer(negativeLetTests.keys.first);
        final actual = Parser(lexer);

        // act
        final _ = actual.parseProgram();

        // assert
        expect(actual.errors, isNotEmpty);
      },
    );
  });

  group('Parser toString()', () {
    late String input;

    setUp(() {
      input = 'let myVar = AnotherVar;';
    });

    test(
      'should return a string representation of the program',
      () async {
        // arrange

        // act
        final program = Program();
        program.statements
            .add(LetStatement(Identifier('myVar'), Identifier('AnotherVar')));

        // assert
        expect(program.toString(), 'let myVar = AnotherVar;');
      },
    );
  });

  group('Parser Expressions', () {
    test(
      'should return an expression(foobar) stmt when parseProgram is called',
      () async {
        // arrange
        const input = 'foobar;';
        final lexer = Lexer(input);
        final parser = Parser(lexer);

        // act
        final program = parser.parseProgram();

        // assert
        expect(program.statements.length, 1);
        expect(parser.errors, isEmpty);
        expect(program.statements.first, isA<ExpressionStatement>());
        expect(program.statements.first.token, const Token.ident('foobar'));
      },
    );
    test(
      'should return an expression(5) statement when parseProgram is called',
      () async {
        // arrange
        const input = '5;';
        final lexer = Lexer(input);
        final parser = Parser(lexer);

        // act
        final program = parser.parseProgram();

        // assert
        expect(program.statements.length, 1);
        expect(parser.errors, isEmpty);
        expect(program.statements.first, isA<ExpressionStatement>());
        expect(program.statements.first.token, const Token.int('5'));
      },
    );
  });

  group('Parser - Prefix operators', () {
    late Lexer lexer;
    late Map<String, List<Object>> positiveTests;
    setUp(() {
      positiveTests = {
        '!5;': ['!', 5],
        '-15;': ['-', 15]
      };
    });

    test(
      'should return a PrefixExpression when parseProgram is called',
      () async {
        // arrange
        lexer = Lexer(positiveTests.keys.first);
        final parser = Parser(lexer);

        // act
        final program = parser.parseProgram();

        // assert
        expect(program.statements.length, 1);
        expect(program.statements.first, isA<ExpressionStatement>());
        expect(
          (program.statements.first as ExpressionStatement).expression,
          isA<PrefixExpression>(),
        );
        expect(program.statements.first.tokenLiteral(), '!');
        expect(
          ((program.statements.first as ExpressionStatement).expression
                  as PrefixExpression)
              .right,
          isA<IntegerLiteral>(),
        );
        expect(
          ((program.statements.first as ExpressionStatement).expression
                  as PrefixExpression)
              .right
              .tokenLiteral(),
          '5',
        );
      },
    );
  });

  group('Parser - Infix operators', () {
    late List<InfixTrial> trials;
    setUp(() {
      trials = [];
      final operators = ['+', '-', '*', '/', '>', '<', '==', '!='];
      for (final operator in operators) {
        final trial = InfixTrial(
          input: '5 $operator 7;',
          leftOperand: 5,
          operator: operator,
          rightOperand: 7,
        );
        trials.add(trial);
      }
    });
    test(
      'should return an InfixExpression when parseProgram is called',
      () async {
        // arrange - act - assert
        for (final trial in trials) {
          final lexer = Lexer(trial.input);
          final parser = Parser(lexer);
          final program = parser.parseProgram();
          for (final stmt in program.statements) {
            print(
              (program.statements.first as ExpressionStatement).expression
                  as InfixExpression,
            );
          }
          expect(program.statements.length, 1);
          expect(program.statements.first, isA<ExpressionStatement>());
          expect(
            (program.statements.first as ExpressionStatement).expression,
            isA<InfixExpression>(),
          );
          expect(program.statements.first.tokenLiteral(), trial.operator);
          expect(
            ((program.statements.first as ExpressionStatement).expression
                    as InfixExpression)
                .left,
            isA<IntegerLiteral>(),
          );
          expect(
            ((program.statements.first as ExpressionStatement).expression
                    as InfixExpression)
                .left
                .tokenLiteral(),
            trial.leftOperand.toString(),
          );
          expect(
            ((program.statements.first as ExpressionStatement).expression
                    as InfixExpression)
                .operator,
            trial.operator,
          );
          expect(
            ((program.statements.first as ExpressionStatement).expression
                    as InfixExpression)
                .right,
            isA<IntegerLiteral>(),
          );
          expect(
            ((program.statements.first as ExpressionStatement).expression
                    as InfixExpression)
                .right
                .tokenLiteral(),
            trial.rightOperand.toString(),
          );
        }
      },
    );
  });

  group('Parser - order of precedence', () {
    late Lexer lexer;
    late Map<String, String> positiveTests;
    setUp(() {
      positiveTests = {
        '!-a;': '(!(-a))',
        '!-a+b;': '((!(-a)) + b)',
        'a + b + c;': '((a + b) + c)',
        'a + b - c;': '((a + b) - c)',
        'a * b * c;': '((a * b) * c)',
        'a * b / c;': '((a * b) / c)',
        'a + b / c;': '(a + (b / c))',
        'a + b * c + d / e - f;': '(((a + (b * c)) + (d / e)) - f)',
        '3 + 4; -5 * 5;': '(3 + 4)((-5) * 5)',
        '5 > 4 == 3 < 4;': '((5 > 4) == (3 < 4))',
        '5 < 4 != 3 > 4;': '((5 < 4) != (3 > 4))',
        '3 + 4 * 5 == 3 * 1 + 4 * 5;': '((3 + (4 * 5)) == ((3 * 1) + (4 * 5)))',
      };
    });

    test(
      'should return the value string for each key in the tests map',
      () async {
        // arrange
        for (final item in positiveTests.entries) {
          lexer = Lexer(item.key);
          final parser = Parser(lexer);
          // act
          final program = parser.parseProgram();
          final actual = program.toString();
          for (final stmt in program.statements) {
            print('${item.key} => ${stmt}');
          }
          // assert
          expect(parser.errors, isEmpty);
          expect(actual, item.value);
        }

        // act

        // assert
      },
    );
  });
}
