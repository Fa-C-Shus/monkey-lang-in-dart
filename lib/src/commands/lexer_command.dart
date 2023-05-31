/*
 * Project: commands
 * Created Date: Friday May 26th 2023 10:45:07 am
 * Author: Fa C Shus (paul@facshus.com)
 * -----
 * Last Modified: Friday, 26th May 2023 10:45:07 am
 * Modified By: Fa C Shus (paul@facshus.com)
 * -----
 * Copyright (c) 2021 - 2023 FaCShus Systems
 * License: MIT
 */

import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:monkeydart/monkeydart.dart';

/// {@template sample_command}
///
/// `mkay lexer`
/// A [Command] to exemplify a sub command
/// {@endtemplate}
class LexerCommand extends Command<int> {
  /// {@macro sample_command}
  LexerCommand({
    required Logger logger,
  }) : _logger = logger {
    argParser.addOption(
      'file',
      abbr: 'f',
      help: 'Tokenizes a file',
      valueHelp: 'path/to/file',
      callback: (value) {
        filePath = value;
      },
    );
  }

  @override
  String get description =>
      'The lexer command lets you tokenize a file, or cli args';

  @override
  String get name => 'lexer';

  final Logger _logger;
  String? filePath;

  void _tokenize(String input) {
    final lexer = Lexer(input);
    for (var token = lexer.nextToken();
        token.type != TokenType.eof;
        token = lexer.nextToken()) {
      _logger.info(token.toString());
    }
  }

  @override
  Future<int> run() async {
    if (argResults == null || argResults!.arguments.isEmpty) {
      _logger.info('No arguments passed; what did you want me to do?');
    } else {
      if (argResults!['file'] != null) {
        final fileName = argResults!['file'] as String;
        final file = File(fileName);
        if (!file.existsSync()) {
          _logger.alert('File does not exist');
          return ExitCode.usage.code;
        }
        _logger
          ..info('File path passed')
          ..info(lightCyan.wrap(fileName));
        final input = file.readAsStringSync();
        _tokenize(input);
      } else {
        _logger.info('Arguments passed');
        _tokenize(argResults!.arguments.join(' '));
      }
    }

    return ExitCode.success.code;
  }
}
