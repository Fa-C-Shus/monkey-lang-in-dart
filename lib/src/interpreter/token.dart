/*
 * Project: interpreter
 * Created Date: Friday May 26th 2023 10:07:35 am
 * Author: Fa C Shus (paul@facshus.com)
 * -----
 * Last Modified: Friday, 26th May 2023 10:07:35 am
 * Modified By: Fa C Shus (paul@facshus.com)
 * -----
 * Copyright (c) 2021 - 2023 FaCShus Systems
 * License: MIT
 */

import 'package:equatable/equatable.dart';
import 'package:monkeydart/monkeydart.dart';

class Token extends Equatable {
  // variable values
  const Token.ident(this.value) : type = TokenType.ident;
  const Token.int(this.value) : type = TokenType.int;

  // keywords
  const Token.let()
      : type = TokenType.let,
        value = 'let';
  const Token.function()
      : type = TokenType.function,
        value = 'fn';
  const Token.true_()
      : type = TokenType.true_,
        value = 'true';
  const Token.false_()
      : type = TokenType.false_,
        value = 'false';
  const Token.if_()
      : type = TokenType.if_,
        value = 'if';
  const Token.else_()
      : type = TokenType.else_,
        value = 'else';
  const Token.return_()
      : type = TokenType.return_,
        value = 'return';

  const Token.illegal()
      : type = TokenType.illegal,
        value = stringNull;
  const Token.eof()
      : type = TokenType.eof,
        value = stringNull;

  const Token.assign()
      : type = TokenType.assign,
        value = '=';
  const Token.equal()
      : type = TokenType.eq,
        value = '==';
  const Token.notEqual()
      : type = TokenType.ne,
        value = '!=';
  const Token.plus()
      : type = TokenType.plus,
        value = '+';
  const Token.dash()
      : type = TokenType.dash,
        value = '-';
  const Token.bang()
      : type = TokenType.bang,
        value = '!';
  const Token.asterisk()
      : type = TokenType.asterisk,
        value = '*';
  const Token.slash()
      : type = TokenType.slash,
        value = '/';
  const Token.greaterThan()
      : type = TokenType.gt,
        value = '>';
  const Token.lessThan()
      : type = TokenType.lt,
        value = '<';
  const Token.comma()
      : type = TokenType.comma,
        value = ',';
  const Token.semicolon()
      : type = TokenType.semicolon,
        value = ';';
  const Token.lParen()
      : type = TokenType.lParen,
        value = '(';
  const Token.rParen()
      : type = TokenType.rParen,
        value = ')';
  const Token.lSquirly()
      : type = TokenType.lSquirly,
        value = '{';
  const Token.rSquirly()
      : type = TokenType.rSquirly,
        value = '}';

  final String value;
  final TokenType type;

  @override
  String toString() => '<${type.name}> => $value';

  static Token? keyword(String ident) {
    final map = {
      'let': TokenType.let,
      'fn': TokenType.function,
      'if': TokenType.if_,
      'else': TokenType.else_,
      'return': TokenType.return_,
      'true': TokenType.true_,
      'false': TokenType.false_,
    };

    final type = map[ident];
    if (type != null) {
      if (type == TokenType.let) {
        return const Token.let();
      } else if (type == TokenType.function) {
        return const Token.function();
      } else if (type == TokenType.if_) {
        return const Token.if_();
      } else if (type == TokenType.else_) {
        return const Token.else_();
      } else if (type == TokenType.return_) {
        return const Token.return_();
      } else if (type == TokenType.true_) {
        return const Token.true_();
      } else if (type == TokenType.false_) {
        return const Token.false_();
      }
    }

    return null;
  }

  @override
  List<Object?> get props => [type, value];
}

enum TokenType {
  ident,
  int,
  let,
  illegal,
  eof,
  assign,
  plus,
  comma,
  semicolon,
  lParen,
  rParen,
  lSquirly,
  rSquirly,
  function,
  dash,
  bang,
  asterisk,
  slash,
  lt,
  gt,
  true_,
  false_,
  if_,
  else_,
  return_,
  ne,
  eq,
  // eq,
  // neq,
}
