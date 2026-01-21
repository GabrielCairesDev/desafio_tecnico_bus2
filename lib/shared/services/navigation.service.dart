import 'package:desafio_tecnico_bus2/config/routes.config.dart';
import 'package:flutter/material.dart';

class NavigationService {
  static Future<bool?> navigateToDetails(BuildContext context) async {
    return await Navigator.pushNamed<bool?>(context, Routes.details);
  }

  static void navigateToUsers(BuildContext context) {
    Navigator.pushNamed(context, Routes.users);
  }

  static void pop(BuildContext context, {bool? result}) {
    Navigator.pop(context, result);
  }
}
