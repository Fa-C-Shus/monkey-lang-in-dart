// ignore_for_file: omit_local_variable_types, prefer_conditional_assignment

/*
 * Project: interpreter
 * Created Date: Monday May 29th 2023 4:39:10 pm
 * Author: Fa C Shus (paul@facshus.com)
 * -----
 * Last Modified: Monday, 29th May 2023 4:39:10 pm
 * Modified By: Fa C Shus (paul@facshus.com)
 * -----
 * Copyright (c) 2021 - 2023 FaCShus Systems
 * License: MIT
 */

import 'package:monkeydart/monkeydart.dart';

enum Precedence {
  // ignore: unused_field
  _, // not a real precedent
  lowest,
  equals, // ==
  lessGreater, // > or <
  sum, // +
  product, // *
  prefix, // -X or !X
  call, // myFunction(X)
}

Map<TokenType, Precedence> precedences() {
  return {
    TokenType.eq: Precedence.equals,
    TokenType.ne: Precedence.equals,
    TokenType.lt: Precedence.lessGreater,
    TokenType.gt: Precedence.lessGreater,
    TokenType.plus: Precedence.sum,
    TokenType.dash: Precedence.sum,
    TokenType.slash: Precedence.product,
    TokenType.asterisk: Precedence.product,
  };
}

/// Basic element of a program
class Node {
  Node(this.token);
  final Token token;
  String tokenLiteral() {
    return token.value;
  }

  @override
  String toString() {
    return '${token.type.name} ${token.value}';
  }
}

/// Statements do not return values
class Statement extends Node {
  Statement(super.token);
  @override
  String toString() {
    return token.value;
  }
}

/// Expressions return values
class Expression extends Node {
  Expression(super.token);
}

class Identifier extends Expression {
  Identifier(this.value) : super(Token.ident(value));
  final String value;
  @override
  String toString() {
    return value;
  }
}

class LetStatement extends Statement {
  LetStatement(this.name, this.value) : super(const Token.let());
  final Identifier name;
  final Expression value;
  @override
  String toString() {
    return '${token.type.name} ${name.value} = ${value.token.value};';
  }
}

class ReturnStatement extends Statement {
  ReturnStatement(this.returnValue) : super(const Token.return_());
  final Expression returnValue;
  @override
  String toString() {
    return '${token.type} ${returnValue.token.value};';
  }
}

class ExpressionStatement extends Statement {
  ExpressionStatement(this.expression) : super(expression.token);
  final Expression expression;
  @override
  String toString() {
    final retVal = StringBuffer(expression);
    return retVal.toString();
  }
}

class PrefixExpression extends Expression {
  PrefixExpression(super.token, this.operator, this.right);
  final String operator;
  final Expression right;

  @override
  String toString() {
    return '($operator$right)';
  }
}

class InfixExpression extends Expression {
  InfixExpression(
    super.token,
    this.left,
    this.operator,
    this.right,
  );
  final Expression left;
  final String operator;
  final Expression right;

  @override
  String tokenLiteral() {
    return token.value;
  }

  @override
  String toString() {
    return '($left $operator $right)';
  }
}

class Program extends Node {
  Program() : super(const Token.eof());
  final List<Statement> statements = [];
  @override
  String tokenLiteral() {
    if (statements.isNotEmpty) {
      return statements.first.token.value;
    }
    return '';
  }

  @override
  String toString() {
    return statements.join();
  }
}

class IntegerLiteral extends Expression {
  IntegerLiteral(this.value) : super(Token.int(value.toString()));
  final int value;
  @override
  String toString() {
    return token.value;
  }
}

class Parser {
  Parser(this.lexer) {
    // grab the first token from the lexer
    _curToken = lexer.nextToken();
    // grab the second token from the lexer
    _peekToken = lexer.nextToken();
    initInfixAndPrefixFns();
  }

  void initInfixAndPrefixFns() {
    registerPrefix(TokenType.ident, _parseIdentifier);
    registerPrefix(TokenType.int, _parseIntegerLiteral);
    registerPrefix(TokenType.bang, _parsePrefixExpression);
    registerPrefix(TokenType.dash, _parsePrefixExpression);

    registerInfix(TokenType.gt, _parseInfixExpression);
    registerInfix(TokenType.lt, _parseInfixExpression);
    registerInfix(TokenType.plus, _parseInfixExpression);
    registerInfix(TokenType.dash, _parseInfixExpression);
    registerInfix(TokenType.slash, _parseInfixExpression);
    registerInfix(TokenType.asterisk, _parseInfixExpression);
    registerInfix(TokenType.eq, _parseInfixExpression);
    registerInfix(TokenType.ne, _parseInfixExpression);
  }

  final _prefixParseFns = <TokenType, Expression Function()>{};

  final _infixParseFns = <TokenType, Expression Function(Expression)>{};

  final Lexer lexer;
  late Token _curToken;
  late Token _peekToken;
  final _errors = <String>[];

  void _nextToken() {
    _curToken = _peekToken;
    _peekToken = lexer.nextToken();
  }

  List<String> get errors => _errors;

  bool _curTokenIs(TokenType type) {
    return _curToken.type == type;
  }

