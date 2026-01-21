import 'package:desafio_tecnico_bus2/config/app.config.dart';
import 'package:desafio_tecnico_bus2/config/injection.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupInjection();
  runApp(const AppConfig());
}
