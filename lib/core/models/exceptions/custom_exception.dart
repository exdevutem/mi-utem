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

  factory CustomException.unknown() => CustomException.custom();

  factory CustomException.custom({ String? message, int? statusCode, double? internalCode}) => CustomException(message: "Ha ocurrido un error inesperado. ${message ?? "Por favor intenta más tarde."}", statusCode: statusCode, internalCode: internalCode);

  factory CustomException.fromJson(Map<String, dynamic> json) => CustomException(
    message: json['mensaje'] as String,
    error: json['error'] as String?,
    statusCode: json['codigoHttp'] as int?,
    internalCode: json['codigoInterno'] is num ? double.tryParse("${json['codigoInterno']}") : json['codigoInterno'] as double?,
  );

  factory CustomException.fromSiga(Map<String, dynamic> json) => CustomException.custom(message: json['response'] ?? json['message'], statusCode: json['status_code']);

  toJson() => {
    'mensaje': message,
    'error': error,
    'codigoHttp': statusCode,
    'codigoInterno': internalCode,
  };

  @override
  String toString() => jsonEncode(toJson());
}