import 'package:desafio_tecnico_bus2/features/details/view/details.view.dart';
import 'package:desafio_tecnico_bus2/features/home/view/home.view.dart';
import 'package:desafio_tecnico_bus2/features/users/view/users.view.dart';
import 'package:desafio_tecnico_bus2/shared/models/user.model.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String home = '/home';
  static const String details = '/detail';
  static const String users = '/users';

  static final Map<String, WidgetBuilder> routes = {
    home: (context) => const HomeView(),
    details: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is UserModel) {
        return DetailsView(selectedUser: args);
      }
      throw Exception('UserModel argument is required for details route');
    },
    users: (context) => const UsersView(),
  };
}
