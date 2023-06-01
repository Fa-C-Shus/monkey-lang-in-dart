/*
 * Project: commands
 * Created Date: Wednesday May 31st 2023 5:05:35 pm
 * Author: Fa C Shus (paul@facshus.com)
 * -----
 * Last Modified: Wednesday, 31st May 2023 5:05:35 pm
 * Modified By: Fa C Shus (paul@facshus.com)
 * -----
 * Copyright (c) 2021 - 2023 FaCShus Systems
 * License: MIT
 */

import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:monkeydart/monkeydart.dart';

/// {@template sample_command}
///
/// `mkay lexer`
/// A [Command] to exemplify a sub command
/// {@endtemplate}
class ReplCommand extends Command<int> {
  /// {@macro sample_command}
  ReplCommand({
    required Logger logger,
  }) : _logger = logger {
    // argParser.addOption(
    //   'file',
    //   abbr: 'f',
    //   help: 'Tokenizes a file',
    //   valueHelp: 'path/to/file',
    //   callback: (value) {
    //     filePath = value;
    //   },
    // );
  }

  @override
  String get description => '''
The R(ead)E(val)P(rint)L(oop) command lets use the interpreter interactively)
''';

  @override
  String get name => 'repl';

  final Logger _logger;
  String? filePath;

  @override
  Future<int> run() async {
    final repl = REPL(logger: _logger);
    await repl.run();

    return ExitCode.success.code;
  }
}
