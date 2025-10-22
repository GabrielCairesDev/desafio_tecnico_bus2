import 'package:flutter/material.dart';

class SaveFabWidget extends StatelessWidget {
  const SaveFabWidget({
    super.key,
    required this.show,
    required this.isLoading,
    required this.onPressed,
  });

  final bool show;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox.shrink();
    }

    return FloatingActionButton(
      backgroundColor: show ? Colors.red : null,
      onPressed: onPressed,
      child: Icon(
        show ? Icons.delete : Icons.save,
        color: show ? Colors.white : null,
      ),
    );
  }
}
