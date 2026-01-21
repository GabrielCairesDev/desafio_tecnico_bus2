import 'package:desafio_tecnico_bus2/config/injection.dart';
import 'package:desafio_tecnico_bus2/features/details/viewmodel/details.viewmodel.dart';
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

  @override
  void initState() {
    super.initState();
    _viewModel = DetailsViewModel(
      userStorageRepository: getIt<IUserStorageRepository>(),
      selectedUserService: getIt<SelectedUserService>(),
    );
    _viewModel.initialize();
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
            body: _viewModel.isLoading || _viewModel.selectedUser == null
                ? Center(child: CircularProgressIndicator())
                : UserDetailsWidget(user: _viewModel.selectedUser!),
            floatingActionButton: SaveFabWidget(
              show: _viewModel.isUserSaved,
              isLoading: _viewModel.isLoading,
              onPressed: () async {
                if (_viewModel.selectedUser != null) {
                  await _viewModel.onPressSave(_viewModel.selectedUser!);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
