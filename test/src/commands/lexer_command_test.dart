/*
 * Project: commands
 * Created Date: Friday May 26th 2023 1:44:47 pm
 * Author: Fa C Shus (paul@facshus.com)
 * -----
 * Last Modified: Friday, 26th May 2023 1:44:47 pm
 * Modified By: Fa C Shus (paul@facshus.com)
 * -----
 * Copyright (c) 2021 - 2023 FaCShus Systems
 * License: MIT
 */

import 'package:mason_logger/mason_logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monkeydart/src/command_runner.dart';
import 'package:test/test.dart';

class _MockLogger extends Mock implements Logger {}

void main() {
  group('lexer command', () {
    late Logger logger;
    late MonkeydartCommandRunner commandRunner;

    setUp(() {
      logger = _MockLogger();
      commandRunner = MonkeydartCommandRunner(logger: logger);
    });

    test(
      'should return snarky message when no arguments are passed',
      () async {
        // arrange
    
        // act
        final exitCode = await commandRunner.run(['lexer']);

        // assert
        expect(exitCode, ExitCode.success.code);

        verify(
          () => logger.info('No arguments passed; what did you want me to do?'),
        ).called(1);
      },
    );
    group('from file', () {
      late String filePath;
      late String badFilePath;
      setUp(() {
        filePath = 'test/fixtures/lexer_test.txt';
        badFilePath = 'test/fixtures/mixerpixelate.txt';
      });
      test(
        'should return the tokens from the file by abbrev',
        () async {
          // arrange

          // act
          final exitCode = await commandRunner.run(['lexer', '-f', filePath]);

          // assert
          expect(exitCode, ExitCode.success.code);

          verify(
            () => logger.info('<ident> => add'),
          ).called(3);
          // verify(
          //   () =>
          //       logger.info('<let> =>'),
          // ).called(5);
          // verify(
          //   () =>
          //       logger.info('<ident> => five'),
          // ).called(1);
        },
      );
      test(
        'should return the tokens from the file by abbrev',
        () async {
          // arrange

          // act
          final exitCode =
              await commandRunner.run(['lexer', '--file', filePath]);

          // assert
          expect(exitCode, ExitCode.success.code);

          verify(
            () => logger.info('<ident> => add'),
          ).called(3);
          // verify(
          //   () =>
          //       logger.info('<let> =>'),
          // ).called(5);
          // verify(
          //   () =>
          //       logger.info('<ident> => five'),
          // ).called(1);
        },
      );
      test(
        'should return an error when the file does not exist',
        () async {
          // arrange

          // act
          final exitCode =
              await commandRunner.run(['lexer', '-f', badFilePath]);

          // assert
          expect(exitCode, ExitCode.usage.code);

          verify(
            () => logger.alert('File does not exist'),
          ).called(1);
        },
      );
    });

    group('from args', () {
      test(
        'should return the tokens from the args',
        () async {
          // arrange

          // act
          // lexer let add = fn(x, y) { x + y; };
          final exitCode = await commandRunner.run([
            'lexer',
            'let',
            'add',
            '=',
            'fn(x,y)',
            '{',
            'x',
            '+',
            'y;};',
          ]);

          // assert
          expect(exitCode, ExitCode.success.code);

          verify(
            () => logger.info('Arguments passed'),
          ).called(1);
          verify(
            () => logger.info('<assign> => ='),
          ).called(1);
        },
      );
    });
  });
}
