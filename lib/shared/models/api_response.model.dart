import 'user.model.dart';

class ApiResponse {
  final List<UserModel> results;
  final Info info;

  ApiResponse({required this.results, required this.info});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    var resultsList = json['results'] as List<dynamic>? ?? [];
    return ApiResponse(
      results: resultsList.map((item) => UserModel.fromJson(item)).toList(),
      info: Info.fromJson(json['info'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'results': results.map((user) => user.toJson()).toList(),
      'info': info.toJson(),
    };
  }
}

class Info {
  final String seed;
  final int results;
  final int page;
  final String version;

  Info({
    required this.seed,
    required this.results,
    required this.page,
    required this.version,
  });

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      seed: json['seed'] ?? '',
      results: json['results'] ?? 0,
      page: json['page'] ?? 0,
      version: json['version'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'seed': seed, 'results': results, 'page': page, 'version': version};
  }
}
