import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

const sigaServiceUri = 'https://siga.utem.cl/servicios'; // UTEM SIGA API URL

final logger = Logger(printer: PrettyPrinter());
final secureStorage = FlutterSecureStorage();
