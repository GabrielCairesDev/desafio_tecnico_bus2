/// Exceção base para erros relacionados a repositories
class RepositoryException implements Exception {
  final String message;
  final Object? originalError;
  final StackTrace? stackTrace;

  RepositoryException(
    this.message, {
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() {
    if (originalError != null) {
      return 'RepositoryException: $message\nOriginal error: $originalError';
    }
    return 'RepositoryException: $message';
  }
}

/// Exceção específica para erros de repositório de usuários da API
class UserRepositoryException extends RepositoryException {
  UserRepositoryException(
    super.message, {
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() {
    return 'UserRepositoryException: $message';
  }
}

/// Exceção específica para erros de repositório de armazenamento
class UserStorageRepositoryException extends RepositoryException {
  UserStorageRepositoryException(
    super.message, {
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() {
    return 'UserStorageRepositoryException: $message';
  }
}
