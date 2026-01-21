import 'package:desafio_tecnico_bus2/shared/models/user.model.dart';
import 'package:desafio_tecnico_bus2/shared/repositories/repositories.imports.dart';
import 'package:desafio_tecnico_bus2/shared/services/navigation.service.dart';
import 'package:desafio_tecnico_bus2/shared/services/selected_user.service.dart';
import 'package:flutter/material.dart';

class UsersViewModel extends ChangeNotifier {
  final IUserStorageRepository _userStorageRepository;
  final SelectedUserService _selectedUserService;

  bool isLoading = true;
  List<UserModel> listUsers = [];
  final errorMessage = ValueNotifier<String>('');

  UsersViewModel({
    required IUserStorageRepository userStorageRepository,
    required SelectedUserService selectedUserService,
  })  : _userStorageRepository = userStorageRepository,
        _selectedUserService = selectedUserService;

  void getUsers() async {
    try {
      errorMessage.value = '';
      listUsers = await _userStorageRepository.getAllUsers();
    } catch (e) {
      errorMessage.value = 'Erro ao carregar lista de usuários salvos.';
      debugPrint('Erro ao carregar lista de usuários: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void removeUser(UserModel user) async {
    try {
      errorMessage.value = '';
      final success = await _userStorageRepository.removeUser(user.login.uuid);
      if (success) {
        listUsers.remove(user);
      } else {
        errorMessage.value = 'Erro ao remover usuário. Tente novamente.';
      }
    } catch (e) {
      errorMessage.value = 'Erro ao remover usuário. Tente novamente.';
      debugPrint('Erro ao remover usuário: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshUsers() async {
    getUsers();
  }

  /// Navega para a tela de detalhes do usuário selecionado
  Future<void> navigateToDetails(BuildContext context, UserModel user) async {
    _selectedUserService.setSelectedUser(user);
    final result = await NavigationService.navigateToDetails(context);
    if (result == true) {
      refreshUsers();
    }
  }

  @override
  void dispose() {
    errorMessage.dispose();
    super.dispose();
  }
}
