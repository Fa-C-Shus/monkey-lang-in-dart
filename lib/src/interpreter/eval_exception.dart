/*
 * Project: interpreter
 * Created Date: Friday May 26th 2023 5:25:45 pm
 * Author: Fa C Shus (paul@facshus.com)
 * -----
 * Last Modified: Friday, 26th May 2023 5:25:45 pm
 * Modified By: Fa C Shus (paul@facshus.com)
 * -----
 * Copyright (c) 2021 - 2023 FaCShus Systems
 * License: MIT
 */

/// Exception in evaluation
class EvalException implements Exception {
  EvalException(
    String msg,
    Object x,
  ) : message = '$msg: $x';
  final String message;
  final List<String> trace = [];

  @override
  String toString() {
    final s = StringBuffer('EvalException: $message');
    for (final line in trace) {
      s.writeln('\n\t$line');
    }
    return s.toString();
  }
}
