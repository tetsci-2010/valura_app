class AppException implements Exception {
  final String errorMessage;
  final String? statusCode;

  const AppException(this.errorMessage, [this.statusCode]);
}
