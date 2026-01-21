import 'package:desafio_tecnico_bus2/config/routes.config.dart';
import 'package:desafio_tecnico_bus2/shared/models/models.imports.dart';
import 'package:desafio_tecnico_bus2/shared/services/user.services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class HomeViewModel extends ChangeNotifier {
  List<UserModel> listUsers = [];

  static const int _intervalSeconds = 5;

  Ticker? _ticker;
  int _lastExecutionSecond = 0;

  void startTicker(TickerProvider vsync) {
    _ticker = vsync.createTicker((elapsed) {
      final currentSecond = elapsed.inSeconds;

      if (currentSecond > 0 &&
          currentSecond % _intervalSeconds == 0 &&
          currentSecond != _lastExecutionSecond) {
        _lastExecutionSecond = currentSecond;
        onTick();
      }
    });
    _ticker?.start();
  }

  void onTick() async {
    try {
      final newUser = (await UserService.getUser()).results;
      listUsers.addAll(newUser);
      notifyListeners();
    } catch (e) {
      debugPrint('Erro na requisição: $e');
    }
  }

  void navigateToUsers(BuildContext context) {
    Navigator.pushNamed(context, Routes.users);
  }

  void navigateToDetails(BuildContext context, UserModel user) {
    Navigator.pushNamed(context, Routes.details, arguments: user);
  }

  @override
  void dispose() {
    _ticker?.dispose();
    super.dispose();
  }
}
