import 'dart:convert';

class CustomException implements Exception {

  final String message;
  final String? error;
  final int? statusCode;
  final double? internalCode;

  CustomException({
    this.message = 'Ocurrió un error inesperado. Por favor, inténtalo nuevamente.',
    this.error,
    this.statusCode,
    this.internalCode,
  });

  factory CustomException.custom(String? errorMessage) => CustomException(message: "Ha ocurrido un error inesperado. ${errorMessage ?? "Por favor intenta más tarde."}");

  factory CustomException.fromJson(Map<String, dynamic> json) => CustomException(
    message: json['mensaje'] as String,
    error: json['error'] as String?,
    statusCode: json['codigoHttp'] as int?,
    internalCode: json['codigoInterno'] as double?,
  );

  toJson() => {
    'mensaje': message,
    'error': error,
    'codigoHttp': statusCode,
    'codigoInterno': internalCode,
  };

  @override
  String toString() => jsonEncode(toJson());
}