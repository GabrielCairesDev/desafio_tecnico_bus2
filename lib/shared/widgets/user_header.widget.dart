import 'package:desafio_tecnico_bus2/constants/colors.constants.dart';
import 'package:desafio_tecnico_bus2/shared/models/models.imports.dart';
import 'package:desafio_tecnico_bus2/shared/widgets/avatar.widget.dart';
import 'package:flutter/material.dart';

class UserHeaderWidget extends StatelessWidget {
  const UserHeaderWidget({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorsConstants.secondary.withValues(alpha: 0.1),
            ColorsConstants.primary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColorsConstants.secondary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          AvatarWidget(url: user.picture.large),
          const SizedBox(height: 16),
          Text(
            user.name.fullName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: ColorsConstants.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            user.email,
            style: const TextStyle(
              fontSize: 16,
              color: ColorsConstants.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
