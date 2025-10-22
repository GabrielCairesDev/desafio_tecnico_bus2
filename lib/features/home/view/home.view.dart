// lib/features/home/view/home.view.dart
import 'package:desafio_tecnico_bus2/shared/widgets/widgets.imports.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../viewmodel/home.viewmodel.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  final _viewModel = HomeViewModel();

  static const int _intervalSeconds = 5;

  Ticker? _ticker;
  int _lastExecutionSecond = 0;

  @override
  void initState() {
    super.initState();
    _startTicker();
  }

  void _startTicker() {
    _ticker = createTicker((elapsed) {
      final currentSecond = elapsed.inSeconds;

      if (currentSecond > 0 &&
          currentSecond % _intervalSeconds == 0 &&
          currentSecond != _lastExecutionSecond) {
        _lastExecutionSecond = currentSecond;
        _viewModel.onTick();
      }
    });
    _ticker?.start();
  }

  @override
  void dispose() {
    _ticker?.dispose();
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
          body: ListUsersWidget(
            listUsers: _viewModel.listUsers,
            onTap: (user) => _viewModel.navigateToDetails(context, user),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _viewModel.navigateToUsers(context),
            child: Icon(Icons.storage),
          ),
        );
      },
    );
  }
}
