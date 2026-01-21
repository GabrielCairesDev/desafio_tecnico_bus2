import 'package:desafio_tecnico_bus2/config/routes.config.dart';
import 'package:flutter/material.dart';

class AppConfig extends StatelessWidget {
  const AppConfig({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Desafio Técnico Bus2',
      onGenerateRoute: Routes.onGenerateRoute,
      initialRoute: Routes.home,
    );
  }
}
