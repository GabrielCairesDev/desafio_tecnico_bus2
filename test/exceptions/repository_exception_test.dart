import 'package:desafio_tecnico_bus2/shared/exceptions/repository_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RepositoryException', () {
    test('deve criar exceção com mensagem', () {
      final exception = RepositoryException('Erro genérico');

      expect(exception.message, 'Erro genérico');
      expect(exception.originalError, isNull);
      expect(exception.stackTrace, isNull);
    });

    test('deve criar exceção com erro original e stack trace', () {
      final originalError = Exception('Erro original');
      final stackTrace = StackTrace.current;

      final exception = RepositoryException(
        'Erro genérico',
        originalError: originalError,
        stackTrace: stackTrace,
      );

      expect(exception.message, 'Erro genérico');
      expect(exception.originalError, originalError);
      expect(exception.stackTrace, stackTrace);
    });

    test('deve retornar string formatada corretamente', () {
      final exception = RepositoryException('Erro genérico');

      expect(exception.toString(), 'RepositoryException: Erro genérico');
    });

    test('deve retornar string formatada com erro original', () {
      final originalError = Exception('Erro original');
      final exception = RepositoryException(
        'Erro genérico',
        originalError: originalError,
      );

      expect(
        exception.toString(),
        contains('RepositoryException: Erro genérico'),
      );
      expect(exception.toString(), contains('Original error'));
    });
  });

  group('UserRepositoryException', () {
    test('deve criar exceção específica de usuário', () {
      final exception = UserRepositoryException('Erro ao buscar usuários');

      expect(exception.message, 'Erro ao buscar usuários');
      expect(exception, isA<RepositoryException>());
    });

    test('deve criar exceção com erro original', () {
      final originalError = Exception('Erro de rede');
      final exception = UserRepositoryException(
        'Erro ao buscar usuários',
        originalError: originalError,
      );

      expect(exception.message, 'Erro ao buscar usuários');
      expect(exception.originalError, originalError);
    });

    test('deve retornar string formatada corretamente', () {
      final exception = UserRepositoryException('Erro ao buscar usuários');

      expect(
        exception.toString(),
        'UserRepositoryException: Erro ao buscar usuários',
      );
    });
  });

  group('UserStorageRepositoryException', () {
    test('deve criar exceção específica de armazenamento', () {
      final exception = UserStorageRepositoryException('Erro ao salvar usuário');

      expect(exception.message, 'Erro ao salvar usuário');
      expect(exception, isA<RepositoryException>());
    });

    test('deve criar exceção com erro original e stack trace', () {
      final originalError = Exception('Erro de persistência');
      final stackTrace = StackTrace.current;
      final exception = UserStorageRepositoryException(
        'Erro ao salvar usuário',
        originalError: originalError,
        stackTrace: stackTrace,
      );

      expect(exception.message, 'Erro ao salvar usuário');
      expect(exception.originalError, originalError);
      expect(exception.stackTrace, stackTrace);
    });

    test('deve retornar string formatada corretamente', () {
      final exception = UserStorageRepositoryException('Erro ao salvar usuário');

      expect(
        exception.toString(),
        'UserStorageRepositoryException: Erro ao salvar usuário',
      );
    });
  });
}
