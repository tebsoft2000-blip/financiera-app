class AppException implements Exception {
  AppException(this.message, {this.statusCode = 0, this.code});

  final String message;
  final int statusCode;
  final String? code;

  @override
  String toString() => message;
}
