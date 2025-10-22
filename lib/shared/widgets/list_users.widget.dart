import 'package:desafio_tecnico_bus2/shared/models/models.imports.dart';
import 'package:desafio_tecnico_bus2/shared/widgets/widgets.imports.dart';
import 'package:flutter/material.dart';

class ListUsersWidget extends StatelessWidget {
  const ListUsersWidget({
    super.key,
    required this.listUsers,
    required this.onTap,
    this.onTapDelete,
  });

  final List<UserModel> listUsers;
  final Function(UserModel) onTap;
  final Function(UserModel)? onTapDelete;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listUsers.length,
      itemBuilder: (context, index) {
        final name =
            '${listUsers[index].name.first} ${listUsers[index].name.last}';
        final gender = listUsers[index].gender;
        final birthDate = listUsers[index].dob.formattedDate;
        final avatarUrl = listUsers[index].picture.large;
        return CardUserWidget(
          name: name,
          gender: gender,
          birthDate: birthDate,
          avatarUrl: avatarUrl,
          onTap: () => onTap(listUsers[index]),
          onTapDelete: onTapDelete != null
              ? () => onTapDelete!(listUsers[index])
              : null,
        );
      },
    );
  }
}
