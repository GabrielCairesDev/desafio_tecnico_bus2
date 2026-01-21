import 'package:desafio_tecnico_bus2/shared/models/user.model.dart';

class SelectedUserService {
  UserModel? _selectedUser;

  UserModel? get selectedUser => _selectedUser;

  bool get hasSelectedUser => _selectedUser != null;

  void setSelectedUser(UserModel user) {
    if (user.login.uuid.isEmpty) {
      throw ArgumentError(
        'Não é possível selecionar um usuário sem UUID válido',
      );
    }
    _selectedUser = user;
  }

  void clearSelectedUser() {
    _selectedUser = null;
  }

  UserModel? takeSelectedUser() {
    final user = _selectedUser;
    _selectedUser = null;
    return user;
  }
}
