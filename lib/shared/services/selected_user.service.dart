import 'package:desafio_tecnico_bus2/shared/models/user.model.dart';

class SelectedUserService {
  UserModel? _selectedUser;

  UserModel? get selectedUser => _selectedUser;

  void setSelectedUser(UserModel user) {
    _selectedUser = user;
  }

  void clearSelectedUser() {
    _selectedUser = null;
  }
}
