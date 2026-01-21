import 'package:desafio_tecnico_bus2/shared/models/user.model.dart';
import 'package:desafio_tecnico_bus2/shared/repositories/repositories.imports.dart';
import 'package:desafio_tecnico_bus2/shared/services/selected_user.service.dart';
import 'package:flutter/material.dart';

class DetailsViewModel extends ChangeNotifier {
  final IUserStorageRepository _userStorageRepository;
  final SelectedUserService _selectedUserService;

  bool _isLoading = true;
  bool _isUserSaved = false;
  UserModel? _selectedUser;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  bool get isUserSaved => _isUserSaved;
  UserModel? get selectedUser => _selectedUser;
  String get errorMessage => _errorMessage;

  DetailsViewModel({
    required IUserStorageRepository userStorageRepository,
    required SelectedUserService selectedUserService,
  }) : _userStorageRepository = userStorageRepository,
       _selectedUserService = selectedUserService;

  void initialize() {
    _isLoading = true;
    final user = _selectedUserService.selectedUser;

    if (user == null) {
      throw Exception(
        'Nenhum usuário selecionado. É necessário selecionar um usuário antes de navegar para detalhes.',
      );
    }

    _selectedUser = user;
    checkIfUserIsSaved(_selectedUser!.login.uuid);
  }

  Future<void> onPressSave(UserModel user) async {
    try {
      _errorMessage = '';
      if (_isUserSaved) {
        final success = await _userStorageRepository.removeUser(
          user.login.uuid,
        );
        if (success) {
          _isUserSaved = false;
        } else {
          _errorMessage = 'Erro ao remover usuário. Tente novamente.';
        }
      } else {
        final success = await _userStorageRepository.saveUser(user);
        if (success) {
          _isUserSaved = true;
        } else {
          _errorMessage = 'Erro ao salvar usuário. Tente novamente.';
        }
      }
    } catch (e) {
      _errorMessage = _isUserSaved
          ? 'Erro ao remover usuário. Tente novamente.'
          : 'Erro ao salvar usuário. Tente novamente.';
      debugPrint('Erro ao salvar usuário: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkIfUserIsSaved(String userUuid) async {
    try {
      _errorMessage = '';
      _isUserSaved = await _userStorageRepository.isUserSaved(userUuid);
    } catch (e) {
      _errorMessage = 'Erro ao verificar status do usuário.';
      debugPrint('Erro ao verificar usuário: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
