import 'package:desafio_tecnico_bus2/shared/models/login.model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Login', () {
    test('deve criar Login a partir de JSON válido', () {
      final json = {
        'uuid': '123e4567-e89b-12d3-a456-426614174000',
        'username': 'johndoe',
        'password': 'password123',
        'salt': 'salt123',
        'md5': 'md5hash',
        'sha1': 'sha1hash',
        'sha256': 'sha256hash',
      };

      final login = Login.fromJson(json);

      expect(login.uuid, '123e4567-e89b-12d3-a456-426614174000');
      expect(login.username, 'johndoe');
      expect(login.password, 'password123');
      expect(login.salt, 'salt123');
      expect(login.md5, 'md5hash');
      expect(login.sha1, 'sha1hash');
      expect(login.sha256, 'sha256hash');
    });

    test('deve criar Login com valores padrão quando JSON está vazio', () {
      final login = Login.fromJson({});

      expect(login.uuid, '');
      expect(login.username, '');
      expect(login.password, '');
      expect(login.salt, '');
      expect(login.md5, '');
      expect(login.sha1, '');
      expect(login.sha256, '');
    });

    test('deve converter Login para JSON corretamente', () {
      final login = Login(
        uuid: '987e6543-e21b-34c5-b567-537725285111',
        username: 'janesmith',
        password: 'pass456',
        salt: 'salt456',
        md5: 'md5hash2',
        sha1: 'sha1hash2',
        sha256: 'sha256hash2',
      );

      final json = login.toJson();

      expect(json['uuid'], '987e6543-e21b-34c5-b567-537725285111');
      expect(json['username'], 'janesmith');
      expect(json['password'], 'pass456');
      expect(json['salt'], 'salt456');
      expect(json['md5'], 'md5hash2');
      expect(json['sha1'], 'sha1hash2');
      expect(json['sha256'], 'sha256hash2');
    });
  });
}