  bool _peekTokenIs(TokenType type) {
    return _peekToken.type == type;
  }

  bool _expectPeek(TokenType type) {
    if (_peekTokenIs(type)) {
      _nextToken();
      return true;
    } else {
      _peekError(type);
      return false;
    }
  }

  void _peekError(TokenType type) {
    _errors.add(
      'expected next token to be $type, got ${_peekToken.type} instead',
    );
  }

  Precedence _curPrecedence() {
    final precedence = precedences()[_curToken.type];
    if (precedence != null) {
      return precedence;
    }
    return Precedence.lowest;
  }

  Precedence _peekPrecedence() {
    final precedence = precedences()[_peekToken.type];
    if (precedence != null) {
      return precedence;
    }
    return Precedence.lowest;
  }

  Program parseProgram() {
    final program = Program();
    while (!_curTokenIs(TokenType.eof)) {
      final stmt = _parseStatement();
      if (stmt != null) {
        program.statements.add(stmt);
      }
      _nextToken();
    }
    return program;
  }

  Statement? _parseStatement() {
    switch (_curToken.type) {
      case TokenType.let:
        return _parseLetStatement();
      case TokenType.return_:
        return _parseReturnStatement();
      // ignore: no_default_cases
      default:
        return _parseExpressionStatement();
    }
  }

  Statement? _parseReturnStatement() {
    _nextToken();

    final returnStatement = ReturnStatement(Expression(_curToken));
    if (_peekToken.type != TokenType.semicolon) {
      // eat the end of line token
      // coverage:ignore-start
      _nextToken();
      return null;
      // coverage:ignore-end
    } else {
      _nextToken();
    }
    return returnStatement;
  }

  Statement? _parseLetStatement() {
    /// We must have a let token to be in the function
    /// our next token must be an identifier
    if (!_expectPeek(TokenType.ident)) {
      return null;
    }

    // I feel good that I have an identifier / expectPeek advanced the token
    final name = Identifier(_curToken.value);

    /// We now have Let identifier and expect an assignment token
    if (!_expectPeek(TokenType.assign)) {
      // parseError()
      return null;
    }

    _nextToken();

    /// We should nw have Let identifier = _____
    /// and we expect an expression as a value
    final value = Expression(_curToken);

    final letStatement = LetStatement(name, value);

    if (_peekToken.type != TokenType.semicolon) {
      // eat the end of line token
      // coverage:ignore-start
      _nextToken();
      return null;
      // coverage:ignore-end
    } else {
      _nextToken();
    }

    return letStatement;
  }

  void registerPrefix(TokenType type, Expression Function() fn) {
    _prefixParseFns[type] = fn;
  }

  void registerInfix(TokenType type, Expression Function(Expression) fn) {
    _infixParseFns[type] = fn;
  }

  void _noPrefixParseFnError(Token t) {
    _errors
        .add('no prefix parse functions found for ${t.type.name}:(${t.value})');
  }

  // coverage:ignore-start
  void _noInfixParseFnError(Token t) {
    _errors
        .add('no infix parse functions found for ${t.type.name}:(${t.value})');
  }
  // coverage:ignore-end

  ExpressionStatement? _parseExpressionStatement() {
    final expression = _parseExpression(Precedence.lowest);
    if (expression == null) {
      return null;
    }
    final stmt = ExpressionStatement(expression);
    if (_peekTokenIs(TokenType.semicolon)) {
      _nextToken();
    }
    return stmt;
  }

  Expression _parseInfixExpression(Expression left) {
    final curToken = _curToken;
    final operator = curToken.value;
    final precedence = _curPrecedence();
    _nextToken();
    final right = _parseExpression(precedence);
    //coverage:ignore-start
    Expression? rite = right;
    if (rite == null) {
      // coverage:ignore-line
      rite = Expression(curToken);
    }
    final expression = InfixExpression(
      curToken,
      left,
      operator,
      rite,
    );

    //coverage:ignore-end
    return expression;
  }

  Expression _parsePrefixExpression() {
    final curToken = _curToken;
    _nextToken();
    final right = _parseExpression(Precedence.prefix);
    Expression? rite = right;
    if (rite == null) {
      // coverage:ignore-line
      rite = Expression(curToken);
    }
    final expression = PrefixExpression(
      curToken,
      curToken.value,
      rite,
    );
    return expression;
  }

  Expression? _parseExpression(Precedence precedence) {
    final prefix = _prefixParseFns[_curToken.type];
    if (prefix == null) {
      // no prefix parse function found
      _noPrefixParseFnError(_curToken);
      return null;
    }
    var leftExp = prefix();

    while (!_peekTokenIs(TokenType.semicolon) &&
        precedence.index < _peekPrecedence().index) {
      final infix = _infixParseFns[_peekToken.type];
      // coverage:ignore-start
      if (infix == null) {
        // no infix parse function found
        _noInfixParseFnError(_peekToken);
        return leftExp;
      }
      // coverage:ignore-end
      _nextToken();
      leftExp = infix(leftExp);
    }

    return leftExp;
  }

  Expression _parseIdentifier() {
    return Identifier(_curToken.value);
  }

  Expression _parseIntegerLiteral() {
    return IntegerLiteral(int.parse(_curToken.value));
  }
}
