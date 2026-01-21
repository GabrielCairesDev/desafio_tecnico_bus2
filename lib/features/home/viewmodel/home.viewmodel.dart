import 'package:desafio_tecnico_bus2/shared/models/models.imports.dart';
import 'package:desafio_tecnico_bus2/shared/services/user.services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class HomeViewModel extends ChangeNotifier {
  List<UserModel> listUsers = [];
  final errorMessage = ValueNotifier<String>('');

  static const int _intervalSeconds = 5;

  Ticker? _ticker;
  int _lastExecutionSecond = 0;

  Future<void> initialize(TickerProvider vsync) async {
    await fetchUser();
    startTicker(vsync);
  }

  void startTicker(TickerProvider vsync) {
    _ticker = vsync.createTicker((elapsed) {
      final currentSecond = elapsed.inSeconds;

      if (currentSecond > 0 &&
          currentSecond % _intervalSeconds == 0 &&
          currentSecond != _lastExecutionSecond) {
        _lastExecutionSecond = currentSecond;
        fetchUser();
      }
    });
    _ticker?.start();
  }

  Future<void> fetchUser() async {
    try {
      errorMessage.value = '';
      final newUser = (await UserService.getUser()).results;
      listUsers.addAll(newUser);
      notifyListeners();
    } catch (e) {
      errorMessage.value =
          'Erro ao carregar usuários. Verifique sua conexão com a internet.';
      debugPrint('Erro na requisição: $e');
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _ticker?.dispose();
    errorMessage.dispose();
    super.dispose();
  }
}
