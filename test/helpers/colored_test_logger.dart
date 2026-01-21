import 'dart:io';

/// Utilitário para imprimir mensagens coloridas durante os testes
class ColoredTestLogger {
  // Códigos ANSI para cores
  static const String _reset = '\x1B[0m';
  static const String _red = '\x1B[31m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _blue = '\x1B[34m';
  static const String _magenta = '\x1B[35m';
  static const String _cyan = '\x1B[36m';
  static const String _bold = '\x1B[1m';

  // Verifica se o terminal suporta cores
  static bool get _supportsColors {
    return stdout.supportsAnsiEscapes || 
           Platform.environment.containsKey('TERM') &&
           Platform.environment['TERM']!.contains('color');
  }

  /// Imprime mensagem de erro em vermelho
  static void error(String message, [Object? error]) {
    final errorText = error != null ? ': $error' : '';
    final coloredMessage = _supportsColors 
        ? '$_red$_bold❌ $message$errorText$_reset'
        : '❌ $message$errorText';
    // Usa stderr para garantir que as cores sejam exibidas mesmo quando stdout é redirecionado
    stderr.writeln(coloredMessage);
  }

  /// Imprime mensagem de sucesso em verde
  static void success(String message) {
    final coloredMessage = _supportsColors
        ? '$_green$_bold✅ $message$_reset'
        : '✅ $message';
    // Usa stderr para garantir que as cores sejam exibidas mesmo quando stdout é redirecionado
    stderr.writeln(coloredMessage);
  }

  /// Imprime mensagem de aviso em amarelo
  static void warning(String message) {
    final coloredMessage = _supportsColors
        ? '$_yellow$_bold⚠️  $message$_reset'
        : '⚠️  $message';
    stderr.writeln(coloredMessage);
  }

  /// Imprime mensagem informativa em azul
  static void info(String message) {
    final coloredMessage = _supportsColors
        ? '$_blue$_boldℹ️  $message$_reset'
        : 'ℹ️  $message';
    stderr.writeln(coloredMessage);
  }

  /// Imprime mensagem de debug em ciano
  static void debug(String message) {
    final coloredMessage = _supportsColors
        ? '$_cyan$_bold🔍 $message$_reset'
        : '🔍 $message';
    stderr.writeln(coloredMessage);
  }

  /// Imprime mensagem destacada em magenta
  static void highlight(String message) {
    final coloredMessage = _supportsColors
        ? '$_magenta$_bold💡 $message$_reset'
        : '💡 $message';
    stderr.writeln(coloredMessage);
  }

  /// Imprime separador colorido
  static void separator([String? label]) {
    if (label != null) {
      final line = _supportsColors 
          ? '$_cyan$_bold━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$_reset'
          : '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
      final labelText = _supportsColors
          ? '$_cyan$_bold  $label$_reset'
          : '  $label';
      stderr.writeln(line);
      stderr.writeln(labelText);
      stderr.writeln(line);
    } else {
      final line = _supportsColors
          ? '$_cyan━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$_reset'
          : '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
      stderr.writeln(line);
    }
  }
}
