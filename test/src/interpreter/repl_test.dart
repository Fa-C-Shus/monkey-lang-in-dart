/*
 * Project: interpreter
 * Created Date: Friday May 26th 2023 7:19:58 pm
 * Author: Fa C Shus (paul@facshus.com)
 * -----
 * Last Modified: Friday, 26th May 2023 7:19:58 pm
 * Modified By: Fa C Shus (paul@facshus.com)
 * -----
 * Copyright (c) 2021 - 2023 FaCShus Systems
 * License: MIT
 */

import 'dart:convert';
import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monkeydart/monkeydart.dart';
import 'package:test/test.dart';

class _MockLogger extends Mock implements Logger {}

class _MockStdin extends Mock implements Stdin {}

void main() {
  group('REPL instantiation', () {
    test(
      'should return a REPL when initialized',
      () async {
        // arrange
        final logger = _MockLogger();
        final stdIn = _MockStdin();

        // act
        final actual = REPL(logger: logger, stdIn: stdIn);

        // assert
        expect(actual, isA<REPL>());
      },
    );
  });

  group('REPL cli interaction', () {
    test(
      'should exit quickly when exit is entered',
      () async {
        // arrange
        final logger = _MockLogger();
        final stdIn = _MockStdin();
        when(() => stdIn.readLineSync(encoding: utf8)).thenReturn('exit');
        final repl = REPL(logger: logger, stdIn: stdIn);

        // act
        await repl.run();

        // assert
        verify(() => logger.warn('Bye!')).called(1);
      },
    );

    test(
      'should display two prompts when empty line is entered',
      () async {
        // arrange
        final logger = _MockLogger();
        final stdIn = _MockStdin();
        when(() => stdIn.readLineSync(encoding: utf8)).thenReturn('hello');
        final repl = REPL(logger: logger, stdIn: stdIn);

        // act
        await repl.evalLine('hello');

        // assert
        verify(() => logger.info('<ident> => hello')).called(1);
      },
    );
  });
}
