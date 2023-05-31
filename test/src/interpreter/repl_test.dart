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

// import 'dart:convert';
// import 'dart:io';

// import 'package:mason_logger/mason_logger.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:monkeydart/monkeydart.dart';
// import 'package:test/test.dart';

// class _MockLogger extends Mock implements Logger {}

// class _MockStdin extends Mock implements Stdin {}

// void main() {
//   group('REPL', () {
//     test(
//       'should return a REPL when initialized',
//       () async {
//         // arrange

//         // act
//         final actual = REPL();

//         // assert

//         // await
//         expect(actual, isA<REPL>());
//       },
//     );

//     group('test inputs', () {
//       late Logger logger;
//       late Stdin stdIn;
//       late REPL repl;

//       setUp(() {
//         logger = _MockLogger();
//         stdIn = _MockStdin();
//         repl = REPL(logger: logger, stdIn: stdIn);

//         // when(logger.warn(any())).thenReturn();
//       });

//       test(
//         'should exit quickly when exit is entered',
//         () async {
//           // arrange
//           when(() => stdIn.readLineSync(encoding: utf8)).thenReturn('exit');

//           // act
//           await repl.run();

//           // assert
//           verify(() => logger.warn('Bye!')).called(1);
//           verify(
//             () => logger.info('Welcome to the Monkey Programming Language'),
//           ).called(1);
//           verify(
//             () => logger.info('Feel free to type in commands'),
//           ).called(1);
//           verify(
//             () => logger.info('>> '),
//           ).called(1);
//         },
//       );
//       test(
//         'should two prompts when empty line is entered',
//         () async {
//           // arrange
//           repl = REPL(logger: logger);

//           // act
//           await repl.evalLine('hello');
//           await repl.evalLine('goodbye');

//           // assert
//           verify(
//             () => logger.info('<ident> => hello'),
//           ).called(1);
//           verify(
//             () => logger.info('<ident> => goodbye'),
//           ).called(1);
//         },
//       );
//     });
//   });
// }
