import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static const String sentryDsn = 'https://0af59b2ad2b44f4e8c9cad4ea8d5f32e@o507661.ingest.sentry.io/5599080';
  static const String uxCamDevKey = '0y6p88obpgiug1g';
  static const String uxCamProdKey = 'fxkjj5ulr7vb4yf';
  static String apiUrl = bool.fromEnvironment('dart.vm.product') ? 'https://api.exdev.cl' : (dotenv.env['MI_UTEM_API_DEBUG'] ?? 'https://api.exdev.cl');
}
