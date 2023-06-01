// ignore_for_file: constant_identifier_names

/*
 * Project: interpreter
 * Created Date: Friday May 26th 2023 3:54:41 pm
 * Author: Fa C Shus (paul@facshus.com)
 * -----
 * Last Modified: Friday, 26th May 2023 3:54:42 pm
 * Modified By: Fa C Shus (paul@facshus.com)
 * -----
 * Copyright (c) 2021 - 2023 FaCShus Systems
 * License: MIT
 */

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:meta/meta.dart';
import 'package:monkeydart/monkeydart.dart';

class REPL {
  REPL({
    Logger? logger,
    String? prompt,
    Stdin? stdIn,
  })  : _logger = logger ?? Logger(),
        _prompt = prompt ?? '>> ',
        _stdin = stdIn ?? stdin;

  Future<void> run() async {
    _logger
      ..info('Welcome to the Monkey Programming Language')
      ..info('Feel free to type in commands')
      ..info('$_prompt ');

    try {
      // keep reading the stdin until you receive an 'exit' command
      while (true) {
        stdout.write(_prompt);
        final line = _stdin.readLineSync(encoding: utf8);
        await evalLine(line);
      }
    } catch (e) {
      _logger.alert('Error: $e');
    }
  }

  @visibleForTesting
  Future<void> evalLine(String? line) async {
    switch (line?.trim().toLowerCase()) {
      case null:
        break;
      case 'exit':
        _logger.warn('Bye!');
        exit(0);
      default:
        final lexer = Lexer(line!);
        final tokens = <Token>[];
        var token = lexer.nextToken();
        while (token.type != TokenType.eof) {
          tokens.add(token);
          token = lexer.nextToken();
        }
        for (final element in tokens) {
          // stdout.writeln(element.toString());
          _logger.info(element.toString());
        }
    }
  }

  late final Logger _logger;
  late final String _prompt;
  late final Stdin _stdin;
}

// class REPL {
//   REPL({
//     required SendPort sendPort,
//     Logger? logger,
//     String? prompt,
//   })  : _logger = logger ?? Logger(),
//         _prompt = prompt ?? '>> ',
//         _sendPort = sendPort {
//     start();
//   }

//   void start() {
//     _logger
//       ..info('Welcome to the Monkey Programming Language')
//       ..info('Feel free to type in commands')
//       ..info('$_prompt ');

//     try {
//       final rp = ReceivePort();
//       // allows for isolate transferring of stream
//       _sendPort.send(rp.sendPort);

//       // later we will instantiate a lexer and parser,
//       // and send in this as stdout

//       final rf = StreamIterator<String>(rp.cast<String>());
//       var reader = SourceReader(rf);
//       reader.read();
//     } catch (e) {
//       _logger.alert('Error: $e');
//     }
//   }

//   late SendPort _sendPort;
//   late Logger _logger;
//   late String _prompt;
// }
