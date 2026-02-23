/// Base API exception
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  ApiException(
    this.message, {
    this.statusCode,
    this.originalError,
  });

  @override
  String toString() => 'ApiException: $message';
}

/// Network connectivity exception
class NetworkException extends ApiException {
  NetworkException(super.message);

  @override
  String toString() => 'NetworkException: $message';
}

/// Server error exception (5xx)
class ServerException extends ApiException {
  ServerException(super.message, {super.statusCode});

  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}

/// Validation exception (4xx)
class ValidationException extends ApiException {
  ValidationException(super.message);

  @override
  String toString() => 'ValidationException: $message';
}

/// Unauthorized exception (401)
class UnauthorizedException extends ApiException {
  UnauthorizedException() : super('Unauthorized access', statusCode: 401);

  @override
  String toString() => 'UnauthorizedException: Unauthorized access';
}

/// Not found exception (404)
class NotFoundException extends ApiException {
  NotFoundException(super.message)
      : super(statusCode: 404);

  @override
  String toString() => 'NotFoundException: $message';
}

/// Timeout exception
class TimeoutException extends ApiException {
  TimeoutException() : super('Request timeout');

  @override
  String toString() => 'TimeoutException: Request timeout';
}