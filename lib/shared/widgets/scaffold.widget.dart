import 'package:desafio_tecnico_bus2/shared/widgets/widgets.imports.dart';
import 'package:flutter/material.dart';

class ScaffoldWidget extends StatelessWidget {
  const ScaffoldWidget({
    super.key,
    required this.body,
    required this.title,
    this.isLoading = false,
    this.floatingActionButton,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  final Widget body;
  final String title;
  final bool isLoading;
  final Widget? floatingActionButton;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: title),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(padding: padding, child: body),
      floatingActionButton: floatingActionButton,
    );
  }
}
