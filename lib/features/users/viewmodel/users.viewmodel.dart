import 'package:desafio_tecnico_bus2/shared/models/user.model.dart';
import 'package:desafio_tecnico_bus2/shared/repositories/repositories.imports.dart';
import 'package:desafio_tecnico_bus2/shared/services/navigation.service.dart';
import 'package:desafio_tecnico_bus2/shared/services/selected_user.service.dart';
import 'package:flutter/material.dart';

class UsersViewModel extends ChangeNotifier {
  final IUserStorageRepository _userStorageRepository;
  final SelectedUserService _selectedUserService;

  bool _isLoading = true;
  List<UserModel> _listUsers = [];
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  List<UserModel> get listUsers => List.unmodifiable(_listUsers);
  String get errorMessage => _errorMessage;

  UsersViewModel({
    required IUserStorageRepository userStorageRepository,
    required SelectedUserService selectedUserService,
  })  : _userStorageRepository = userStorageRepository,
        _selectedUserService = selectedUserService;

  void getUsers() async {
    try {
      _errorMessage = '';
      _listUsers = await _userStorageRepository.getAllUsers();
    } catch (e) {
      _errorMessage = 'Erro ao carregar lista de usuários salvos.';
      debugPrint('Erro ao carregar lista de usuários: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void removeUser(UserModel user) async {
    try {
      _errorMessage = '';
      final success = await _userStorageRepository.removeUser(user.login.uuid);
      if (success) {
        _listUsers = _listUsers.where((u) => u.login.uuid != user.login.uuid).toList();
      } else {
        _errorMessage = 'Erro ao remover usuário. Tente novamente.';
      }
    } catch (e) {
      _errorMessage = 'Erro ao remover usuário. Tente novamente.';
      debugPrint('Erro ao remover usuário: $e');
    } finally {
      _isLoading = false;
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
    super.dispose();
  }
}
