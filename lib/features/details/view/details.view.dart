import 'package:desafio_tecnico_bus2/features/details/viewmodel/details.viewmodel.dart';
import 'package:desafio_tecnico_bus2/shared/models/user.model.dart';
import 'package:desafio_tecnico_bus2/shared/widgets/widgets.imports.dart';
import 'package:flutter/material.dart';

class DetailsView extends StatefulWidget {
  const DetailsView({super.key, required this.selectedUser});

  final UserModel selectedUser;

  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  final _viewModel = DetailsViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.checkIfUserIsSaved(widget.selectedUser.login.uuid);
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
            body: _viewModel.isLoading
                ? Center(child: CircularProgressIndicator())
                : UserDetailsWidget(user: widget.selectedUser),
            floatingActionButton: SaveFabWidget(
              show: _viewModel.isUserSaved,
              isLoading: _viewModel.isLoading,
              onPressed: () async {
                await _viewModel.onPressSave(widget.selectedUser);
              },
            ),
          );
        },
      ),
    );
  }
}
