import 'package:desafio_tecnico_bus2/config/routes.config.dart';
import 'package:desafio_tecnico_bus2/features/home/view/home.view.dart';
import 'package:flutter/material.dart';

class AppConfig extends StatelessWidget {
  const AppConfig({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Desafio Técnico Bus2',
      routes: Routes.routes,
      home: const HomeView(),
    );
  }
}
