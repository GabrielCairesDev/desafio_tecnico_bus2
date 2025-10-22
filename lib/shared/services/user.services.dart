import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.imports.dart';
import '../../constants/urls.constants.dart';

class UserService {
  static Future<ApiResponse> getUser() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.api),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return ApiResponse.fromJson(data);
      } else {
        throw Exception('Erro ao carregar usuários: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro na requisição: $e');
    }
  }
}
