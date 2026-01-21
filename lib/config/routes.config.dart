import 'package:desafio_tecnico_bus2/features/details/view/details.view.dart';
import 'package:desafio_tecnico_bus2/features/home/view/home.view.dart';
import 'package:desafio_tecnico_bus2/features/users/view/users.view.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String home = '/home';
  static const String details = '/detail';
  static const String users = '/users';

  static final Map<String, WidgetBuilder> routes = {
    home: (context) => const HomeView(),
    details: (context) => const DetailsView(),
    users: (context) => const UsersView(),
  };
}
