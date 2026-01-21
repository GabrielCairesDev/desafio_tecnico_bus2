import 'package:desafio_tecnico_bus2/shared/models/user.model.dart';
import 'package:desafio_tecnico_bus2/shared/repositories/repositories.imports.dart';
import 'package:desafio_tecnico_bus2/shared/exceptions/repository_exception.dart';
import 'package:desafio_tecnico_bus2/shared/services/navigation.service.dart';
import 'package:desafio_tecnico_bus2/shared/services/selected_user.service.dart';
import 'package:flutter/material.dart';

class UsersViewModel extends ChangeNotifier {
  final IUserStorageRepository _userStorageRepository;
  final SelectedUserService _selectedUserService;

  bool _isLoading = true;
  List<UserModel> _listUsers = [];
  String _errorMessage = '';
  Future<void>? _getUsersFuture;
  Future<void>? _removeUserFuture;

  bool get isLoading => _isLoading;
  List<UserModel> get listUsers => List.unmodifiable(_listUsers);
  String get errorMessage => _errorMessage;

  UsersViewModel({
    required IUserStorageRepository userStorageRepository,
    required SelectedUserService selectedUserService,
  }) : _userStorageRepository = userStorageRepository,
       _selectedUserService = selectedUserService;

  void getUsers() async {
    if (_getUsersFuture != null) {
      return _getUsersFuture!;
    }

    _getUsersFuture = _performGetUsers();
    try {
      await _getUsersFuture;
    } finally {
      _getUsersFuture = null;
    }
  }

  Future<void> _performGetUsers() async {
    try {
      _isLoading = true;
      _errorMessage = '';
      notifyListeners();

      _listUsers = await _userStorageRepository.getAllUsers();
    } on UserStorageRepositoryException catch (e) {
      _errorMessage = e.message;
      debugPrint('Erro no repositório de armazenamento: $e');
    } catch (e) {
      _errorMessage = 'Erro ao carregar lista de usuários salvos.';
      debugPrint('Erro inesperado ao carregar lista de usuários: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void removeUser(UserModel user) async {
    if (_removeUserFuture != null) {
      return _removeUserFuture!;
    }

    _removeUserFuture = _performRemoveUser(user);
    try {
      await _removeUserFuture;
    } finally {
      _removeUserFuture = null;
    }
  }

  Future<void> _performRemoveUser(UserModel user) async {
    try {
      _isLoading = true;
      _errorMessage = '';
      notifyListeners();

      await _userStorageRepository.removeUser(user.login.uuid);
      _listUsers = _listUsers
          .where((u) => u.login.uuid != user.login.uuid)
          .toList();
    } on UserStorageRepositoryException catch (e) {
      _errorMessage = e.message;
      debugPrint('Erro no repositório de armazenamento: $e');
    } catch (e) {
      _errorMessage = 'Erro ao remover usuário. Tente novamente.';
      debugPrint('Erro inesperado ao remover usuário: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshUsers() async {
    getUsers();
  }

  Future<void> navigateToDetails(BuildContext context, UserModel user) async {
    _selectedUserService.setSelectedUser(user);
    final result = await NavigationService.navigateToDetails(context);
    if (result == true) {
      refreshUsers();
    }
  }
}
