/// monkeydart, Thorsten Ball monkey interpreter written in Dart
///
/// ```sh
/// # activate monkeydart
/// dart pub global activate monkeydart
///
/// # see usage
/// mkay --help
/// ```
library monkeydart;

export './src/interpreter/lexer.dart' show Lexer, stringNull;
export './src/interpreter/parser.dart'
    show
        ExpressionStatement,
        Identifier,
        LetStatement,
        Parser,
        PrefixExpression,
        Program,
        ReturnStatement;
export './src/interpreter/repl.dart' show REPL;
export './src/interpreter/token.dart' show Token, TokenType;
