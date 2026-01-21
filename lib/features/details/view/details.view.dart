import 'package:desafio_tecnico_bus2/config/injection.dart';
import 'package:desafio_tecnico_bus2/features/details/viewmodel/details.viewmodel.dart';
import 'package:desafio_tecnico_bus2/shared/models/user.model.dart';
import 'package:desafio_tecnico_bus2/shared/repositories/repositories.imports.dart';
import 'package:desafio_tecnico_bus2/shared/services/selected_user.service.dart';
import 'package:desafio_tecnico_bus2/shared/widgets/widgets.imports.dart';
import 'package:flutter/material.dart';

class DetailsView extends StatefulWidget {
  const DetailsView({super.key});

  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  late final DetailsViewModel _viewModel;
  late final UserModel _selectedUser;

  @override
  void initState() {
    super.initState();
    final selectedUserService = getIt<SelectedUserService>();
    final user = selectedUserService.selectedUser;

    if (user == null) {
      throw Exception(
        'Nenhum usuário selecionado. É necessário selecionar um usuário antes de navegar para detalhes.',
      );
    }

    _selectedUser = user;
    _viewModel = DetailsViewModel(
      userStorageRepository: getIt<IUserStorageRepository>(),
    );
    _viewModel.checkIfUserIsSaved(_selectedUser.login.uuid);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (_viewModel.isUserSaved == false) {
          Navigator.pop(context, true);
          return false;
        }
        return true;
      },
      child: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, child) {
          return ScaffoldWidget(
            isLoading: _viewModel.isLoading,
            title: 'Detalhes',
            errorMessage: _viewModel.errorMessage,
            body: _viewModel.isLoading
                ? Center(child: CircularProgressIndicator())
                : UserDetailsWidget(user: _selectedUser),
            floatingActionButton: SaveFabWidget(
              show: _viewModel.isUserSaved,
              isLoading: _viewModel.isLoading,
              onPressed: () async {
                await _viewModel.onPressSave(_selectedUser);
              },
            ),
          );
        },
      ),
    );
  }
}
