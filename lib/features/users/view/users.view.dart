import 'package:desafio_tecnico_bus2/features/users/viewmodel/users.viewmodel.dart';
import 'package:desafio_tecnico_bus2/shared/widgets/widgets.imports.dart';
import 'package:flutter/material.dart';

class UsersView extends StatefulWidget {
  const UsersView({super.key});

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  final _viewModel = UsersViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        return ScaffoldWidget(
          title: 'Usuários Persistidos',
          body: _viewModel.listUsers.isEmpty
              ? Center(child: Text('Nenhum usuário persistido'))
              : ListUsersWidget(
                  listUsers: _viewModel.listUsers,
                  onTap: (user) => _viewModel.navigateToDetails(context, user),
                  onTapDelete: (user) => _viewModel.removeUser(user),
                ),
        );
      },
    );
  }
}
