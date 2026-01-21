import 'package:desafio_tecnico_bus2/shared/widgets/app_bar.widget.dart';
import 'package:desafio_tecnico_bus2/shared/widgets/error_snackbar.widget.dart';
import 'package:flutter/material.dart';

class ScaffoldWidget extends StatefulWidget {
  const ScaffoldWidget({
    super.key,
    required this.body,
    required this.title,
    this.isLoading = false,
    this.floatingActionButton,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.errorMessage,
  });

  final Widget body;
  final String title;
  final bool isLoading;
  final Widget? floatingActionButton;
  final EdgeInsetsGeometry padding;
  final String? errorMessage;

  @override
  State<ScaffoldWidget> createState() => _ScaffoldWidgetState();
}

class _ScaffoldWidgetState extends State<ScaffoldWidget> {
  String? _lastErrorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleError();
    });
  }

  @override
  void didUpdateWidget(ScaffoldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.errorMessage != widget.errorMessage) {
      _handleError();
    }
  }

  void _handleError() {
    final errorMessage = widget.errorMessage;
    
    if (errorMessage != null && 
        errorMessage.isNotEmpty && 
        errorMessage != _lastErrorMessage) {
      _lastErrorMessage = errorMessage;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && widget.errorMessage != null && 
            widget.errorMessage!.isNotEmpty) {
          ErrorSnackBar.show(
            context,
            widget.errorMessage!,
          );
        }
      });
    } else if (errorMessage == null || errorMessage.isEmpty) {
      _lastErrorMessage = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: widget.title),
      body: widget.isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(padding: widget.padding, child: widget.body),
      floatingActionButton: widget.floatingActionButton,
    );
  }
}
