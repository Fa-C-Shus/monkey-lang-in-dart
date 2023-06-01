/*
 * Project: interpreter
 * Created Date: Friday May 26th 2023 10:09:04 am
 * Author: Fa C Shus (paul@facshus.com)
 * -----
 * Last Modified: Friday, 26th May 2023 10:09:04 am
 * Modified By: Fa C Shus (paul@facshus.com)
 * -----
 * Copyright (c) 2021 - 2023 FaCShus Systems
 * License: MIT
 */

import 'package:mason_logger/mason_logger.dart';
import 'package:monkeydart/monkeydart.dart';
import 'package:test/test.dart';

void main() {
  group('lexer', () {
    late Logger logger;
    late Map<String, List<Token>> positiveTests;
    late Map<String, List<Token>> negativeTests;

    setUp(() {
      logger = Logger();
      // ~ is an illegal token
      negativeTests = {
        '~': [const Token.illegal()]
      };
      positiveTests = {
        '=+(){},;': [
          const Token.assign(),
          const Token.plus(),
          const Token.lParen(),
          const Token.rParen(),
          const Token.lSquirly(),
          const Token.rSquirly(),
          const Token.comma(),
          const Token.semicolon()
        ],
        '''
let five = 5;
let ten = 10;
   let add = fn(x, y) {
     x + y;
};
   let result = add(five, ten);''': [
          const Token.let(),
          const Token.ident('five'),
          const Token.assign(),
          const Token.int('5'),
          const Token.semicolon(),
          const Token.let(),
          const Token.ident('ten'),
          const Token.assign(),
          const Token.int('10'),
          const Token.semicolon(),
          const Token.let(),
          const Token.ident('add'),
          const Token.assign(),
          const Token.function(),
          const Token.lParen(),
          const Token.ident('x'),
          const Token.comma(),
          const Token.ident('y'),
          const Token.rParen(),
          const Token.lSquirly(),
          const Token.ident('x'),
          const Token.plus(),
          const Token.ident('y'),
          const Token.semicolon(),
          const Token.rSquirly(),
          const Token.semicolon(),
          const Token.let(),
          const Token.ident('result'),
          const Token.assign(),
          const Token.ident('add'),
          const Token.lParen(),
          const Token.ident('five'),
          const Token.comma(),
          const Token.ident('ten'),
          const Token.rParen(),
          const Token.semicolon(),
          const Token.eof(),
        ],
        '''
let five = 5;
let ten = 10;
   let add = fn(x, y) {
     x + y;
};
   let result = add(five, ten);
   !-/*5;
   5 < 10 > 5;
   
   if (5 < 10) {
       return true;
   } else {
       return false;
}

10 == 10; 
10 != 9;
''': [
          const Token.let(),
          const Token.ident('five'),
          const Token.assign(),
          const Token.int('5'),
          const Token.semicolon(),
          const Token.let(),
          const Token.ident('ten'),
          const Token.assign(),
          const Token.int('10'),
          const Token.semicolon(),
          const Token.let(),
          const Token.ident('add'),
          const Token.assign(),
          const Token.function(),
          const Token.lParen(),
          const Token.ident('x'),
          const Token.comma(),
          const Token.ident('y'),
          const Token.rParen(),
          const Token.lSquirly(),
          const Token.ident('x'),
          const Token.plus(),
          const Token.ident('y'),
          const Token.semicolon(),
          const Token.rSquirly(),
          const Token.semicolon(),
          const Token.let(),
          const Token.ident('result'),
          const Token.assign(),
          const Token.ident('add'),
          const Token.lParen(),
          const Token.ident('five'),
          const Token.comma(),
          const Token.ident('ten'),
          const Token.rParen(),
          const Token.semicolon(),
          const Token.bang(),
          const Token.dash(),
          const Token.slash(),
          const Token.asterisk(),
          const Token.int('5'),
          const Token.semicolon(),
          const Token.int('5'),
          const Token.lessThan(),
          const Token.int('10'),
          const Token.greaterThan(),
          const Token.int('5'),
          const Token.semicolon(),
          const Token.if_(),
          const Token.lParen(),
          const Token.int('5'),
          const Token.lessThan(),
          const Token.int('10'),
          const Token.rParen(),
          const Token.lSquirly(),
          const Token.return_(),
          const Token.true_(),
          const Token.semicolon(),
          const Token.rSquirly(),
          const Token.else_(),
          const Token.lSquirly(),
          const Token.return_(),
          const Token.false_(),
          const Token.semicolon(),
          const Token.rSquirly(),
          // 10 == 10;
          const Token.int('10'),
          const Token.equal(),
          const Token.int('10'),
          const Token.semicolon(),
          // 10 != 9;
          const Token.int('10'),
          const Token.notEqual(),
          const Token.int('9'),
          const Token.semicolon(),
          const Token.eof(),
        ]
      };
    });

    test(
      'should return an array of Tokens given the input of tests map',
      () async {
        // arrange - act - assert
        positiveTests.forEach((key, value) {
          final inputStream = key;
          final expected = value;
          final lexer = Lexer(inputStream);
          for (final expectation in expected) {
            final actual = lexer.nextToken();
            logger.info('expectation: $expectation  <=> actual: $actual');
            expect(actual, expectation);
          }
        });
      },
    );

    test(
      'should return an illegal token for the ~ character',
      () async {
        // arrange - act - assert
        negativeTests.forEach((key, value) {
          final inputStream = key;
          final expected = value;
          final lexer = Lexer(inputStream);
          for (final expectation in expected) {
            final actual = lexer.nextToken();
            logger.info('expectation: $expectation  <=> actual: $actual');
            expect(actual, expectation);
          }
        });
      },
    );
  });
}
