import 'package:desafio_tecnico_bus2/shared/models/user.model.dart';
import 'package:desafio_tecnico_bus2/shared/repositories/repositories.imports.dart';
import 'package:desafio_tecnico_bus2/shared/exceptions/repository_exception.dart';
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
    final user = _selectedUserService.takeSelectedUser();

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
        await _userStorageRepository.removeUser(user.login.uuid);
        _isUserSaved = false;
      } else {
        await _userStorageRepository.saveUser(user);
        _isUserSaved = true;
      }
    } on UserStorageRepositoryException catch (e) {
      _errorMessage = e.message;
      debugPrint('Erro no repositório de armazenamento: $e');
    } catch (e) {
      _errorMessage = _isUserSaved
          ? 'Erro ao remover usuário. Tente novamente.'
          : 'Erro ao salvar usuário. Tente novamente.';
      debugPrint('Erro inesperado ao salvar usuário: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkIfUserIsSaved(String userUuid) async {
    try {
      _errorMessage = '';
      _isUserSaved = await _userStorageRepository.isUserSaved(userUuid);
    } on UserStorageRepositoryException catch (e) {
      _errorMessage = e.message;
      debugPrint('Erro ao verificar status do usuário: $e');
    } catch (e) {
      _errorMessage = 'Erro ao verificar status do usuário.';
      debugPrint('Erro inesperado ao verificar usuário: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _selectedUserService.clearSelectedUser();
    super.dispose();
  }
}
