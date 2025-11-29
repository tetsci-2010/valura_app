class AppException implements Exception {
  final String errorMessage;
  final String? statusCode;

  const AppException({required this.errorMessage, this.statusCode});
}
