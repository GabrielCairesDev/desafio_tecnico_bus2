import 'package:desafio_tecnico_bus2/features/details/view/details.view.dart';
import 'package:desafio_tecnico_bus2/features/home/view/home.view.dart';
import 'package:desafio_tecnico_bus2/features/users/view/users.view.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String home = '/home';
  static const String details = '/detail';
  static const String users = '/users';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const HomeView(),
          settings: settings,
        );
      case details:
        return MaterialPageRoute<bool?>(
          builder: (_) => const DetailsView(),
          settings: settings,
        );
      case users:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const UsersView(),
          settings: settings,
        );
      default:
        return null;
    }
  }

  // Mantido para compatibilidade, mas não será usado
  static final Map<String, WidgetBuilder> routes = {
    home: (context) => const HomeView(),
    details: (context) => const DetailsView(),
    users: (context) => const UsersView(),
  };
}
