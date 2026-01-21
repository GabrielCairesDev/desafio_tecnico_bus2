import 'package:desafio_tecnico_bus2/shared/models/models.imports.dart';
import 'package:desafio_tecnico_bus2/shared/repositories/repositories.imports.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class HomeViewModel extends ChangeNotifier {
  final IUserRepository _userRepository;

  List<UserModel> listUsers = [];
  final errorMessage = ValueNotifier<String>('');

  static const int _intervalSeconds = 5;

  Ticker? _ticker;
  int _lastExecutionSecond = 0;

  HomeViewModel({required IUserRepository userRepository})
    : _userRepository = userRepository;

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
      final newUsers = await _userRepository.getUsers();
      listUsers.addAll(newUsers);
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
