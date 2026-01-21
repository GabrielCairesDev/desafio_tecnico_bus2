// lib/features/home/view/home.view.dart
import 'package:desafio_tecnico_bus2/config/injection.dart';
import 'package:desafio_tecnico_bus2/config/routes.config.dart';
import 'package:desafio_tecnico_bus2/shared/repositories/repositories.imports.dart';
import 'package:desafio_tecnico_bus2/shared/widgets/widgets.imports.dart';
import 'package:flutter/material.dart';
import '../viewmodel/home.viewmodel.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late final HomeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = HomeViewModel(userRepository: getIt<IUserRepository>());
    _viewModel.initialize(this);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        return ScaffoldWidget(
          title: 'Tela inicial',
          isLoading: _viewModel.listUsers.isEmpty,
          errorMessage: _viewModel.errorMessage,
          body: ListUsersWidget(
            listUsers: _viewModel.listUsers,
            onTap: (user) =>
                Navigator.pushNamed(context, Routes.details, arguments: user),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.pushNamed(context, Routes.users),
            child: Icon(Icons.storage),
          ),
        );
      },
    );
  }
}
