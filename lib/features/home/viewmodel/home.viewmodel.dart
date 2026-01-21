import 'package:desafio_tecnico_bus2/shared/models/models.imports.dart';
import 'package:desafio_tecnico_bus2/shared/repositories/repositories.imports.dart';
import 'package:desafio_tecnico_bus2/shared/services/navigation.service.dart';
import 'package:desafio_tecnico_bus2/shared/services/selected_user.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class HomeViewModel extends ChangeNotifier {
  final IUserRepository _userRepository;
  final SelectedUserService _selectedUserService;

  List<UserModel> listUsers = [];
  final errorMessage = ValueNotifier<String>('');

  static const int _intervalSeconds = 5;

  Ticker? _ticker;
  int _lastExecutionSecond = 0;

  HomeViewModel({
    required IUserRepository userRepository,
    required SelectedUserService selectedUserService,
  }) : _userRepository = userRepository,
       _selectedUserService = selectedUserService;

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

  Future<void> navigateToDetails(BuildContext context, UserModel user) async {
    _selectedUserService.setSelectedUser(user);
    await NavigationService.navigateToDetails(context);
  }

  void navigateToUsers(BuildContext context) {
    NavigationService.navigateToUsers(context);
  }

  @override
  void dispose() {
    _ticker?.dispose();
    errorMessage.dispose();
    super.dispose();
  }
}
