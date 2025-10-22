import 'package:desafio_tecnico_bus2/shared/models/models.imports.dart';
import 'package:desafio_tecnico_bus2/shared/widgets/user_header.widget.dart';
import 'package:desafio_tecnico_bus2/shared/widgets/info_card.widget.dart';
import 'package:desafio_tecnico_bus2/shared/widgets/info_row.widget.dart';
import 'package:desafio_tecnico_bus2/shared/widgets/photo_row.widget.dart';
import 'package:flutter/material.dart';

class UserDetailsWidget extends StatelessWidget {
  const UserDetailsWidget({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header com avatar e nome principal
          UserHeaderWidget(user: user),

          const SizedBox(height: 24),

          // Cards de informações organizados
          InfoCardWidget(
            icon: Icons.person_outline,
            title: 'Informações Pessoais',
            children: [
              InfoRowWidget(
                label: 'Nome',
                value: user.name.fullName,
                icon: Icons.badge_outlined,
              ),
              InfoRowWidget(
                label: 'Gênero',
                value: user.gender,
                icon: Icons.wc_outlined,
              ),
              InfoRowWidget(
                label: 'Nacionalidade',
                value: user.nat,
                icon: Icons.flag_outlined,
              ),
              InfoRowWidget(
                label: 'Idade',
                value: '${user.dob.age} anos',
                icon: Icons.cake_outlined,
              ),
              InfoRowWidget(
                label: 'Data de Nascimento',
                value: user.dob.formattedDate,
                icon: Icons.calendar_today_outlined,
              ),
            ],
          ),

          const SizedBox(height: 16),

          InfoCardWidget(
            icon: Icons.contact_phone_outlined,
            title: 'Contato',
            children: [
              InfoRowWidget(
                label: 'Email',
                value: user.email,
                icon: Icons.email_outlined,
              ),
              InfoRowWidget(
                label: 'Telefone',
                value: user.phone,
                icon: Icons.phone_outlined,
              ),
              InfoRowWidget(
                label: 'Celular',
                value: user.cell,
                icon: Icons.phone_android_outlined,
              ),
            ],
          ),

          const SizedBox(height: 16),

          InfoCardWidget(
            icon: Icons.location_on_outlined,
            title: 'Endereço',
            children: [
              InfoRowWidget(
                label: 'Rua',
                value: user.location.street.fullAddress,
                icon: Icons.streetview_outlined,
              ),
              InfoRowWidget(
                label: 'Cidade',
                value: user.location.city,
                icon: Icons.location_city_outlined,
              ),
              InfoRowWidget(
                label: 'Estado',
                value: user.location.state,
                icon: Icons.map_outlined,
              ),
              InfoRowWidget(
                label: 'País',
                value: user.location.country,
                icon: Icons.public_outlined,
              ),
              InfoRowWidget(
                label: 'CEP',
                value: user.location.postcode,
                icon: Icons.local_post_office_outlined,
              ),
            ],
          ),

          const SizedBox(height: 16),

          InfoCardWidget(
            icon: Icons.gps_fixed_outlined,
            title: 'Coordenadas',
            children: [
              InfoRowWidget(
                label: 'Latitude',
                value: user.location.coordinates.latitude,
                icon: Icons.navigation_outlined,
              ),
              InfoRowWidget(
                label: 'Longitude',
                value: user.location.coordinates.longitude,
                icon: Icons.navigation_outlined,
              ),
              InfoRowWidget(
                label: 'Fuso Horário',
                value: user.location.timezone.description,
                icon: Icons.schedule_outlined,
              ),
              InfoRowWidget(
                label: 'Offset',
                value: user.location.timezone.offset,
                icon: Icons.access_time_outlined,
              ),
            ],
          ),

          const SizedBox(height: 16),

          InfoCardWidget(
            icon: Icons.login_outlined,
            title: 'Login',
            children: [
              InfoRowWidget(
                label: 'UUID',
                value: user.login.uuid,
                icon: Icons.fingerprint_outlined,
              ),
              InfoRowWidget(
                label: 'Username',
                value: user.login.username,
                icon: Icons.account_circle_outlined,
              ),
              InfoRowWidget(
                label: 'Password',
                value: user.login.password,
                icon: Icons.lock_outlined,
              ),
              InfoRowWidget(
                label: 'Salt',
                value: user.login.salt,
                icon: Icons.security_outlined,
              ),
              InfoRowWidget(
                label: 'MD5',
                value: user.login.md5,
                icon: Icons.vpn_key_outlined,
              ),
              InfoRowWidget(
                label: 'SHA1',
                value: user.login.sha1,
                icon: Icons.vpn_key_outlined,
              ),
              InfoRowWidget(
                label: 'SHA256',
                value: user.login.sha256,
                icon: Icons.vpn_key_outlined,
              ),
              InfoRowWidget(
                label: 'Data de Registro',
                value: user.registered.formattedDate,
                icon: Icons.app_registration_outlined,
              ),
            ],
          ),

          const SizedBox(height: 16),

          InfoCardWidget(
            icon: Icons.credit_card_outlined,
            title: 'Identificação',
            children: [
              InfoRowWidget(
                label: 'ID Name',
                value: user.id.name,
                icon: Icons.badge_outlined,
              ),
              InfoRowWidget(
                label: 'ID Value',
                value: user.id.value,
                icon: Icons.credit_card_outlined,
              ),
            ],
          ),

          const SizedBox(height: 16),

          InfoCardWidget(
            icon: Icons.photo_library_outlined,
            title: 'Fotos',
            children: [
              PhotoRowWidget(
                label: 'Foto Grande',
                url: user.picture.large,
                icon: Icons.photo_size_select_large_outlined,
              ),
              PhotoRowWidget(
                label: 'Foto Média',
                url: user.picture.medium,
                icon: Icons.photo_size_select_actual_outlined,
              ),
              PhotoRowWidget(
                label: 'Miniatura',
                url: user.picture.thumbnail,
                icon: Icons.photo_size_select_small_outlined,
              ),
            ],
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
