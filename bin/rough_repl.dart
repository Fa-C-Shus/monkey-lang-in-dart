/*
 * Project: bin
 * Created Date: Saturday May 27th 2023 9:29:38 am
 * Author: Fa C Shus (paul@facshus.com)
 * -----
 * Last Modified: Saturday, 27th May 2023 9:29:38 am
 * Modified By: Fa C Shus (paul@facshus.com)
 * -----
 * Copyright (c) 2021 - 2023 FaCShus Systems
 * License: MIT
 */

import 'package:mason_logger/mason_logger.dart';
import 'package:monkeydart/monkeydart.dart';

final logger = Logger();

void main(List<String> args) async {
  final repl = REPL(logger: logger);
  await repl.run();
}
