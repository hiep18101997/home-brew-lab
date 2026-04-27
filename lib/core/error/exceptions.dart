/// Exception thrown when a server-side error occurs
class ServerException implements Exception {
  final String message;
  final String? code;

  const ServerException({required this.message, this.code});

  @override
  String toString() => 'ServerException: $message (code: $code)';
}

/// Exception thrown when a cache error occurs
class CacheException implements Exception {
  final String message;

  const CacheException({required this.message});

  @override
  String toString() => 'CacheException: $message';
}

/// Exception thrown when a resource is not found
class NotFoundException implements Exception {
  final String message;

  const NotFoundException({required this.message});

  @override
  String toString() => 'NotFoundException: $message';
}