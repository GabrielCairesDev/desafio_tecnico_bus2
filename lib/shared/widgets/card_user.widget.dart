import 'package:desafio_tecnico_bus2/constants/colors.constants.dart';
import 'package:desafio_tecnico_bus2/shared/widgets/widgets.imports.dart';
import 'package:flutter/material.dart';

class CardUserWidget extends StatelessWidget {
  const CardUserWidget({
    super.key,
    required this.name,
    required this.gender,
    required this.birthDate,
    required this.avatarUrl,
    required this.onTap,
    this.onTapDelete,
  });

  final String name;
  final String gender;
  final String birthDate;
  final String avatarUrl;
  final VoidCallback onTap;
  final VoidCallback? onTapDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorsConstants.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                spacing: 16,
                children: [
                  AvatarWidget(url: avatarUrl),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nome: $name'),
                      Text('Gênero: $gender'),
                      Text('Nascimento: $birthDate'),
                    ],
                  ),
                ],
              ),
            ),
            if (onTapDelete != null)
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  onPressed: onTapDelete,
                  icon: Icon(Icons.delete, color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
